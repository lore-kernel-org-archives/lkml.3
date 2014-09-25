Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaIYW1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:27:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:45423 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbaIYW1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:27:32 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>, <ben.dooks@codethink.co.uk>,
        <laurent.pinchart@ideasonboard.com>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/4] ARM: dts: k2hk-evm: add pm domains for net, qmss and knav_dmas
References: <1411657537-25238-1-git-send-email-grygorii.strashko@ti.com>
	<1411657537-25238-5-git-send-email-grygorii.strashko@ti.com>
Date: Thu, 25 Sep 2014 15:27:30 -0700
In-Reply-To: <1411657537-25238-5-git-send-email-grygorii.strashko@ti.com>
	(Grygorii Strashko's message of "Thu, 25 Sep 2014 18:05:37 +0300")
Message-ID: <7hd2aj9vzh.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> Add Keystone PM domains nodes for NetCP, NetCPx, QMSS, KNAV-DMA
> devices.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  arch/arm/boot/dts/k2hk-evm.dts | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/arch/arm/boot/dts/k2hk-evm.dts b/arch/arm/boot/dts/k2hk-evm.dts
> index 91371f7..a7b468c 100644
> --- a/arch/arm/boot/dts/k2hk-evm.dts
> +++ b/arch/arm/boot/dts/k2hk-evm.dts
> @@ -58,6 +58,13 @@
>  				clock-output-names = "refclk-ddr3b";
>  			};
>  		};
> +
> +		qmss_domain: qmss_pm_controller {
> +			compatible = "ti,keystone-gpc";
> +			clocks = <&chipclk13>;
> +			#power-domain-cells = <0>;
> +		};

Hmm, I'm still a bit confused by what you're attempting to do here.
Unless I'm missing someting, clocks are properties of the device, not
the pm-domain...

>  		qmss: qmss@2a40000 {
>  			compatible = "ti,keystone-navigator-qmss";
>  			dma-coherent;
> @@ -65,6 +72,8 @@
>  			#size-cells = <1>;
>  			clocks = <&chipclk13>;
>  			ranges;
> +			power-domains = <&qmss_domain>;

...  Also, each of the pm domains is duplicating the list of clocks from
the device node, so I'm not sure what this is accomplishing.

Why not just have a single, more generic power domain that gets the list
of clocks from the device node.

Kevin
