Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaAFUk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:40:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40860 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaAFUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:40:55 -0500
Message-ID: <52CB14D3.2060904@wwwdotorg.org>
Date: Mon, 06 Jan 2014 13:40:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/6] ARM: tegra: Add efuse bindings
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com> <1387891931-9854-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1387891931-9854-4-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
> Add efuse bindings for Tegra20, Tegra30, Tegra114 and Tegra124.

This patch doesn't add bindings, it adds nodes to device trees. Bindings
are the schemas that dictate how the nodes are to be constructed, not
the nodes themselves.

On that topic, this series needs to create
Documentation/devicetree/bindings/fuse/nvidia,tegra20-fuse.txt etc.

> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi

> +	efuse@7000f800 {
...
> +	};
> +
>  	cpus {

This node isn't sorted correctly. It should be between sdhci@700b0600
and ahub@70300000, not after the ahub.

> diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi

> +	efuse@7000F800 {

"fuse" might be a better node name; "efuse" is presumably the name of
the instance, not the type of object.

Please use lower-case for hex constants; both here and in the reg property.
