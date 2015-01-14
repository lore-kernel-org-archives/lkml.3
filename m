Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbbANGEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 01:04:07 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:61135 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbbANGEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 01:04:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141216203824.22980.48872.stgit@chromeos-P9X79>
References: <20141216203813.22980.2301.stgit@chromeos-P9X79> <20141216203824.22980.48872.stgit@chromeos-P9X79>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 14 Jan 2015 15:03:44 +0900
Message-ID: <CAAVeFu+Xg+Loh3DC3s4k0u26uiCx-9F6OmDidX+kHKgig39mHA@mail.gmail.com>
Subject: Re: [PATCH 1/4] clk: tegra: make tegra_clocks_apply_init_table() arch_initcall
To: Paul Walmsley <paul@pwsan.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 5:38 AM, Paul Walmsley <paul@pwsan.com> wrote:
> From: Peter De Schrijver <pdeschrijver@nvidia.com>
>
> tegra_clocks_apply_init_table() needs to be called after the udelay
> loop has been calibrated (see commit
> 441f199a37cfd66c5dd8dd45490bd3ea6971117d ("clk: tegra: defer
> application of init table") for why that is).  On existing Tegra SoCs
> this was done by calling tegra_clocks_apply_init_table() from
> tegra_dt_init(). To make this also work on ARM64, we need to change
> this into an initcall. tegra_dt_init() is called from
> customize_machine which is an arch_initcall. Therefore this should
> also work on existing 32bit Tegra SoCs.
>
> Tested on Tegra20 (ventana), Tegra30 (beaverboard), Tegra124 (jetson TK1) and
> Tegra132.

Thierry, I don't think this series has ever been reviewed by us? The
patches apply nicely on my tree and look harmless but I would rather
leave that part to you if you don't mind.
