Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaENV0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:26:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34257 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaENV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:26:15 -0400
Date: Wed, 14 May 2014 14:26:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 4/6] arm: add basic support for Mediatek MT6589 boards
Message-ID: <20140514212612.GK20486@codeaurora.org>
References: <1399938570-11356-1-git-send-email-matthias.bgg@gmail.com>
 <1399938570-11356-5-git-send-email-matthias.bgg@gmail.com>
 <20140513224732.GJ20486@codeaurora.org>
 <20140514070038.GG29258@lukather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514070038.GG29258@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14, Maxime Ripard wrote:
> On Tue, May 13, 2014 at 03:47:32PM -0700, Stephen Boyd wrote:
> > On 05/13, Matthias Brugger wrote:
> > > +	"mediatek,mt6589",
> > > +	NULL,
> > > +};
> > > +
> > > +DT_MACHINE_START(MEDIATEK_DT, "Mediatek Cortex-A7 (Device Tree)")
> > > +	.dt_compat	= mediatek_board_dt_compat,
> > > +MACHINE_END
> > 
> > You shouldn't need this file at all if the platform is part of
> > the multi-platform kernel.
> 
> From a technical point of view, you don't. But it's interesting to
> keep it mostly for two things:
>   - You get to see the platform name in /proc/cpuinfo
>   - If you ever need to add platform quirks, it's already there
> 
> We had a similar discussion two weeks ago for mach-sunxi with Olof and
> Arnd, and ended up keeping this minimal machine.
> 

It looks like it's only useful to make /proc/cpuinfo have the
platform name because it really isn't that hard to add this file
if we need to add platform quirks. The downside is we have to
keep adding compatibles when we support new SoCs.

This all leads back to the patch from Rob that removes the .name
field from the DT based machine descriptor[1]. I'm not sure that
thread ever resolved but it looked like a step in the right
direction. At least it matches what arm64 (and what looks like
mips) are doing. The concern there was finding which machine
descriptor was used for the init path. Perhaps we should only use
of_flat_dt_get_machine_name() for the generic machine descriptor
so platforms that are using their own machine descriptor get
their .name field printed and they know that their descriptor was
used (assuming the .name field is unique) but the platforms using
the generic descriptor would get more meaningful information and
we wouldn't need to have these skeleton machine descriptors.

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/277536

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
