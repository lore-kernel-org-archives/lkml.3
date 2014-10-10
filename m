Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaJJNOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 09:14:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52077 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbaJJNO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 09:14:28 -0400
Date: Fri, 10 Oct 2014 14:14:17 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Stephen Warren <swarren@nvidia.com>, Rhyland Klein <rklein@nvidia.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Thierry Reding <treding@nvidia.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/10] of: Add Tegra124 EMC bindings
Message-ID: <20141010131417.GA6004@leverpostej>
References: <1412945262-6068-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412945262-6068-5-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412945262-6068-5-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:46:55PM +0100, Tomeu Vizoso wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
> 
> Add binding documentation for the nvidia,tegra124-emc device tree node.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  .../bindings/memory-controllers/tegra-emc.txt      | 41 ++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
> 
> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
> new file mode 100644
> index 0000000..6282c6b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
> @@ -0,0 +1,41 @@
> +Tegra124 SoC EMC controller
> +
> +Required properties :
> +- compatible : "nvidia,tegra124-emc".
> +- reg : Should contain 1 entry:
> +  - EMC register set
> +
> +The node should contain a "timings@i" subnode for each supported RAM type
> +  (see field RAM_CODE in register PMC_STRAPPING_OPT_A)
> +Required properties for "timings@i" nodes :
> +- nvidia,ram-code : Should contain the value of RAM_CODE this timing set
> +  is used for.
> +
> +Each "timings@i" node should contain "timing@j" subnodes. One "timing@j"
> +  node should exist for each supported EMC clock rate.

What do the i and j correspond to?

> +Required properties for "timing@j" nodes :
> +- clock-frequency : Should contain the memory clock rate.
> +- nvidia,parent-clock-frequency : Should contain the rate of the EMC
> +  clock's parent clock.

Why are both of these properties necessary?

What is the relationship between the two?

> +- clocks : Must contain an entry for each entry in clock-names.
> +  See ../clocks/clock-bindings.txt for details.
> +- clock-names : Must include the following entries:
> +  - emc-parent : EMC's parent clock.

Surely the clocks are a property of the EMC, and not the individual
timings?

> +- The following properties contain EMC timing characterization values:
> +  - nvidia,emc-zcal-cnt-long
> +  - nvidia,emc-auto-cal-interval
> +  - nvidia,emc-ctt-term-ctrl
> +  - nvidia,emc-cfg
> +  - nvidia,emc-cfg-2
> +  - nvidia,emc-sel-dpd-ctrl
> +  - nvidia,emc-cfg-dig-dll
> +  - nvidia,emc-bgbias-ctl0
> +  - nvidia,emc-auto-cal-config
> +  - nvidia,emc-auto-cal-config2
> +  - nvidia,emc-auto-cal-config3
> +  - nvidia,emc-mode-reset
> +  - nvidia,emc-mode-1
> +  - nvidia,emc-mode-2
> +  - nvidia,emc-mode-4
> +- nvidia,emc-configuration : EMC timing characterization data written to
> +                             EMC registers.

I have no idea what any of these are. Perhaps these make sense, but I
cannot tell.

Mark.
