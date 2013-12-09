Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246Ab3LICFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:05:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:35650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760165Ab3LICFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:05:18 -0500
X-IronPort-AV: E=Sophos;i="4.93,854,1378828800"; 
   d="scan'208";a="9218447"
Message-ID: <52A52599.3070502@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 10:06:17 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        eparis@redhat.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com> <529EE877.7030701@cn.fujitsu.com> <20131206221241.GD22445@mail.hallyn.com>
In-Reply-To: <20131206221241.GD22445@mail.hallyn.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 10:04:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 10:05:00,
	Serialize complete at 2013/12/09 10:05:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2013 06:12 AM, Serge E. Hallyn wrote:
> Quoting Gao feng (gaofeng@cn.fujitsu.com):
>> Hi
>>
>> On 10/24/2013 03:31 PM, Gao feng wrote:
>>> Here is the v1 patchset: http://lwn.net/Articles/549546/
>>>
>>> The main target of this patchset is allowing user in audit
>>> namespace to generate the USER_MSG type of audit message,
>>> some userspace tools need to generate audit message, or
>>> these tools will broken.
>>>
>>
>> I really need this feature, right now,some process such as
>> logind are broken in container becase we leak of this feature.
> 
> Your set doesn't address loginuid though right?  How exactly do you
> expect to do that?  If user violates MAC policy and audit msg is
> sent to init user ns by mac subsys, you need the loginuid from
> init_audit_ns.  where will that be stored if you allow updates
> of loginuid in auditns?
> 
This patchset doesn't include the loginuid part.

the loginuid is stored in task as before.
In my opinion, when task creates a new audit namespace, this task's
loginuid will be reset to zero, so the children tasks can set their
loginuid. Does this change break the MAC?

Thanks!
