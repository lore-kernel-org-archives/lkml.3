Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3EUIbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:31:18 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51889 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3EUIbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:31:14 -0400
Message-ID: <519B2FC7.6000801@huawei.com>
Date: Tue, 21 May 2013 16:26:47 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        David Miller <davem@davemloft.net>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>, <samuel@sortiz.org>,
        <stern@rowland.harvard.edu>, <khc@pm.waw.pl>,
        <akpm@linux-foundation.org>, <balbi@ti.com>,
        <sarah.a.sharp@linux.intel.com>, <alexander.shishkin@linux.intel.com>,
        <brudley@broadcom.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>
Subject: Re: [PATCH 00/19] driver:usb&net: add missing platform_driver owner
References: <1369104120-35552-1-git-send-email-libo.chen@huawei.com> <20130520.232619.964940909999914694.davem@davemloft.net> <20130521084108.1a585f32@skate> <519B2993.4090409@cn.fujitsu.com>
In-Reply-To: <519B2993.4090409@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/21 16:00, Gu Zheng wrote:
> On 05/21/2013 02:41 PM, Thomas Petazzoni wrote:
> 
>> Dear David Miller,
>>
>> On Mon, 20 May 2013 23:26:19 -0700 (PDT), David Miller wrote:
>>> From: Libo Chen <libo.chen@huawei.com>
>>> Date: Tue, 21 May 2013 10:42:00 +0800
>>>
>>>> I find a lot of mistakes using struct platform_driver without owner.
>>>> So I pick up some of them including usb and net modules
>>>
>>> Instead of doing it this way, which is obviously error prone and
>>> easy to forget, make platform_driver_register() be a macro which
>>> sets the module owner field then calls the real
>>> __platform_driver_register().
>>
>> Or, maybe make the existing module_platform_driver() macro do this?
> 
> 
> But not all the modules use module_platform_driver() macro to replace the module init/exit.
> 
> Thanks,
> Gu
> 

yes, there are many drivers register platform_driver by platform_driver_register manually.

make both platform_driver_register() and module_platform_driver()  to check and set the module owner field?



>>
>> Best regards,
>>
>> Thomas
> 
> 
> 
> .
> 


