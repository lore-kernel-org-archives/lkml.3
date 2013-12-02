Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3LBMMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:12:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56518 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab3LBMMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:12:37 -0500
Message-ID: <529C7922.5000601@ti.com>
Date: Mon, 2 Dec 2013 14:12:18 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Michael Trimarchi <michael@amarulasolutions.com>,
        Felipe Balbi <balbi@ti.com>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>, <tomi.valkeinen@ti.com>,
        Stefan Roese <sr@denx.de>, <ljkenny.mailinglists@gmail.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>	<1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com> <529C55DF.3000808@ti.com> <529C76AF.10106@linutronix.de>
In-Reply-To: <529C76AF.10106@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 02:01 PM, Sebastian Andrzej Siewior wrote:
> - stable@vger.kernel.org since they probably don't care about this
>   unless the patch is merged.
> 
> On 12/02/2013 10:41 AM, Roger Quadros wrote:
>> Michael,
>>
>> On 11/29/2013 05:32 PM, Michael Trimarchi wrote:
>>> Hi Roger
>>>
>>> On Fri, Nov 29, 2013 at 2:01 PM, Roger Quadros <rogerq@ti.com> wrote:
>>>> With u-boot 2013.10, USB devices are sometimes not detected
>>>> on OMAP4 Panda. To make us independent of what bootloader does
>>>> with the USB Host module, we must RESET it to get it to a known
>>>> good state. This patch Soft RESETs the USB Host module.
>>>>
>>>
>>> Do you think that we need something similar of usb musb?
>>> I have seen the OTG_SYSCONFIG is touched in uboot and
>>> only readed in omap2430.c.
>>
>> I'm not sure about musb. Maybe Sebastian/Felipe have better idea.
>> In general I believe that all modules must be reset by the kernel.
>>
> 
> based on the code at the bottom it touches the first few register(s)
> sysconfig. Isn't hwmod actually doing this idle stuff and resting the
> device during boot?
> 

You are right. The musb hwmod data doesn't have the HWMOD_INIT_NO_RESET
flag, so hwmod should reset it during boot.

Maybe I too should just remove HWMOD_INIT_NO_RESET flag from the USB Host
hwmod data, then we don't need to change this driver at all.

Benoit, Tony any comments?

cheers,
-roger
