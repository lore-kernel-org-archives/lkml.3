Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbaDWPhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:37:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719AbaDWPg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:36:56 -0400
Message-ID: <5357DE12.7040905@redhat.com>
Date: Wed, 23 Apr 2014 11:36:50 -0400
From: Daniel J Walsh <dwalsh@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Steve Grubb <sgrubb@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-audit@redhat.com, selinux@tycho.nsa.gov, jamal@mojatatu.com,
        davem@davemloft.net
Subject: Re: [PATCH 0/6][v2] audit: implement multicast socket for journald
References: <20140422.161904.1187535812839850973.davem@davemloft.net>	 <cover.1398215388.git.rgb@redhat.com> <26389161.vp9iWSVLPX@x2>	 <1398225475.750.7.camel@localhost> <5357C2D2.5060700@redhat.com> <1398264152.2596.25.camel@flatline.rdu.redhat.com>
In-Reply-To: <1398264152.2596.25.camel@flatline.rdu.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess the problem would be that the sysadm_t would be able to look at
the journal which would now contain the audit content.

On 04/23/2014 10:42 AM, Eric Paris wrote:
> On Wed, 2014-04-23 at 09:40 -0400, Daniel J Walsh wrote:
>> Here are the capabilities we currently give to sysadm_t with
>> sysadm_secadm    1.0.0    Disabled
>>
>>    allow sysadm_t sysadm_t : capability { chown dac_override
>> dac_read_search fowner fsetid kill setgid setuid setpcap linux_immutable
>> net_bind_service net_broadcast net_admin net_raw ipc_lock ipc_owner
>> sys_rawio sys_chroot sys_ptrace sys_pacct sys_admin sys_boot sys_nice
>> sys_resource sys_time sys_tty_config mknod lease audit_write setfcap } ;
>>    allow sysadm_t sysadm_t : capability { setgid setuid sys_chroot }
>>
>>    allow sysadm_t sysadm_t : capability2 { syslog block_suspend } ;
>>
>> cap_audit_write might be a problem?
> cap_audit_write is fine.
>
> syslogd_t (aka journal) is going to need the new permission
> cap_audit_read.  Also, as steve pointed out, someone may be likely to
> want to be able to disable that permission easily.
>
> -Eric
>

