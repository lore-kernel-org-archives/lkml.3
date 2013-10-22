Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3JVW6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:58:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:48486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3JVW6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="397004338"
Message-ID: <5267041F.2090905@linux.intel.com>
Date: Tue, 22 Oct 2013 16:02:55 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: gregkh@linuxfoundation.org, jslaby@suse.cz, ning.li@intel.com,
        ivan.gorinov@intel.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/2] mrst_max3110: fix SPI UART interrupt parameters
References: <1382470930-13807-1-git-send-email-david.a.cohen@linux.intel.com> <1382470930-13807-2-git-send-email-david.a.cohen@linux.intel.com> <1382471160.205404749@f402.i.mail.ru> <5266E070.2060408@linux.intel.com>
In-Reply-To: <5266E070.2060408@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 01:30 PM, David Cohen wrote:
> On 10/22/2013 12:46 PM, Alexander Shiyan wrote:
>>> The change in the max3110 driver makes the IRQ handling threaded, now
>>> the handler is called only once per received character. Without that
>>> change, we had many (more than 100) interrupts per one received
>>> character.
>>>
>>> Unfortunately, SFI interface does not support IRQ polarity and
>>> triggering modes, so we have to keep the hacks as hard-coded device
>>> names and IRQ numbers until we switch to ACPI.
>>>
>>> Edge-triggered IRQ still supported to keep old platforms working.
>>> Use platform data to pass the irq mode argument.
>>>
>>> Signed-off-by: Ivan Gorinov <ivan.gorinov@intel.com>
>>> Signed-off-by: Li Ning <ning.li@intel.com>
>>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>> ...
>>> +++ b/include/linux/serial_max3110.h
>>> @@ -0,0 +1,16 @@
>>> +#ifndef _LINUX_SERIAL_MAX3110_H
>>> +#define _LINUX_SERIAL_MAX3110_H
>>> +
>>> +/**
>>> + * struct plat_max3110 - MAX3110 SPI UART platform data
>>> + * @irq_edge_trigger: if IRQ is edge triggered
>>> + *
>>> + * You should use this structure in your machine description to specify
>>> + * how the MAX3110 is connected.
>>> + *
>>> + */
>>> +struct plat_max3110 {
>>> +    int irq_edge_triggered;
>>> +};
>>> +
>>> +#endif
>>> --
>>
>> Is just resource->flags for IRQ can be reused for handle such case?
>
> I believe your suggestion makes perfect sense. I'll rework it.

Looks like isp_device has no place for 'resource'. In this case pdata 
seems to be the way to go here.
Or maybe there's a better way to recommend?

Br, David Cohen
