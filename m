Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3IJIsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:48:08 -0400
Received: from smtp1.goneo.de ([212.90.139.80]:44753 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab3IJIsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:48:03 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.718
From: Lars Poeschel <poeschel@lemonage.de>
To: Mark Brown <broonie@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
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
Date: Tue, 10 Sep 2013 10:47:55 +0200
Message-ID: <2052193.CMUEUJFRgS@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130909161924.GT29403@sirena.org.uk>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 September 2013 17:19:24, Mark Brown wrote:
> On Wed, Sep 04, 2013 at 02:16:36PM -0600, Stephen Warren wrote:
> > On 09/04/2013 03:05 AM, Lars Poeschel wrote:
> > > The driver that tries to use the GPIO requested by this patch before HAS
> > > to
> > > fail. This is exactly the intention of this patch. We don't want the
> > > GPIO to be requested any more, if it is used as an interrupt pin.
> > 
> > That will break existing drivers. There are drivers that request the
> > same GPIO and IRQ. IIRC, the SDHCI CD (Card Detect) GPIO is requested
> > that way.
> 
> Yes, plus input devices and audio jack detection among others.  This
> pattern is very common if the GPIO is actually being used as a GPIO, an
> edge triggered interrupt is used to flag when something happens and the
> state is determined by reading the GPIO state (often with some
> debounce).

And I say it again for those coming into the discussion late, like it has been 
said many many times before: This patch does not break any of this drivers. 
They simply request their GPIO from DT and turn it into an irq using 
gpio_to_irq, request that irq on their behalf and use it as GPIO and IRQ in 
parallel. At least this is not a problem.
