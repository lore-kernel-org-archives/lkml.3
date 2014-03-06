Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbaCFCFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 21:05:23 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9877 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755758AbaCFCFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 21:05:22 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zcb8kz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 6 Mar 2014 10:05:16 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: imx6qdl-sabresd.dtsi: Add red led
Message-ID: <20140306020514.GC11366@S2101-09.ap.freescale.net>
References: <20140305062216.GI8784@S2101-09.ap.freescale.net>
 <1394007383-21874-1-git-send-email-vincent.stehle@freescale.com>
 <20140305114223.GN8784@S2101-09.ap.freescale.net>
 <20140305193925.GY21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140305193925.GY21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 07:39:26PM +0000, Russell King - ARM Linux wrote:
> On Wed, Mar 05, 2014 at 07:42:28PM +0800, Shawn Guo wrote:
> > It's not a hog pin, so shouldn't be added here.  (Right, most of the
> > existing pins shouldn't be here from the beginning)
> 
> On the subject of that kind of thing... I have an issue with the existing
> pinmux stuff.  This is a wider issue than your discussion above...
> 
> I regard the idea of requiring the pinmux to be configured as part of
> the driver probe a rather broken concept - yes, it makes sense in some
> scenarios, but for the vast majority of cases, it doesn't.

>From what I've seen, it's the opposite - the concept works for the
majority, and only some scenarios needs special handling.

> 
> Let's take an example.  A pin is wired to a SPDIF transceiver.  The
> out-of-reset SoC configuration results in the pin turning the LED on
> in the SPDIF transceiver.
> 
> With the way stuff is setup, with the driver having the pinmux settings
> for itself, the point at which that pin gets configured is when the
> driver loads, which may be a module - so that can happen quite late in
> the boot sequence.  A failure to boot can result in it not happening at
> all.
> 
> So, this brings up the obvious question: is this proper behaviour of the
> hardware, or is this something we should do better with - such as where
> we know what the settings should be for a platform, and these settings
> never change, we arrange for that to happen at kernel boot time as a
> once-off.
> 
> For example, in the above case, we know it's board XYZ, we know that this
> pin is connected to the SPDIF transceiver, so maybe we should configure
> it early on in the boot sequence whether or not the driver has been
> configured and/or loaded.

For such special case, I'm fine with using hog group to handle it.  But
IMO, bootloader is even a better place to correct such unreasonable
out-of-reset SoC configuration for particular board.

Shawn

