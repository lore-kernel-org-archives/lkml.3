Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3G2KA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 06:00:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab3G2KA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 06:00:26 -0400
X-IronPort-AV: E=Sophos;i="4.89,768,1367942400"; 
   d="scan'208";a="8057169"
Message-ID: <51F63C4B.2090907@cn.fujitsu.com>
Date: Mon, 29 Jul 2013 17:56:27 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: Rui Xiang <rui.xiang@huawei.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, serge.hallyn@ubuntu.com,
        ebiederm@xmission.com, akpm@linux-foundation.org, libo.chen@huawei.com
Subject: Re: [PATCH 2/9] syslog_ns: add syslog_ns into user_namespace
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-3-git-send-email-rui.xiang@huawei.com> <51F639FB.304@cn.fujitsu.com> <51F63BD2.6090902@cn.fujitsu.com>
In-Reply-To: <51F63BD2.6090902@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 17:58:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 17:58:03,
	Serialize complete at 2013/07/29 17:58:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 05:54 PM, Gao feng wrote:

> On 07/29/2013 05:46 PM, Gu Zheng wrote:
>> Hi Rui,
>>
>> On 07/29/2013 10:31 AM, Rui Xiang wrote:
>>
>>> Add a syslog_ns pointer to user_namespace, and make
>>> syslog_ns per user_namespace, not global.
>>>
>>> Since syslog_ns is assigned to user_ns, we can have
>>> full capabilities in new user_ns to create a new syslog_ns.
>>>
>>> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
>>> ---
>>>  include/linux/syslog.h         | 5 +++++
>>>  include/linux/user_namespace.h | 1 +
>>>  2 files changed, 6 insertions(+)
>>>
>>> diff --git a/include/linux/syslog.h b/include/linux/syslog.h
>>> index 425fafe..62ce47f 100644
>>> --- a/include/linux/syslog.h
>>> +++ b/include/linux/syslog.h
>>> @@ -90,6 +90,11 @@ struct syslog_namespace {
>>>  	size_t syslog_partial;
>>>  
>>>  	int dmesg_restrict;
>>> +
>>> +	/*
>>> +	 * user namespace which owns this syslog ns.
>>> +	 */
>>> +	struct user_namespace *owner;
>>>  };
>>>  
>>>  static inline struct syslog_namespace *get_syslog_ns(
>>> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
>>> index b6b215f..ce2de5b 100644
>>> --- a/include/linux/user_namespace.h
>>> +++ b/include/linux/user_namespace.h
>>> @@ -28,6 +28,7 @@ struct user_namespace {
>>>  	unsigned int		proc_inum;
>>>  	bool			may_mount_sysfs;
>>>  	bool			may_mount_proc;
>>> +	struct syslog_namespace *syslog_ns;
>>
>> As we add a syslog_ns pointer to user_namespace to make
>> syslog_ns per user_namespace and the caps check.
>> But why also add a point to syslog_namespace in
>> user_namespace? Am I missing something?:)
>>
> 
> yep,with this we can make sure all the other types of namespace such as mount, net, pid
> can access syslog_ns through user namespace.

Got it.:)

Thanks,
Gu

> 
> 


