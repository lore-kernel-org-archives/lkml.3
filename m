Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3FCTd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:33:28 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51168 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758545Ab3FCTd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:33:26 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 2/3] clk: dt: binding for basic multiplexor clock
Date: Mon, 3 Jun 2013 21:33:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org> <1370281990-15090-3-git-send-email-mturquette@linaro.org>
In-Reply-To: <1370281990-15090-3-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306032133.20039.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

I think it's a multiplexEr clock in the patch title, and see below


Am Montag, 3. Juni 2013, 19:53:09 schrieb Mike Turquette:
> Device Tree binding for the basic clock multiplexor, plus the setup
> function to register the clock.  Based on the existing fixed-clock
> binding.
> 
> Also relocate declaration of of_fixed_factor_clk_setup to keep things
> tidy.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>

[...]

> +
> +	reg = of_iomap(node, 0);
> +	pr_err("%s: reg is 0x%p\n", __func__, reg);
> +
> +	if (of_property_read_u32(node, "mask", &mask)) {
> +		pr_err("%s: missing mask property for %s\n", __func__, node->name);
> +		return;
> +	}
> +
> +	if (of_property_read_u32(node, "shift", &shift))
> +		pr_debug("%s: missing shift property defaults to zero for %s\n",
> +				__func__, node->name);
> +
> +	if (of_property_read_bool(node, "index_one"))
> +		clk_mux_flags |= CLK_MUX_INDEX_ONE;
> +
> +	clk = clk_register_mux_table(NULL, clk_name, parent_names, num_parents,
> +			0, reg, 0, mask, clk_mux_flags,

                      ^- should probably be shift


Otherwise looks cool and I'm currently trying it with my Rockchip code.


Heiko
