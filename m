Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3HMLAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:00:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43918 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab3HMLAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:00:34 -0400
Message-ID: <1376391580.4039.8.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 4/9] PCI: mvebu: add support for reset on GPIO
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 13 Aug 2013 12:59:40 +0200
In-Reply-To: <520A0D1D.4050609@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <1376333215-12885-5-git-send-email-sebastian.hesselbarth@gmail.com>
	 <20130813080956.GE9316@ulmo> <20130813103030.1e4156a1@skate>
	 <20130813100348.GA28762@ulmo> <520A0D1D.4050609@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

Am Dienstag, den 13.08.2013, 12:40 +0200 schrieb Sebastian Hesselbarth:
> On 08/13/13 12:03, Thierry Reding wrote:
> > On Tue, Aug 13, 2013 at 10:30:30AM +0200, Thomas Petazzoni wrote:
> >> Dear Thierry Reding,
> >>
> >> On Tue, 13 Aug 2013 10:09:56 +0200, Thierry Reding wrote:
> >>
> >>>> +- reset-gpios: optional gpio to PERST#
> >>>> +- reset-delay-ms: delay in ms to wait after reset de-assertion
> >>>
> >>> I remember some recent discussion about this, and we now have this reset
> >>> framework, so perhaps it makes more sense to use the reset binding for
> >>> this? Cc'ing Stephen (as part of the device tree bindings maintainers
> >>> team) who was involved in that recent reset bindings discussion.
> >>
> >> I also thought about this, but the reset framework seems to be designed
> >> for "reset controller" IPs, i.e special IPs that are controlling reset
> >> signals. Looking at Documentation/devicetree/bindings/reset/reset.txt,
> >> I'm not sure to see how this would apply to GPIO-controlled reset
> >> signals.
> >
> > See:
> >
> > 	http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg36900.html
> >
> > which seems to have carried over to this at some point:
> >
> > 	http://www.spinics.net/lists/devicetree/msg00521.html
> >
> > Some of the messages in between I can't find in any archive, sorry.
> 
> Thierry, Sascha,
> 
> thanks for the input. Flipping through the above discussion, I guess
> using "reset-gpios" and "reset-delay-us" should be fine?
> 
> I can also remove the delay property for now, as I cannot find a final
> conclusion about the configurable delay.

Yes, I'm in favor of using 'reset-gpios'. If we can agree on this
binding, I'll add support to the reset framework core.

> In the driver, I will stick to bare gpiolib and wait for gpio-reset
> driver to become available. Currently, we don't have sophisticated
> reset handling in pci-mvebu anyway.

Sounds good to me.

regards
Philipp

