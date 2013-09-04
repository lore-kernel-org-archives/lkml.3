Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545Ab3IDJGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:06:08 -0400
Received: from smtp2-1.goneo.de ([212.90.139.83]:33314 "EHLO smtp2-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756776Ab3IDJGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:06:05 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.74
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Date: Wed, 04 Sep 2013 11:05:58 +0200
Message-ID: <3144247.j2q6H0KWZx@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52261BF0.4090106@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <1521079.WSLhhfqBXl@lem-wkst-02> <52261BF0.4090106@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 September 2013 11:27:12, Stephen Warren wrote:
> On 09/02/2013 03:25 AM, Lars Poeschel wrote:
> > Some leagcy drivers currently do this:
> > 
> > request_gpio(gpio);
> > gpio_direction_input(gpio);
> > request_irq(gpio_to_irq(gpio));
> > 
> > In that case request_irq should not fail because the driver is already the
> > correct owner of this gpio. But if some other entity owns this gpio it
> > should fail.
> 
> Yes.
> 
> > Also if I understand you correct the other way round should also possible:
> > 
> > request_irq(gpio_to_irq(gpio));
> > request_gpio(gpio);
> > gpio_direction_input(gpio);
> > 
> > request_irq() also requests the gpio then but the following request_gpio()
> > should also not fail.
> 
> I don't believe that code sequence is currently banned. If we want to
> ban it, we should document that. Until this is documented as being
> banned, I think we must fully support that code sequence.
> 
> > To have it work that way we have to track the owners of all requested
> > gpios
> > somewhere. Or am I wrong here?
> > Where and how to record these owners? Can gpio system achieve this? gpios
> > are requested without an owning device.
> 
> Yes. But, I believe we need to fully track every GPIO/IRQ owner already
> right now; if a driver (not the GPIO/IRQ chip driver, but a driver that
> uses the GPIOs/IRQs) calls gpio_request()/request_irq(), and this patch
> has already requested them, then we already need to fully track GPIO/IRQ
> ownership to make sure that the driver's own requests aren't failed
> because the DT/GPIO core has already requested them on its behalf.

The driver that tries to use the GPIO requested by this patch before HAS to 
fail. This is exactly the intention of this patch. We don't want the GPIO to 
be requested any more, if it is used as an interrupt pin.
To be able to implement the way you proposed some mails before, I have to be 
able to do some checks that to my opinion (and if I understand Linus 
correctly) aren't possible at the moment. So I asked, where and how to record 
these owners of the GPIOs? And can the GPIO system achieve this and how? Can 
you please shed some light on this! Thanks!

