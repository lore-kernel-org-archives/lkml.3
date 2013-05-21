Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3EUIxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:53:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:27681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab3EUIxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:53:00 -0400
X-IronPort-AV: E=Sophos;i="4.87,713,1363104000"; 
   d="scan'208";a="7322401"
Message-ID: <519B355E.8020505@cn.fujitsu.com>
Date: Tue, 21 May 2013 16:50:38 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        David Miller <davem@davemloft.net>, libo.chen@huawei.com,
        gregkh@linuxfoundation.org, samuel@sortiz.org,
        stern@rowland.harvard.edu, khc@pm.waw.pl, akpm@linux-foundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com,
        alexander.shishkin@linux.intel.com, brudley@broadcom.com,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com> <20130520.232619.964940909999914694.davem@davemloft.net> <20130521084108.1a585f32@skate> <519B2993.4090409@cn.fujitsu.com> <519B2FC7.6000801@huawei.com>
In-Reply-To: <519B2FC7.6000801@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 16:51:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 16:51:38,
	Serialize complete at 2013/05/21 16:51:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 04:26 PM, Libo Chen wrote:

> On 2013/5/21 16:00, Gu Zheng wrote:
>> On 05/21/2013 02:41 PM, Thomas Petazzoni wrote:
>>
>>> Dear David Miller,
>>>
>>> On Mon, 20 May 2013 23:26:19 -0700 (PDT), David Miller wrote:
>>>> From: Libo Chen <libo.chen@huawei.com>
>>>> Date: Tue, 21 May 2013 10:42:00 +0800
>>>>
>>>>> I find a lot of mistakes using struct platform_driver without owner.
>>>>> So I pick up some of them including usb and net modules
>>>>
>>>> Instead of doing it this way, which is obviously error prone and
>>>> easy to forget, make platform_driver_register() be a macro which
>>>> sets the module owner field then calls the real
>>>> __platform_driver_register().
>>>
>>> Or, maybe make the existing module_platform_driver() macro do this?
>>
>>
>> But not all the modules use module_platform_driver() macro to replace the module init/exit.
>>
>> Thanks,
>> Gu
>>
> 
> yes, there are many drivers register platform_driver by platform_driver_register manually.
> 
> make both platform_driver_register() and module_platform_driver()  to check and set the module owner field?


No, module_platform_driver() will call platform_driver_register() to register platform_driver, just do it in
platform_driver_register() is enough.
As David mentioned, making platform_driver_register() be a macro and sets the module owner field in it, seems
a good way.

Thanks,
Gu

> 
> 
> 
>>>
>>> Best regards,
>>>
>>> Thomas
>>
>>
>>
>> .
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


