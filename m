Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaHKIcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:32:23 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55395 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaHKIcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:32:20 -0400
MIME-Version: 1.0
In-Reply-To: <53E54E91.9060905@collabora.co.uk>
References: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk>
	<53E4D9A5.908@itdev.co.uk>
	<20140808162146.GC26820@core.coreip.homeip.net>
	<53E4FD1B.6060600@collabora.co.uk>
	<53E5170C.10302@collabora.co.uk>
	<CAD=FV=WSNqjHLLbTh1LBF3RFrCnWnj498hivivcmx1SbuYp=Hw@mail.gmail.com>
	<53E54E91.9060905@collabora.co.uk>
Date: Mon, 11 Aug 2014 10:32:19 +0200
Message-ID: <CACRpkdZ9-5Pw-SHFNuGtvxDDHrA13ShSSFN9uZRBLTfpe=m5ug@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags on
 DT booting
From: Linus Walleij <linus.walleij@linaro.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I guess this discussion is about drivers/pinctrl/samsung/pinctrl-exynos.c?

Or else I'm not really following this... $SUBJECT is a bit confusing.

On Sat, Aug 9, 2014 at 12:26 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:

> Regardless of this though I think that both the patch to move the IRQ
> pinmux setup from .irq_set_type to the .irq_request_resources and the patch to
> to prevent any pinmux reconfiguration are good improvements to avoid future
> issues like the one we found here.

I think someone should look into switching the Samsung/Exynos pinctrl
driver to the gpiolib irqchip helpers, I looked at it but was scared by
the special wkup chip and stuff I can't test.

The irqchip helpers will atleast help out in flagging GPIO lines as
used for IRQs so the core can keep track of stuff and show that
properly in debugfs.

The orthogonality compliance between GPIO and irqchip must
however be solved in the driver itself, the core only helps out
in blocking some abuse of the API.

Yours,
Linus Walleij
