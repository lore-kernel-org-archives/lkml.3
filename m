Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbaHNL0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:26:41 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8449 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaHNL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:26:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Aug 2014 04:17:23 -0700
Message-ID: <53EC9CFA.8060701@nvidia.com>
Date: Thu, 14 Aug 2014 19:26:50 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Thermal reset support in PMC
References: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1407933685-12404-1-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me, and I test it with soc-therm driver, the system can be
shutdown when overheat.

Thanks.
Wei.

On 08/13/2014 08:41 PM, Mikko Perttunen wrote:
> Hi,
> 
> this series adds support for hardware-triggered thermal reset to the PMC
> driver. Namely, it adds device tree properties for specifying the I2C
> command to be sent when thermtrip is triggered. It is to be noted
> that thermtrip won't be ever triggered without a soctherm driver to
> calibrate the sensors.
> 
> Git repo at
>   git://github.com/cyndis/linux.git pmc-thermtrip-v2
> 
> Testing script at https://gist.github.com/cyndis/66126c9c176b5f94a76f.
> If your fan stops it is working.
> 
> Mikko Perttunen (5):
>   of: Add descriptions of thermtrip properties to Tegra PMC bindings
>   of: Add nvidia,controller-id property to Tegra I2C bindings
>   ARM: tegra124: Add I2C controller ids to device tree
>   ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
>   ARM: tegra: Add thermal reset (thermtrip) support to PMC
> 
>  .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      |  21 ++
>  .../devicetree/bindings/i2c/nvidia,tegra20-i2c.txt |   5 +
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   6 +
>  arch/arm/boot/dts/tegra124.dtsi                    |   6 +
>  drivers/soc/tegra/pmc.c                            | 379 ++++++++++++++-------
>  5 files changed, 285 insertions(+), 132 deletions(-)
> 

