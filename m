Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3K0Vsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 16:48:54 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:59606 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab3K0Vst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 16:48:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Rob Landley" <rob@landley.net>, "Andrew Victor" <linux@maxim.org.za>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        "Russell King" <linux@arm.linux.org.uk>, "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        "Josh Wu" <josh.wu@atmel.com>,
        "Richard Genoud" <richard.genoud@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1384293439-4525-1-git-send-email-b.brezillon@overkiz.com>
Cc: "Boris BREZILLON" <b.brezillon@overkiz.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
References: <1384289513-3068-1-git-send-email-b.brezillon@overkiz.com>
 <1384293439-4525-1-git-send-email-b.brezillon@overkiz.com>
Message-ID: <20131127214843.16819.59481@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 06/17] clk: at91: add PMC pll clocks
Date: Wed, 27 Nov 2013 13:48:43 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2013-11-12 13:57:19)
> +static const struct clk_ops pll_ops = {
> +       .prepare = clk_pll_prepare,
> +       .is_prepared = clk_pll_is_ready,
> +       .disable = clk_pll_disable,
> +       .is_enabled = clk_pll_is_ready,
> +       .recalc_rate = clk_pll_recalc_rate,
> +       .round_rate = clk_pll_round_rate,
> +       .set_rate = clk_pll_set_rate,
> +};

Hi Boris,

It is a bit strange to see only a .prepare and .disable callback
populated. What happens if a driver calls clk_disable and then
clk_enable? You clock will still be disabled in hardware.

Regards,
Mike
