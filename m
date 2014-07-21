Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750803AbaGUWpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 18:45:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40501 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaGUWpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 18:45:15 -0400
Message-ID: <53CD95F2.10008@wwwdotorg.org>
Date: Mon, 21 Jul 2014 16:36:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, pdeschrijver@nvidia.com,
        pgaikwad@nvidia.com, mturquette@linaro.org, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com> <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
> Add binding documentation for the nvidia,tegra124-emc device tree
> node.

> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt

> +Required properties :
> +- compatible : "nvidia,tegra124-emc".
> +- reg : Should contain 1 or 2 entries:
> +  - EMC register set
> +  - MC register set : Required only if no node with
> +    'compatible = "nvidia,tegra124-mc"' exists. The MC register set
> +    is first read from the MC node. If it doesn't exist, it is read
> +    from this property.

I echo what Thierry said about the MC register sharing.

> +- timings : Should contain 1 entry for each supported clock rate.

s/entry/node/ I think.

> +  Entries should be named "timing@n" where n is a 0-based increasing
> +  number. The timings must be listed in rate-ascending order.

That implies that #address-cells and #size-cells are required too.

> +Required properties for timings :

... and a reg property is needed here.

> +- clock-frequency : Should contain the memory clock rate.
> +- nvidia,parent-clock-frequency : Should contain the rate of the EMC
> +  clock's parent clock.

> +- clocks : Must contain an entry for each entry in clock-names.
> +  See ../clocks/clock-bindings.txt for details.
> +- clock-names : Must include the following entries:
> +  - emc-parent : EMC's parent clock.

Shouldn't clocks/clock-names be part of the main node, not the
per-timing node?

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
> +- nvidia,emc-burst-data : EMC timing characterization data written to
> +                          EMC registers.
> +- nvidia,mc-burst-data : EMC timing characterization data written to
> +                         MC registers.
> 

