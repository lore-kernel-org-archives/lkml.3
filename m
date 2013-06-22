Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3FVREu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 13:04:50 -0400
Received: from gloria.sntech.de ([95.129.55.99]:58837 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab3FVREt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 13:04:49 -0400
From: Heiko =?iso-8859-15?q?St=FCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v3 0/5] clk: dt: bindings for mux, divider & gate clocks
Date: Sat, 22 Jun 2013 19:04:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Matt Sealey <neko@bakuhatsu.net>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>
References: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
In-Reply-To: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306221904.41833.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. Juni 2013, 08:14:11 schrieb Mike Turquette:
> This series introduces binding definitions for common register-mapped
> clock multiplexer, divider and gate IP blocks along with the
> corresponding setup functions for matching DT data.  The bindings are
> similar to the struct definitions but please don't hold that against the
> binding: the struct definitions closely model the hardware register
> layout.
> 
> This version fixes bugs and incorporates support for the hiword-mask
> property needed on Hisilicon and Rockchip platforms.
> 
> Tested on OMAP4460 Panda ES.

Now it works like a charm :-), so on a rk3066a based board

Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>


> Mike Turquette (5):
>   clk: divider: replace bitfield width with mask
>   clk: of: helper for determining number of parent clocks
>   clk: dt: binding for basic multiplexer clock
>   clk: dt: binding for basic divider clock
>   clk: dt: binding for basic gate clock
> 
>  .../devicetree/bindings/clock/divider-clock.txt    |  90 +++++++++++++++
>  .../devicetree/bindings/clock/gate-clock.txt       |  36 ++++++
>  .../devicetree/bindings/clock/mux-clock.txt        |  79 +++++++++++++
>  arch/arm/mach-imx/clk-busy.c                       |   2 +-
>  drivers/clk/clk-divider.c                          | 127
> ++++++++++++++++++--- drivers/clk/clk-gate.c                             |
>  43 +++++++
>  drivers/clk/clk-mux.c                              |  65 ++++++++++-
>  drivers/clk/clk.c                                  |   6 +
>  drivers/clk/mxs/clk-div.c                          |   2 +-
>  include/linux/clk-private.h                        |   2 +-
>  include/linux/clk-provider.h                       |  12 +-
>  11 files changed, 441 insertions(+), 23 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/clock/divider-clock.txt create mode
> 100644 Documentation/devicetree/bindings/clock/gate-clock.txt create mode
> 100644 Documentation/devicetree/bindings/clock/mux-clock.txt

