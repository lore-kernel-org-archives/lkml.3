Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958Ab3CLXKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:10:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54589 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab3CLXKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:10:19 -0400
Message-ID: <513FB5D7.5090800@wwwdotorg.org>
Date: Tue, 12 Mar 2013 17:10:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [Patch v3 3/4] power_supply: tps65090-charger: Add binding doc
References: <1363126089-9071-1-git-send-email-rklein@nvidia.com> <1363126089-9071-4-git-send-email-rklein@nvidia.com>
In-Reply-To: <1363126089-9071-4-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 04:08 PM, Rhyland Klein wrote:
> This change adds the binding documentation for the tps65090-charger.

> diff --git a/Documentation/devicetree/bindings/power_supply/tps65090.txt b/Documentation/devicetree/bindings/power_supply/tps65090.txt

> +Example:
> +
> +	tps65090@48 {
> +		compatible = "ti,tps65090";
> +		reg = <0x48>;
> +		interrupts = <0 88 0x4>;
> +
> +		ti,enable-low-current-chrg;
> +
> +		regulators {
> +			...
> +		};

I'm a little confused by this binding.

What goes in the regulators sub-node; is that specified by another
binding file in bindings/regulator/tps65090.txt?

I would expect one of the following:

1) A single binding file that describes absolutely everything in the
chip. In this case, the main TPS65909 node wouldn't have child nodes for
the MFD components, although the regulators sub-node, which in turn
contains children does still make sense.

2) A separate binding for each component block, and perhaps also some
top-level binding that indicates which child bindings can "plug into"
it. In this case, I'd expect each block to be represented as a sub-node
in DT. The overall regulator component might then still have a
regulators child DT node itself, to represent each regulator's
configuration. In this scenario, each binding document describes the
entirety of a single node.

I think what you've got here is a hybrid; a single top-level node, but
different binding documents defining the various properties that are
relevant to each component block in the device. That seems odd to me.
