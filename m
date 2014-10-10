Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaJJFKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:10:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60303 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaJJFKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:10:32 -0400
Message-ID: <54376A45.6070707@wwwdotorg.org>
Date: Thu, 09 Oct 2014 22:10:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH 1/2] ARM: tegra: venice2: add GK20A GPU DT node
References: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1412835112-7209-1-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 11:11 PM, Alexandre Courbot wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add the device-tree node for the GK20A GPU and leave it disabled by
> default. It is the responsability of the bootloader to enable it if the
> VPR registers have been programmed such as the GPU can operate.

> diff --git a/arch/arm/boot/dts/tegra124-venice2.dts b/arch/arm/boot/dts/tegra124-venice2.dts

> +	gpu@0,57000000 {
> +		status = "disabled";

status="disabled" usually goes into tegra124.dtsi. A board would only
override status to "okay" if necessary, and include any board specific
properties ...

> +		vdd-supply = <&vdd_gpu>;

... such as that.
