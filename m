Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3LBNgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:36:17 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33542 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3LBNgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:36:15 -0500
Message-ID: <529C8CBD.4070003@ti.com>
Date: Mon, 2 Dec 2013 15:35:57 +0200
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
References: <1385730118-26402-1-git-send-email-rogerq@ti.com>	<1385730118-26402-2-git-send-email-rogerq@ti.com> <CAOf5uwmEkzFd=e3j8m8=qdTCAMkk_-DPw0fTm=7Vzy0PbE2oDQ@mail.gmail.com> <529C55DF.3000808@ti.com> <529C76AF.10106@linutronix.de> <529C7922.5000601@ti.com> <529C854F.3010101@linutronix.de>
In-Reply-To: <529C854F.3010101@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 03:04 PM, Sebastian Andrzej Siewior wrote:
> On 12/02/2013 01:12 PM, Roger Quadros wrote:
>> You are right. The musb hwmod data doesn't have the HWMOD_INIT_NO_RESET
>> flag, so hwmod should reset it during boot.
>>
>> Maybe I too should just remove HWMOD_INIT_NO_RESET flag from the USB Host
>> hwmod data, then we don't need to change this driver at all.
>>
>> Benoit, Tony any comments?
> 
> Almost two years ago in commit de231388 ("ARM: OMAP: USB: EHCI and OHCI
> hwmod structures for OMAP3") the "don't reset flag" has been added by
> Keshava.
> 
> It refers to "Errata Id:i660" why it is required. Once you figured what
> why it has been added you could have an idea if it is okay to remove it
> and if the reset you do here might lead to it (I dunno).
> 

Keshava no longer works @TI. I have no other means to check why it was added
other than doing dome tests and making sure nothing breaks if we remove it.

So far, things are going fine for about 50 or so boots divided between OMAP3 and 4
platforms. If more people can test and give feedback it'd be great.

For the present situation, omap4 panda USB host doesn't work without the reset
with u-boot v2013.10.

cheers,
-roger
