Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931Ab3BNUPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:15:35 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33017 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492Ab3BNUPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:15:33 -0500
Message-ID: <511D45E0.1080105@wwwdotorg.org>
Date: Thu, 14 Feb 2013 13:15:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v2 1/4] ARM: tegra20: create a DT header defining CLK IDs
References: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com> <1360868369-20093-2-git-send-email-hdoyu@nvidia.com>
In-Reply-To: <1360868369-20093-2-git-send-email-hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 11:59 AM, Hiroshi Doyu wrote:
> To replace magic number in tegra_car:
> 
> -               clocks = <&tegra_car 28>;
> +               clocks = <&tegra_car CLK_HOST1X>;

> diff --git a/arch/arm/boot/dts/tegra20-car.h b/arch/arm/boot/dts/tegra20-car.h

Sorry, forgot a couple small comments the last time around.

This file should probably have some header indicating which binding it
describes, rather like the GPIO header in my patch series.

> +#define CLK_CPU 0

I'd suggest naming that TEGRA20_CLK_CPU, so that the various different
clock headers don't conflict. It's not too likely that more than one of
the /Tegra/ clock headers will be included at once, but it doesn't seem
that unlikely that a board file could end up having a Tegra clock header
included plus various other clock headers for some other chip that has
some clock outputs.

Oh, and I don't think you updated e.g. nvidia,tegra20-car.txt to remove
the list of clocks.

BTW, I assume this patch includes the changes from my recent "clk:
tegra: fix driver to match DT binding" and anything else similar that's
in the most recent Tegra for-next?
