Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaHHX6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:58:55 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:37085 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaHHX6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <53E54E91.9060905@collabora.co.uk>
References: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk>
	<53E4D9A5.908@itdev.co.uk>
	<20140808162146.GC26820@core.coreip.homeip.net>
	<53E4FD1B.6060600@collabora.co.uk>
	<53E5170C.10302@collabora.co.uk>
	<CAD=FV=WSNqjHLLbTh1LBF3RFrCnWnj498hivivcmx1SbuYp=Hw@mail.gmail.com>
	<53E54E91.9060905@collabora.co.uk>
Date: Fri, 8 Aug 2014 16:58:49 -0700
X-Google-Sender-Auth: Lx3AzqVCpRFHwFDxcg4FCnEiHCk
Message-ID: <CAD=FV=UvSMseufvTPpNv+qdA9+gXLtrWhgf7pB8f941zLtt7TQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags on
 DT booting
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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

Javier,

On Fri, Aug 8, 2014 at 3:26 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
>> I have some vague recollection that I set interrupts to pin-function
>> "0" by default for some reason (assuming they would go to 0xf when
>> interrupts were enabled).  ...but I can't for the life of me remember
>> if it was a good reason or just seemed like the right thing to do.
>>
>
> It would be great to know if there is a good reason. I see indeed that all
> pinctrl setup in the Peach Pit/Pi and Snow DTS that involves interrupts are
> using 0x0 as the pin function. Since as Tomasz explained Samsung SoC makes a
> difference between GPIO-IRQ and GPIO input I guess that it's better to change
> those to 0xf instead. What do you think?

I think it's worth trying out.  If there are no problems with it then
let's do it.

My vague recollection is that I was worried that pinctrl would take
effect right at driver probe time (maybe this used to happen? or maybe
I imagined it?) and that configuring to 0xf at this point in time
would cause a spurious interrupt.  I can't remember ever testing it so
it was probably just something I imagined.  Even if it was configured
as 0xf I'd imagine that the interrupt would be masked anyway so there
should be no spurious interrupt, right?


> Regardless of this though I think that both the patch to move the IRQ
> pinmux setup from .irq_set_type to the .irq_request_resources and the patch to
> to prevent any pinmux reconfiguration are good improvements to avoid future
> issues like the one we found here.

OK.  I'll let you, Tomasz, and Linus figure out what's best here since
I haven't done extensive thinking on it.  ;)

-Doug
