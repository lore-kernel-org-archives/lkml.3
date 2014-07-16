Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbaGPImw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:42:52 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6469 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047AbaGPImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:42:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Jul 2014 01:31:29 -0700
Date: Wed, 16 Jul 2014 11:42:44 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        "Sebastian Hesselbarth" <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/6] clk: tegra: Update binding doc Tegra132
Message-ID: <20140716084244.GO23218@tbergstrom-lnx.Nvidia.com>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-4-git-send-email-pdeschrijver@nvidia.com>
 <20140716072539.GD7978@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140716072539.GD7978@ulmo>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:25:40AM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jul 15, 2014 at 06:24:33PM +0300, Peter De Schrijver wrote:
> > Tegra132 has almost the same clock structure than Tegra124. This patch
> > documents the missing clock IDs.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> >  .../bindings/clock/nvidia,tegra124-car.txt         |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
> > index ded5d62..28129a9 100644
> > --- a/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
> > +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra124-car.txt
> > @@ -1,4 +1,4 @@
> > -NVIDIA Tegra124 Clock And Reset Controller
> > +NVIDIA Tegra124 and Tegra132 Clock And Reset Controller
> >  
> >  This binding uses the common clock binding:
> >  Documentation/devicetree/bindings/clock/clock-bindings.txt
> > @@ -7,14 +7,16 @@ The CAR (Clock And Reset) Controller on Tegra is the HW module responsible
> >  for muxing and gating Tegra's clocks, and setting their rates.
> >  
> >  Required properties :
> > -- compatible : Should be "nvidia,tegra124-car"
> > +- compatible : Should be "nvidia,tegra124-car" or "nvidia,tegra132-car"
> >  - reg : Should contain CAR registers location and length
> >  - clocks : Should contain phandle and clock specifiers for two clocks:
> >    the 32 KHz "32k_in", and the board-specific oscillator "osc".
> >  - #clock-cells : Should be 1.
> >    In clock consumers, this cell represents the clock ID exposed by the
> >    CAR. The assignments may be found in header file
> > -  <dt-bindings/clock/tegra124-car.h>.
> > +  <dt-bindings/clock/tegra124-car.h>. The following clocks do not exist
> > +  in the nvidia,tegra132-car binding: TEGRA124_CLK_CCLK_G,
> > +  TEGRA124_CLK_CCLK_LP, TEGRA124_CLK_PLL_X and TEGRA124_CLK_PLL_X_OUT0.
> 
> Perhaps it would be useful to split up the common clocks and the
> Tegra124-only clocks into separate header files and then provide
> tegra132-car.h which includes only the ones in common with Tegra124.
> 
> In other words: tegra124-car-common.h would have all except the ones
> above, then tegra124-car.h includes tegra124-car-common.h and defines
> those that are Tegra124-only (the ones you listed above) and
> tegra132-car.h can include tegra124-car-common.h.
> 
> That's somewhat extreme, but it has the benefit of giving us compile-
> time checks as to whether the correct clocks are being used.
> 

Yes. That seems like a good plan.

Cheers,

Peter.
