Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaF3Upe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:45:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43003 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaF3Upc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:45:32 -0400
Message-ID: <53B1CC68.8070104@wwwdotorg.org>
Date: Mon, 30 Jun 2014 14:45:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        edubezval@gmail.com, thierry.reding@gmail.com, pdeschrijver@nvidia.com,
        mlongnecker@nvidia.com
CC: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] ARM: tegra: Add thermal trip points for Jetson TK1
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-4-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1403856699-2140-4-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 02:11 AM, Mikko Perttunen wrote:
> This adds critical trip points to the Jetson TK1 device tree.
> The device will do a controlled shutdown when either the CPU, GPU
> or MEM thermal zone reaches 101 degrees Celsius.

It would be more typical to order the patches with changes to
tegra124.dtsi first, then changes to board files (that build on the core
SoC support) second.

> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts

> +	thermal-zones {
> +		cpu {
> +			trips {
> +				cpu-critical {

Can we name that simply "critical"? DT node names are supposed to
represent type of object more than identity of object. Even "critical"
is a bit of an identity, and "trip@0" would be better, but I imagine the
core thermal DT bindings precluded that?
