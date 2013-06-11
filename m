Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3FKQBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:01:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39177 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab3FKQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:01:47 -0400
Message-ID: <51B749E7.6070808@wwwdotorg.org>
Date: Tue, 11 Jun 2013 10:01:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: b-cousson@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        sameo@linux.intel.com, gg@slimlogic.co.uk, lee.jones@linaro.org
Subject: Re: [PATCH v3] ARM: dts: OMAP5: Add palmas MFD node and regulator
 nodes
References: <1370928651-6278-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1370928651-6278-1-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 11:30 PM, J Keerthy wrote:
> This patch adds Palmas MFD node and the regulator nodes for OMAP5.
> 
> The node definitions are based on: https://lkml.org/lkml/2013/6/6/25
> 
> Boot tested on omap5-uevm board.

> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts

> +	palmas: palmas@48 {
> +		reg = <0x48>;
> +		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>; /* IRQ_SYS_1N */
> +		interrupt-parent = <&gic>;
> +	};
> +};
> +
> +&palmas {
> +	compatible = "ti,palmas";
> +	interrupt-controller;
> +	#interrupt-cells = <2>;

I don't really see the point of splitting the node into two parts if
it's all going into a single file. It made sense if part of the node
came from a common .dtsi file, but not so much when it doesn't.
