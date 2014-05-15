Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaEOIAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:00:04 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:62192 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaEOIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:00:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        gregory.clement@free-electrons.com, robherring2@gmail.com,
        marc.zyngier@arm.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 4/6] arm: add basic support for Mediatek MT6589 boards
Date: Thu, 15 May 2014 09:58:30 +0200
Message-ID: <4623149.HtC2qgQ8vE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140514212612.GK20486@codeaurora.org>
References: <1399938570-11356-1-git-send-email-matthias.bgg@gmail.com> <20140514070038.GG29258@lukather> <20140514212612.GK20486@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:eyaPY3eXQFhLvsDIqY38+Od3ogLlHMvPEB7iSs+nZkA
 oiG4NZq8WdXKAQCjvpDrpi3VkIm94lxC6EuTaj0FhSiOgbe9lX
 4VolpvEuOr7WL3SxxDKJnyqSArCipMelziVSczRlDZJd3c30/F
 kJMao0Cms+wH0u5FPXrhP+NTfy3d7tMr4wht1Pu2FTeUninxas
 CrxlCVhN7E3z7QsJttkU1/KZYm211ty6W4RcL0/IliV1ufc4he
 9v3KIDRgT0e9p0RfEX6NsFCaGzo2GtFBKePSCXtGDOiLet5mlS
 f/sEP/E28+PU+fiqT0dd4dVrDh+gRsv3uV9uShV4//gC+GoZJd
 VPhuAe1cQHxoSNYcWR9c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 14:26:12 Stephen Boyd wrote:
> On 05/14, Maxime Ripard wrote:
> > On Tue, May 13, 2014 at 03:47:32PM -0700, Stephen Boyd wrote:
> > > On 05/13, Matthias Brugger wrote:
> > > > +	"mediatek,mt6589",
> > > > +	NULL,
> > > > +};
> > > > +
> > > > +DT_MACHINE_START(MEDIATEK_DT, "Mediatek Cortex-A7 (Device Tree)")
> > > > +	.dt_compat	= mediatek_board_dt_compat,
> > > > +MACHINE_END
> > > 
> > > You shouldn't need this file at all if the platform is part of
> > > the multi-platform kernel.
> > 
> > From a technical point of view, you don't. But it's interesting to
> > keep it mostly for two things:
> >   - You get to see the platform name in /proc/cpuinfo
> >   - If you ever need to add platform quirks, it's already there
> > 
> > We had a similar discussion two weeks ago for mach-sunxi with Olof and
> > Arnd, and ended up keeping this minimal machine.
> > 
> 
> It looks like it's only useful to make /proc/cpuinfo have the
> platform name because it really isn't that hard to add this file
> if we need to add platform quirks. The downside is we have to
> keep adding compatibles when we support new SoCs.

We also still add Kconfig entries for each new platform, and I'd like
to leave it at that for the time being. In a lot of cases we end
up adding stuff to the machine descriptor later, e.g. for SMP support
(hopefully no more thanks to your work though).

Once we have a significant number of machines that are actually
usable rather than stubs and that we are confident about never
needing any additional pointers, we can revisit this discussion.

At that point, we should also discuss how to avoid adding a Kconfig
entry for each new platform, which e.g. involves making the
clocksource drivers user selectable. That part has been surprisingly
controversial in the past.

	Arnd
