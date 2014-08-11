Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaHKJJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:09:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37423 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaHKJJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:09:52 -0400
Message-ID: <53E88851.6000705@collabora.co.uk>
Date: Mon, 11 Aug 2014 11:09:37 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Doug Anderson <dianders@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Stephen Warren <swarren@nvidia.com>,
        Yufeng Shen <miletus@chromium.org>, Benson Leung <bleung@chromium.org>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Abraham <thomas.ab@samsung.com>
Subject: Re: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags
 on DT booting
References: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk>	<53E4D9A5.908@itdev.co.uk>	<20140808162146.GC26820@core.coreip.homeip.net>	<53E4FD1B.6060600@collabora.co.uk>	<53E5170C.10302@collabora.co.uk>	<CAD=FV=WSNqjHLLbTh1LBF3RFrCnWnj498hivivcmx1SbuYp=Hw@mail.gmail.com>	<53E54E91.9060905@collabora.co.uk> <CACRpkdZ9-5Pw-SHFNuGtvxDDHrA13ShSSFN9uZRBLTfpe=m5ug@mail.gmail.com>
In-Reply-To: <CACRpkdZ9-5Pw-SHFNuGtvxDDHrA13ShSSFN9uZRBLTfpe=m5ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On 08/11/2014 10:32 AM, Linus Walleij wrote:
> I guess this discussion is about drivers/pinctrl/samsung/pinctrl-exynos.c?
> 
> Or else I'm not really following this... $SUBJECT is a bit confusing.
> 

Yes, the thing is that at the beginning I (wrongly) thought that the IRQ trigger
type flags defined in the DTS were discarded if someone called
request_threaded_irq() with a flags != 0. And since the atmel touchpad driver
was pass pdata->irqflags | IRQF_ONESHOT I posted this patch to get the trigger
type parsed from DT and pass it to request_threaded_irq().

But after digging further I found that the issue was in the pinctrl-exynos
driver and Tomasz explained to me that the real cause was that the pin was being
configured from GPIO IRQ to GPIO input (which on other platforms is just the
same mode but on Exynos are two different modes).

At the end passing the trigger type to request_threaded_irq() just had the side
effect to call the exynos .irq_set_type function handler that reconfigured the
pin as GPIO-IRQ and that is why it made it to work. So I posted a patch from
Tomasz that fixes the real cause [0].

I'm so sorry for the confusion.

> Yours,
> Linus Walleij
> 

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/8/8/962
