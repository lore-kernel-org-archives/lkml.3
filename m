Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506AbaEMBcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:32:16 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39656 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaEMBcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:32:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "Emilio Lopez" <emilio@elopez.com.ar>, stern@rowland.harvard.edu,
        kishon@ti.com, hdegoede@redhat.com
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1399923274-6017-2-git-send-email-maxime.ripard@free-electrons.com>
Cc: "Boris Brezillon" <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>
References: <1399923274-6017-1-git-send-email-maxime.ripard@free-electrons.com>
 <1399923274-6017-2-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <20140513013208.5943.89944@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v3 1/8] clk: sunxi: Implement A31 USB clock
Date: Mon, 12 May 2014 18:32:08 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Maxime Ripard (2014-05-12 12:34:27)
> The A31 USB clock slightly differ from its older counterparts, mostly because
> it has a different gate for each PHY, while the older one had a single gate for
> all the phy.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/clk/sunxi/clk-sunxi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index bd7dc733c1ca..d9bab75f128b 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -972,6 +972,11 @@ static const struct gates_data sun5i_a13_usb_gates_data __initconst = {
>         .reset_mask = 0x03,
>  };
>  
> +static const struct gates_data sun6i_a31_usb_gates_data __initconst = {
> +       .mask = { BIT(18) | BIT(17) | BIT(16) | BIT(10) | BIT(9) | BIT(8) },
> +       .reset_mask = BIT(2) | BIT(1) | BIT(0),
> +};
> +
>  static void __init sunxi_gates_clk_setup(struct device_node *node,
>                                          struct gates_data *data)
>  {
> @@ -1267,6 +1272,7 @@ static const struct of_device_id clk_gates_match[] __initconst = {
>         {.compatible = "allwinner,sun6i-a31-apb2-gates-clk", .data = &sun6i_a31_apb2_gates_data,},
>         {.compatible = "allwinner,sun4i-a10-usb-clk", .data = &sun4i_a10_usb_gates_data,},
>         {.compatible = "allwinner,sun5i-a13-usb-clk", .data = &sun5i_a13_usb_gates_data,},
> +       {.compatible = "allwinner,sun6i-a31-usb-clk", .data = &sun6i_a31_usb_gates_data,},
>         {}
>  };
>  
> -- 
> 1.9.3
> 
