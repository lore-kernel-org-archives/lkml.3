Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198Ab3LIC2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:28:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3LIC2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:28:16 -0500
X-IronPort-AV: E=Sophos;i="4.93,854,1378828800"; 
   d="scan'208";a="9218616"
Message-ID: <52A52AFB.2020703@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 10:29:15 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        toshi.okajima@jp.fujitsu.com, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com> <20131206213135.GA22445@mail.hallyn.com>
In-Reply-To: <20131206213135.GA22445@mail.hallyn.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 10:27:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 10:27:59,
	Serialize complete at 2013/12/09 10:27:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Serge,

Thanks for your comments!

On 12/07/2013 05:31 AM, Serge E. Hallyn wrote:
> Quoting Gao feng (gaofeng@cn.fujitsu.com):
>> Here is the v1 patchset: http://lwn.net/Articles/549546/
>>
>> The main target of this patchset is allowing user in audit
>> namespace to generate the USER_MSG type of audit message,
>> some userspace tools need to generate audit message, or
>> these tools will broken.
>>
>> And the login process in container may want to setup
>> /proc/<pid>/loginuid, right now this value is unalterable
>> once it being set. this will also broke the login problem
>> in container. After this patchset, we can reset this loginuid
>> to zero if task is running in a new audit namespace.
>>
>> Same with v1 patchset, in this patchset, only the privileged
>> user in init_audit_ns and init_user_ns has rights to
>> add/del audit rules. and these rules are gloabl. all
>> audit namespace will comply with the rules.
>>
>> Compared with v1, v2 patch has some big changes.
>> 1, the audit namespace is not assigned to user namespace.
>>    since there is no available bit of flags for clone, we
>>    create audit namespace through netlink, patch[18/20]
>>    introduces a new audit netlink type AUDIT_CREATE_NS.
>>    the privileged user in userns has rights to create a
>>    audit namespace, it means the unprivileged user can
>>    create auditns through create userns first. In order
>>    to prevent them from doing harm to host, the default
>>    audit_backlog_limit of un-init-audit-ns is zero(means
>>    audit is unavailable in audit namespace). and it can't
>>    be changed in auditns through netlink.
> 
> So the unprivileged user can create an audit-ns, but can't
> then actually send any messages there?  I guess setting it
> to something small would just be hacky?

Yes, if unprivileged user wants to send audit message, he should
ask privileged user to setup the audit_backlog_limit for him.

I know it's a little of hack, but I don't have good idea :(

