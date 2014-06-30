Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaF3Ush (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:48:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44958 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaF3Usf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:48:35 -0400
Message-ID: <53B1CD20.3010008@wwwdotorg.org>
Date: Mon, 30 Jun 2014 14:48:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, rui.zhang@intel.com,
        edubezval@gmail.com, thierry.reding@gmail.com, pdeschrijver@nvidia.com,
        mlongnecker@nvidia.com
CC: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/6] ARM: tegra: Add soctherm and thermal zones to Tegra124
 device tree
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-5-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1403856699-2140-5-git-send-email-mperttunen@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 02:11 AM, Mikko Perttunen wrote:
> This adds the soctherm thermal sensing and management unit to the
> Tegra124 device tree along with the four thermal zones it exports.

> diff --git a/arch/arm/boot/dts/tegra124.dtsi b/arch/arm/boot/dts/tegra124.dtsi

> +	thermal-zones {
> +		cpu {
> +			polling-delay-passive = <0>;
> +			polling-delay = <0>;

I think we should still define a polling delay so that if there's SW
that doesn't support HW trip points/interrupts, it still knows how often
it should reasonably check the sensor.

Perhaps a delay of 0 is used to determine whether to use HW trip points
vs polling (I haven't read patch 1 yet)? If so, I'd prefer not to do
that. Rather, the driver should advertize its ability to provide HW trip
points, and it would be up to the core to then make use of them. The DT
should just describe the HW, not assume it can influence SW's choice of
whether to use HW trip points.

> +	soctherm: soctherm@0,700e2000 {
...
> +		reset-names = "soctherm";
> +
> +		#thermal-sensor-cells = <1>;

I don't see any real need for that blank line. If there was, there would
probably be more blank lines in the big list of properties above.
