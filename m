Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3HUIXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:23:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60617 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3HUIXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:23:12 -0400
MIME-Version: 1.0
In-Reply-To: <1370521041-32318-20-git-send-email-lee.jones@linaro.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
	<1370521041-32318-20-git-send-email-lee.jones@linaro.org>
Date: Wed, 21 Aug 2013 10:23:11 +0200
Message-ID: <CACRpkdar9oOWQ9xuQnKvvAOw-eQS1-FkDSDD8BwQT3WDE8YzBA@mail.gmail.com>
Subject: Re: [PATCH 19/33] clk: ux500: Add Device Tree support for the PRCMU clock
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Mike Turquette <mturquette@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 6, 2013 at 2:17 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch enables clocks to be specified from Device Tree via phandles
> to the "prcmu-clock" node.
(..)
> @@ -52,14 +54,17 @@ void u8500_clk_init(u32 clkrst1_base, u32 clkrst2_base, u32 clkrst3_base,
>         clk = clk_reg_prcmu_gate("soc0_pll", NULL, PRCMU_PLLSOC0,
>                                 CLK_IS_ROOT|CLK_IGNORE_UNUSED);
>         clk_register_clkdev(clk, "soc0_pll", NULL);
> +       prcmu_clk[PRCMU_PLLSOC0] = clk;

Same comment on all these.

No clk_register_clkdev() on the DT boot path please.

Yours,
Linus Walleij
