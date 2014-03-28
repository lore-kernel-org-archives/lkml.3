Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaC1I6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:58:47 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:59937 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaC1I6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:58:43 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2S8vhm3017738, This message is accepted by code: ctloc85258
Message-ID: <53353981.7050302@realtek.com>
Date: Fri, 28 Mar 2014 16:57:37 +0800
From: Roger <rogerable@realtek.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>
Subject: Re: [PATCH v5 1/3] mfd: Add realtek USB card reader driver
References: <1395744293-24398-1-git-send-email-rogerable@realtek.com>		 <1395744293-24398-2-git-send-email-rogerable@realtek.com>	 <201403280231.s2S2VP8X017745@rtits1.realtek.com>	 <5334ED70.6050309@realtek.com> <1395995486.9520.2.camel@linux-fkkt.site>
In-Reply-To: <1395995486.9520.2.camel@linux-fkkt.site>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/28/2014 04:31 PM, Oliver Neukum wrote:
> On Fri, 2014-03-28 at 11:33 +0800, Roger wrote:
>> On 03/26/2014 10:36 PM, Oliver Neukum wrote:
>>> On Tue, 2014-03-25 at 18:44 +0800, rogerable@realtek.com wrote:
>>>> From: Roger Tseng <rogerable@realtek.com>
>
>>>> +	if (ret)
>>>> +		goto out_init_fail;
>>>> +
>>>> +	/* initialize USB SG transfer timer */
>>>> +	init_timer(&ucr->sg_timer);
>>>> +	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
>>>> +#ifdef CONFIG_PM
>>>> +	intf->needs_remote_wakeup = 1;
>>>
>>> Why?
>> Our reader supports remote wake-up from card slot event(insertion,
>> removal). It should be enabled to let the driver be able to detect the
>> newly inserted card.
>
> Interesting. This capability has been lacking for a long time.
> That is cool hardware. Are you sure the upper layers implement
> the event infrastructure so that devices are not polled?
>
Polling is still necessary because USB essentially doesn't support 
interrupt.

However, if remote wake-up is not enabled or supported, the device will 
have to be resumed every time when polling and then suspended right away 
if there isn't a new card. This should consume more power than the 
designed behavior: suspending device while card removed, taking failed 
polls as no-card, and card being successfully polled after 
insertion-triggered remote wake-up.

>> The LED is not in a permanent cut-off state after here. It is called to
>> guarantee the LED is off during suspend to save more power. It could be
>> lit up in the card host drivers(e.g. rtsx_usb_sdmmc.c) anytime whenever
>> necessary.
>>
>> This has been asked may times. I'm considering putting some comment in
>> next revision.
>
> Good idea.
>
> 	Regards
> 		Oliver

Best regards,
Roger Tseng
