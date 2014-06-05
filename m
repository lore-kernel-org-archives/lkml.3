Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaFEQrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:47:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40326 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaFEQru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:47:50 -0400
Message-ID: <53909F31.4050603@wwwdotorg.org>
Date: Thu, 05 Jun 2014 10:47:45 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] of: Add NVIDIA Tegra XUSB pad controller binding
References: <1401894990-30092-1-git-send-email-thierry.reding@gmail.com> <1401894990-30092-2-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1401894990-30092-2-git-send-email-thierry.reding@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 09:16 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> This patch adds the device tree binding documentation for the XUSB pad
> controller found on NVIDIA Tegra SoCs. It exposes both pinmuxing and PHY
> capabilities.

> diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra124-xusb-padctl.txt

> +- #phy-cells: Should be 1. The specifier is the index of the PHY to reference.
> +  Possible values are:
> +  - 0: PCIe
> +  - 1: SATA

Those values are defined in
include/dt-bindings/pinctrl/pinctrl-tegra-xusb.h. I personally consider
the <dt-bindings/> header files to be part of the binding itself, rather
than being derived from the binding. As such, I'd suggest the following
changes:

* Make this patch 1 not patch 2
* Move pinctrl-tegra-xusb.h into this patch.
* Remove the list of values above, and replace it with the text "See
<dt-bindings/pinctrl/pinctrl-tegra-xusb.h> for the set of valid values".

We'll need to make sure this patch is applied to a topic branch that can
be merged into the pinctrl tree and the Tegra tree for 3.17, assuming
that you'll be sending patches for 3.17 that use pinctrl-tegra-xusb.h.

> +Example:
> +========
> +
> +SoC file extract:
> +-----------------
> +
> +	padctl@0,7009f000 {
> +		compatible = "nvidia,tegra124-xusb-padctl";
> +		reg = <0x0 0x7009f000 0x0 0x1000>;
> +		resets = <&tegra_car 142>;
> +		reset-names = "padctl";
> +
> +		#address-cells = <0>;
> +		#size-cells = <0>;

Why are those two properties required? Yes, this node has sub-nodes, but
those sub-nodes don't have a reg property or unit address. The main
Tegra pinctrl nodes don't have #address/size-cells.

> +Board file extract:
> +-------------------

> +	padctl: padctl@0,7009f000 {
> +		pinmux {
> +			pinctrl-0 = <&padctl_default>;
> +			pinctrl-names = "default";

Isn't there one extra level of nodes here. In the DT patches later in
this series, pinctrl-0/pinctrl-names are directly inside the top-level
padctl node.
