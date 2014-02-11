Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaBKRhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:37:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43224 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaBKRhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:37:08 -0500
Message-ID: <1392140209.6943.49.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH] reset: Add generic GPIO reset driver.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: "Fuzzey, Martin" <mfuzzey@parkeon.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 18:36:49 +0100
In-Reply-To: <CANh8QzwERe-zxCaAd4QujZJ4zcZ7SchK+w8u52fvJj0s5tx2nA@mail.gmail.com>
References: <20140210125432.10683.86571.stgit@localhost>
	 <1392038191.6687.12.camel@pizza.hi.pengutronix.de>
	 <CANh8QzwERe-zxCaAd4QujZJ4zcZ7SchK+w8u52fvJj0s5tx2nA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

Am Dienstag, den 11.02.2014, 10:34 +0100 schrieb Fuzzey, Martin:
[...]
> >> 2) Allow hardware on discoverable busses to be rest via a GPIO line
> >> without driver modifications.
> >>
> >> Examples of the second use case include:
> >> * SDIO wifi modules
> >> * USB hub chips with a reset line
> >
> > Now this is interesting. But if you export it to userspace anyway, why
> > not use the existing gpio sysfs API?
> >
> 
> In the normal case of reset on boot the userspace interface isn't needed.
> Setting the "auto" dt property will make the kernel do the reset by
> itself during
> early boot. This is the standard use case.
> 
> The userspace interface is to let applications deal with special cases.
> It is also simpler for userspace than manlually toggling the GPIO line
> and keeps the configuration (active high / low, delay) centralised in
> the DT and consistent between the automatic on boot reset and the
> manually triggered reset.
>
> > I think a proper solution should handle this in the kernel. For SDIO
> > wifi modules you usually have a powerdown line that can be implemented
> > as an rfkill switch.
> >
> 
> I think this is too specific. It's not just for SDIO wifi. We also
> have the problem
> of a USB hub needing to be reset.
> 
> Also even for the SDIO wifi case rfkill doesn't ssem the right
> abstraction to say "reset me"
> (particularly when firmware fails to load on warm boot if you don't).

so long as you need to take devices out of reset before they can be
discovered, maybe the corresponding host controller would be the right
place to put the reset.

regards
Philipp

