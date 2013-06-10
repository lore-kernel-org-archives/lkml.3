Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3FJQfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:35:16 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42078 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3FJQfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:35:14 -0400
Message-ID: <51B5FEDE.5070900@wwwdotorg.org>
Date: Mon, 10 Jun 2013 10:29:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: b-cousson@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        sameo@linux.intel.com, gg@slimlogic.co.uk, lee.jones@linaro.org
Subject: Re: [PATCH v2 1/2] ARM: dts: add dtsi for palmas
References: <1370855059-5342-1-git-send-email-j-keerthy@ti.com> <1370855059-5342-2-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1370855059-5342-2-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 03:04 AM, J Keerthy wrote:
> Adds palmas mfd and palmas regulator nodes.

Nits:

Well, you're really adding files that provide the nodes, not the nodes
themselves.

Palmas and MFD should be correctly capitalized.

> diff --git a/arch/arm/boot/dts/palmas.dtsi b/arch/arm/boot/dts/palmas.dtsi

> +&palmas {
...
> +	palmas_pmic {
...
> +		ti,ldo6-vibrator;

Isn't that board-specific? I don't know the HW well enough to say, but I
assume that since there's a property, the whole point must be that some
boards want it set and some don't.

> +		regulators {
> +			smps123_reg: smps123 {
> +				regulator-name = "smps123";
> +			};

So the node labels here duplicate those in omap5-uevm.dts in patch 2/2.
While dtc allows this, I don't think there's much point duplicating the
labels. I'd tend to only put the labels in omap5-uevm.dts and not put
them here. That will completely avoid the possibility of the labels in
this file from conflicting with any other labels in any top-level
board.dts file.

I also wonder if this file is actually terribly useful. The only thing
that this file provides is the regulator-name property. It seems simpler
just to put that into each board.dts file. The added advantage of doing
that, is that if a board doesn't use a particular regulator, the node
won't appear, and the regulator won't get registered.
