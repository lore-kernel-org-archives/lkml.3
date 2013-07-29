Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3G2Lrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 07:47:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:40422 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab3G2Lrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 07:47:41 -0400
Message-ID: <51F65636.6080505@huawei.com>
Date: Mon, 29 Jul 2013 19:47:02 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <libo.chen@huawei.com>
Subject: Re: [PATCH 1/9] syslog_ns: add syslog_namespace and put/get_syslog_ns
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> <1375065080-26740-2-git-send-email-rui.xiang@huawei.com> <51F6388B.8000308@cn.fujitsu.com>
In-Reply-To: <51F6388B.8000308@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/29 17:40, Gu Zheng wrote:
> Hi Rui,
> 	Refer to inline:).
> 
Hi Gu,

Thanks for your attention.

> On 07/29/2013 10:31 AM, Rui Xiang wrote:
> 
>> Add a struct syslog_namespace which contains the necessary
>> members for hanlding syslog and realize get_syslog_ns and
>> put_syslog_ns API.
>>
>> Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
>> ---
>>  include/linux/syslog.h | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  kernel/printk.c        |  7 ------
>>  2 files changed, 68 insertions(+), 7 deletions(-)
>>

...

>> +
>> +static inline void free_syslog_ns(struct kref *kref)
>> +{
>> +	struct syslog_namespace *ns;
>> +	ns = container_of(kref, struct syslog_namespace, kref);
>> +
>> +	kfree(ns->log_buf);
>> +	kfree(ns);
>> +}
> 
> This interface seems a bit ugly, why not use the format like put_syslog_ns()?
> 
> static inline void free_syslog_ns(struct syslog_namespace *ns)
> 

Free_syslog_ns is used in put_syslog_ns. And the kref_put function uses kref as
a parameter for its relase funtion. You can see that from 
static inline int kref_put(struct kref *kref, void (*release)(struct kref *kref)).

Thanks.

>> +
>> +static inline void put_syslog_ns(struct syslog_namespace *ns)
>> +{
>> +	if (ns)
>> +		kref_put(&ns->kref, free_syslog_ns);
>> +}
>> +
>> 

