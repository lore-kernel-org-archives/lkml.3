Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3G3Aug (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:50:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:39466 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752011Ab3G3Aue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:50:34 -0400
X-IronPort-AV: E=Sophos;i="4.89,774,1367942400"; 
   d="scan'208";a="8062334"
Message-ID: <51F70CF5.9090003@cn.fujitsu.com>
Date: Tue, 30 Jul 2013 08:46:45 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rui Xiang <rui.xiang@huawei.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, gaofeng@cn.fujitsu.com,
        libo.chen@huawei.com
Subject: Re: [PATCH 1/9] syslog_ns: add syslog_namespace and put/get_syslog_ns
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-2-git-send-email-rui.xiang@huawei.com> <51F6388B.8000308@cn.fujitsu.com> <51F65636.6080505@huawei.com>
In-Reply-To: <51F65636.6080505@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/30 08:48:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/30 08:48:22,
	Serialize complete at 2013/07/30 08:48:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 07:47 PM, Rui Xiang wrote:

> On 2013/7/29 17:40, Gu Zheng wrote:
>> Hi Rui,
>> 	Refer to inline:).
>>
> Hi Gu,
> 
> Thanks for your attention.
> 
>> On 07/29/2013 10:31 AM, Rui Xiang wrote:
>>
>>> Add a struct syslog_namespace which contains the necessary
>>> members for hanlding syslog and realize get_syslog_ns and
>>> put_syslog_ns API.
>>>
>>> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
>>> ---
>>>  include/linux/syslog.h | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  kernel/printk.c        |  7 ------
>>>  2 files changed, 68 insertions(+), 7 deletions(-)
>>>
> 
> ...
> 
>>> +
>>> +static inline void free_syslog_ns(struct kref *kref)
>>> +{
>>> +	struct syslog_namespace *ns;
>>> +	ns = container_of(kref, struct syslog_namespace, kref);
>>> +
>>> +	kfree(ns->log_buf);
>>> +	kfree(ns);
>>> +}
>>
>> This interface seems a bit ugly, why not use the format like put_syslog_ns()?
>>
>> static inline void free_syslog_ns(struct syslog_namespace *ns)
>>
> 
> Free_syslog_ns is used in put_syslog_ns. And the kref_put function uses kref as
> a parameter for its relase funtion. You can see that from 
> static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)).

Got it.

Regards,
Gu

> 
> Thanks.
> 
>>> +
>>> +static inline void put_syslog_ns(struct syslog_namespace *ns)
>>> +{
>>> +	if (ns)
>>> +		kref_put(&ns->kref, free_syslog_ns);
>>> +}
>>> +
>>>
> 
> 


