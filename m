Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab3DOQWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:22:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55407 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3DOQWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:22:42 -0400
Message-ID: <516C294D.6070700@wwwdotorg.org>
Date: Mon, 15 Apr 2013 10:22:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>
CC: linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH V4 1/6] clk: OMAP: introduce device tree binding to kernel
 clock data
References: <1365807278-554-1-git-send-email-nm@ti.com> <1365807278-554-2-git-send-email-nm@ti.com>
In-Reply-To: <1365807278-554-2-git-send-email-nm@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 04:54 PM, Nishanth Menon wrote:
> OMAP clock data is located in arch/arm/mach-omap2/cclockXYZ_data.c.
> However, this presents an obstacle for using these clock nodes in
> Device Tree definitions. This is especially true for board specific
> clocks initially. The fixed clocks are currently found via clock
> aliases table. There are many possible approaches to this problem as
> discussed in the following thread:
> http://marc.info/?t=136370325600009&r=1&w=2.
> Highlights of the options:
> a) device specific clk_add_alias:
>    cons: driver handling required
> b) using an generic clk node and indexing to reach the clock required.
>    This is similar in approach taken by tegra and few other platforms.
>    Example usage: clock = <&clk 5>;
>    cons: potential to have mismatches in indexed table and associated
>    dtb data. In addition, managing continued documentation in bindings
>    as clock indexing increases. Even though readability angle could be
>    improved by using preprocessing of DT using macros, indexed
>    approach is inherently risky from cases like the following:
>    clk indexes in kernel:
>    1 - mpu_dpll
>    2 - aux_clk1
>    3 - core_clk
>    DT entry for peripheral X uses <&clk 2> to reach aux_clk1. Now, let's
>    say kernel updates indices to:
>    1 - mpu_dpll
>    2 - per_dpll
>    3 - aux_clk1
>    4 - core_clk
>    using the old dtb(or dts missing an update), on new kernel which
>    has updated indices will result in per_dpll now controlled for
>    peripheral X without warning or any potential error detection.
> 
>    Even though we could claim this is user error, such errors are hard
>    to track down and fix.

The error in case (b) is that you shouldn't be changing the DT bindings
after they've first been created. That would avoid the problem
situation. The person using the old DTB with the new kernel didn't
commit user error.

> An alternate approach introduced here is to introduce device tree
> bindings corresponding to the clock nodes required in DT definition
> for SoC which automatically maps back to the definitions in
> cclockXYZ_data.c.

Well, I haven't read the patches, but isn't that exactly what the "2" is
in <&clk 2>?
