Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaKGDNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:13:21 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:63936 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaKGDNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:13:17 -0500
Message-ID: <545C3893.3020003@huawei.com>
Date: Fri, 7 Nov 2014 11:12:19 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Tejun Heo <tj@kernel.org>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Weng Meiling <wengmeiling.weng@huawei.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] sysfs: driver core: Fix glue dir race condition
References: <1415261798-9671-1-git-send-email-wangyijing@huawei.com> <20141106165547.GG25642@htj.dyndns.org> <20141106172246.GA20192@kroah.com> <545C2408.60703@huawei.com> <20141107024654.GC22844@kroah.com>
In-Reply-To: <20141107024654.GC22844@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static DEFINE_MUTEX(gdp_mutex);
>>
>>  static struct kobject *get_device_parent(struct device *dev,
>>  					 struct device *parent)
>>  {
>>  	if (dev->class) {
>> -		static DEFINE_MUTEX(gdp_mutex);
>>  		struct kobject *kobj = NULL;
>>  		struct kobject *parent_kobj;
>>  		struct kobject *k;
>> @@ -793,7 +793,9 @@ static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
>>  	    glue_dir->kset != &dev->class->p->glue_dirs)
>>  		return;
>>
>> +	mutex_lock(&gdp_mutex);
>>  	kobject_put(glue_dir);
>> +	mutex_unlock(&gdp_mutex);
>>  }
>>
>>  static void cleanup_device_parent(struct device *dev)
>>
> 
> I much prefer this patch over the other one, as it keeps the same
> behavior as today, and fixes the existing bug.
> 
> Have you tested it out to see if it works properly?  If so, can you
> resend it in a "proper" form so I can apply it?

Yes, we tested it in our system, I will resend it now, thanks!

> 
> thanks,
> 
> greg k-h
> 
> .
> 


-- 
Thanks!
Yijing

