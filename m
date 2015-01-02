Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbbABQ2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:28:36 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:2787 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbABQ2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:28:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 Jan 2015 08:21:57 -0800
Date: Fri, 2 Jan 2015 18:27:50 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        <mikko.perttunen@kapsi.fi>, <acourbot@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 12/14] clk: tegra: Add EMC clock driver
Message-ID: <20150102162750.GA10073@tbergstrom-lnx.Nvidia.com>
References: <1416312860-4446-1-git-send-email-tomeu.vizoso@collabora.com>
 <1416312860-4446-13-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1416312860-4446-13-git-send-email-tomeu.vizoso@collabora.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.21.24.170]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 01:13:14PM +0100, Tomeu Vizoso wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
> 
> The driver is currently only tested on Tegra124 Jetson TK1, but should
> work with other Tegra124 boards, provided that correct EMC tables are
> provided through the device tree. Older chip models have differing
> timing change sequences, so they are not currently supported.
> 
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> 
> ---
> 
> v5:	* Get a pointer to the EMC driver at runtime, to be used when
> 	  calling the EMC API.
> 	* Misc. style fixes
> 	* Fix logic for rounding down to a high rate
> 
> v4:	* Adapt to changes in the OF bindings
> 	* Improve error handling
> 	* Fix comment style
> 	* Make static a few more functions
> 
> v3:	* Add some locking to protect the registers that are shared with the MC
> 	  clock
> 
> v2:	* Make sure that the clock is properly registered
> 	* Bail out early from attempts to set the same rate

Thierry,

How do you want to merge this series? The clock tree part depends on
tegra_read_ram_code which is introduced earlier in this series.

Cheers,

Peter.
