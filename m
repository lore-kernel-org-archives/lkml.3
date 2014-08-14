Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaHNJhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:37:10 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35655 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaHNJhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 05:37:08 -0400
Message-ID: <1408008998.4035.43.camel@paszta.hi.pengutronix.de>
Subject: Re: [RFC PATCH v3] reset: Add a defer reset object to send board
 specific reset
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Houcheng Lin <houcheng@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, sre@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 14 Aug 2014 11:36:38 +0200
In-Reply-To: <20140811173356.GN15297@lukather>
References: <1403098673-3058-1-git-send-email-houcheng@gmail.com>
	 <CACRpkdYfu8HmVCkn9JFh+YP5OPdr8o9nTfoCnkJ7SSpGoenQUg@mail.gmail.com>
	 <20140708080535.GJ13423@lukather>
	 <CACRpkdbFPAsu1gE-AVyD=-RxyE7mUJPSbFga7HLh0mxjE-mQuQ@mail.gmail.com>
	 <1407507789.3354.20.camel@paszta.hi.pengutronix.de>
	 <20140811173356.GN15297@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Am Montag, den 11.08.2014, 19:33 +0200 schrieb Maxime Ripard:
> > Mostly because Maxime and I seem to have a completely different opinion
> > and nobody else argued one way or the other.
> 
> Yep, mostly because I don't see how a generic approach can work.
> 
> The existing reset-gpios property only provide the gpio to use, but
> some informations are encoded in the driver, such as the reset
> duration, or a reset sequence if any.

The driver should provide the duration. I'd really like to see an
example where sequencing is necessary.
I agree that as soon as things get significantly more complicated than
pulsing a single GPIO, the reset-gpios binding is too limited.
Still, I'm not happy to mandate a separate gpio reset device for each
reset line if most devices are simple enough for it to work without.
What about using reset-gpios for the majority of simple cases and have a
separate gpio-reset-sequencer driver when multiple GPIO resets have to
be timed?

> How do you plan on giving that information to your generic driver?
> 
> The only solution I can think of would be to add an extra property
> that your code would parse. But then, you break the existing DT
> bindings.
>
> And if we're going to break those bindings, at least do it in a way
> consistent with reset bindings.

For the backwards compatibility case, the driver already has to provide
the duration. I don't want to break the existing bindings at all.

> Plus, your approach doesn't cover the weird corner cases such as:
>   - reset-gpio
>   - wlf,reset-gpios
>   - phy-reset-gpios
>   - snps,reset-gpio
>   - the drivers that need several gpio and expect the reset one as a
>     positional argument.
>   - etc.

Those are just an issue of the implementation I posted earlier because
gpiod_get doesn't support custom names other than %s-gpios. This could
be extended and handled just as well if deemed necessary.

regards
Philipp

