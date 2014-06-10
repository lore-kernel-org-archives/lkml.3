Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbaFJC3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:29:54 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:60777 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbaFJC3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:29:52 -0400
MIME-Version: 1.0
In-Reply-To: <2623425.GJLg6iuqD9@avalon>
References: <1401324729-31863-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
 <2623425.GJLg6iuqD9@avalon>
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Date: Tue, 10 Jun 2014 11:29:21 +0900
X-Google-Sender-Auth: YH_xgk8jjfnzhS2Mb_NgCNrrfyY
Message-ID: <CABMQnV+RX0148X04v6SMJnznjmWAROH2wu2X1Z1JPOZ+HL=D1A@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sh-pfc: r8a7791: Add HSCIF pin support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-06-09 20:25 GMT+09:00 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi Iwamatsu-san,
>
> Thank you for the patch.
>
> On Thursday 29 May 2014 09:52:09 Nobuhiro Iwamatsu wrote:
>
> A commit message would be nice. You're also missing hscif2_data_d. That could
> be added later though, so

I will add hscif2_data_d and resend.

>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>

Thanks!

Nobuhiro

>> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
>> ---
>>  drivers/pinctrl/sh-pfc/pfc-r8a7791.c | 241 ++++++++++++++++++++++++++++++++
>>  1 file changed, 241 insertions(+)
>>
>> diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
>> b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c index 2e688dc..bb32514 100644
>> --- a/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
>> +++ b/drivers/pinctrl/sh-pfc/pfc-r8a7791.c
>> @@ -1867,6 +1867,185 @@ static const unsigned int eth_rmii_mux[] = {
>>       ETH_RXD0_MARK, ETH_RXD1_MARK, ETH_RX_ER_MARK, ETH_CRS_DV_MARK,
>>       ETH_TXD0_MARK, ETH_TXD1_MARK, ETH_TX_EN_MARK, ETH_REFCLK_MARK,
>>  };
>> +
>> +/* - HSCIF0
>> ----------------------------------------------------------------- */
>> +static const unsigned int hscif0_data_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(7, 3), RCAR_GP_PIN(7, 4),
>> +};
>> +static const unsigned int hscif0_data_mux[] = {
>> +     HRX0_MARK, HTX0_MARK,
>> +};
>> +static const unsigned int hscif0_clk_pins[] = {
>> +     /* SCK */
>> +     RCAR_GP_PIN(7, 2),
>> +};
>> +static const unsigned int hscif0_clk_mux[] = {
>> +     HSCK0_MARK,
>> +};
>> +static const unsigned int hscif0_ctrl_pins[] = {
>> +     /* RTS, CTS */
>> +     RCAR_GP_PIN(7, 1), RCAR_GP_PIN(7, 0),
>> +};
>> +static const unsigned int hscif0_ctrl_mux[] = {
>> +     HRTS0_N_MARK, HCTS0_N_MARK,
>> +};
>> +static const unsigned int hscif0_data_b_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(3, 12), RCAR_GP_PIN(3, 15),
>> +};
>> +static const unsigned int hscif0_data_b_mux[] = {
>> +     HRX0_B_MARK, HTX0_B_MARK,
>> +};
>> +static const unsigned int hscif0_ctrl_b_pins[] = {
>> +     /* RTS, CTS */
>> +     RCAR_GP_PIN(3, 14), RCAR_GP_PIN(3, 13),
>> +};
>> +static const unsigned int hscif0_ctrl_b_mux[] = {
>> +     HRTS0_N_B_MARK, HCTS0_N_B_MARK,
>> +};
>> +static const unsigned int hscif0_data_c_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(2, 0), RCAR_GP_PIN(2, 1),
>> +};
>> +static const unsigned int hscif0_data_c_mux[] = {
>> +     HRX0_C_MARK, HTX0_C_MARK,
>> +};
>> +static const unsigned int hscif0_clk_c_pins[] = {
>> +     /* SCK */
>> +     RCAR_GP_PIN(5, 31),
>> +};
>> +static const unsigned int hscif0_clk_c_mux[] = {
>> +     HSCK0_C_MARK,
>> +};
>> +/* - HSCIF1
>> ----------------------------------------------------------------- */
>> +static const unsigned int hscif1_data_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(7, 5), RCAR_GP_PIN(7, 6),
>> +};
>> +static const unsigned int hscif1_data_mux[] = {
>> +     HRX1_MARK, HTX1_MARK,
>> +};
>> +static const unsigned int hscif1_clk_pins[] = {
>> +     /* SCK */
>> +     RCAR_GP_PIN(7, 7),
>> +};
>> +static const unsigned int hscif1_clk_mux[] = {
>> +     HSCK1_MARK,
>> +};
>> +static const unsigned int hscif1_ctrl_pins[] = {
>> +     /* RTS, CTS */
>> +     RCAR_GP_PIN(7, 9), RCAR_GP_PIN(7, 8),
>> +};
>> +static const unsigned int hscif1_ctrl_mux[] = {
>> +     HRTS1_N_MARK, HCTS1_N_MARK,
>> +};
>> +static const unsigned int hscif1_data_b_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(1, 17), RCAR_GP_PIN(1, 18),
>> +};
>> +static const unsigned int hscif1_data_b_mux[] = {
>> +     HRX1_B_MARK, HTX1_B_MARK,
>> +};
>> +static const unsigned int hscif1_data_c_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(7, 14), RCAR_GP_PIN(7, 15),
>> +};
>> +static const unsigned int hscif1_data_c_mux[] = {
>> +     HRX1_C_MARK, HTX1_C_MARK,
>> +};
>> +static const unsigned int hscif1_clk_c_pins[] = {
>> +     /* SCK */
>> +     RCAR_GP_PIN(7, 16),
>> +};
>> +static const unsigned int hscif1_clk_c_mux[] = {
>> +     HSCK1_C_MARK,
>> +};
>> +static const unsigned int hscif1_ctrl_c_pins[] = {
>> +     /* RTS, CTS */
>> +     RCAR_GP_PIN(7, 18), RCAR_GP_PIN(7, 17),
>> +};
>> +static const unsigned int hscif1_ctrl_c_mux[] = {
>> +     HRTS1_N_C_MARK, HCTS1_N_C_MARK,
>> +};
>> +static const unsigned int hscif1_data_d_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(4, 28), RCAR_GP_PIN(4, 18),
>> +};
>> +static const unsigned int hscif1_data_d_mux[] = {
>> +     HRX1_D_MARK, HTX1_D_MARK,
>> +};
>> +static const unsigned int hscif1_data_e_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(7, 14), RCAR_GP_PIN(7, 15),
>> +};
>> +static const unsigned int hscif1_data_e_mux[] = {
>> +     HRX1_C_MARK, HTX1_C_MARK,
>> +};
>> +static const unsigned int hscif1_clk_e_pins[] = {
>> +     /* SCK */
>> +     RCAR_GP_PIN(2, 6),
>> +};
>> +static const unsigned int hscif1_clk_e_mux[] = {
>> +     HSCK1_E_MARK,
>> +};
>> +static const unsigned int hscif1_ctrl_e_pins[] = {
>> +     /* RTS, CTS */
>> +     RCAR_GP_PIN(2, 8), RCAR_GP_PIN(2, 7),
>> +};
>> +static const unsigned int hscif1_ctrl_e_mux[] = {
>> +     HRTS1_N_E_MARK, HCTS1_N_E_MARK,
>> +};
>> +/* - HSCIF2
>> ----------------------------------------------------------------- */
>> +static const unsigned int hscif2_data_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(4, 16), RCAR_GP_PIN(4, 17),
>> +};
>> +static const unsigned int hscif2_data_mux[] = {
>> +     HRX2_MARK, HTX2_MARK,
>> +};
>> +static const unsigned int hscif2_clk_pins[] = {
>> +     /* SCK */
>> +     RCAR_GP_PIN(4, 15),
>> +};
>> +static const unsigned int hscif2_clk_mux[] = {
>> +     HSCK2_MARK,
>> +};
>> +static const unsigned int hscif2_ctrl_pins[] = {
>> +     /* RTS, CTS */
>> +     RCAR_GP_PIN(4, 14), RCAR_GP_PIN(4, 13),
>> +};
>> +static const unsigned int hscif2_ctrl_mux[] = {
>> +     HRTS2_N_MARK, HCTS2_N_MARK,
>> +};
>> +static const unsigned int hscif2_data_b_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(1, 20), RCAR_GP_PIN(1, 22),
>> +};
>> +static const unsigned int hscif2_data_b_mux[] = {
>> +     HRX2_B_MARK, HTX2_B_MARK,
>> +};
>> +static const unsigned int hscif2_ctrl_b_pins[] = {
>> +     /* RTS, CTS */
>> +     RCAR_GP_PIN(1, 23), RCAR_GP_PIN(1, 21),
>> +};
>> +static const unsigned int hscif2_ctrl_b_mux[] = {
>> +     HRTS2_N_B_MARK, HCTS2_N_B_MARK,
>> +};
>> +static const unsigned int hscif2_data_c_pins[] = {
>> +     /* RX, TX */
>> +     RCAR_GP_PIN(2, 0), RCAR_GP_PIN(2, 1),
>> +};
>> +static const unsigned int hscif2_data_c_mux[] = {
>> +     HRX2_C_MARK, HTX2_C_MARK,
>> +};
>> +static const unsigned int hscif2_clk_c_pins[] = {
>> +     /* SCK */
>> +     RCAR_GP_PIN(5, 31),
>> +};
>> +static const unsigned int hscif2_clk_c_mux[] = {
>> +     HSCK2_C_MARK,
>> +};
>>  /* - I2C0
>> ------------------------------------------------------------------- */
>> static const unsigned int i2c0_pins[] = {
>>       /* SCL, SDA */
>> @@ -3885,6 +4064,31 @@ static const struct sh_pfc_pin_group pinmux_groups[]
>> = { SH_PFC_PIN_GROUP(eth_magic),
>>       SH_PFC_PIN_GROUP(eth_mdio),
>>       SH_PFC_PIN_GROUP(eth_rmii),
>> +     SH_PFC_PIN_GROUP(hscif0_data),
>> +     SH_PFC_PIN_GROUP(hscif0_clk),
>> +     SH_PFC_PIN_GROUP(hscif0_ctrl),
>> +     SH_PFC_PIN_GROUP(hscif0_data_b),
>> +     SH_PFC_PIN_GROUP(hscif0_ctrl_b),
>> +     SH_PFC_PIN_GROUP(hscif0_data_c),
>> +     SH_PFC_PIN_GROUP(hscif0_clk_c),
>> +     SH_PFC_PIN_GROUP(hscif1_data),
>> +     SH_PFC_PIN_GROUP(hscif1_clk),
>> +     SH_PFC_PIN_GROUP(hscif1_ctrl),
>> +     SH_PFC_PIN_GROUP(hscif1_data_b),
>> +     SH_PFC_PIN_GROUP(hscif1_data_c),
>> +     SH_PFC_PIN_GROUP(hscif1_clk_c),
>> +     SH_PFC_PIN_GROUP(hscif1_ctrl_c),
>> +     SH_PFC_PIN_GROUP(hscif1_data_d),
>> +     SH_PFC_PIN_GROUP(hscif1_data_e),
>> +     SH_PFC_PIN_GROUP(hscif1_clk_e),
>> +     SH_PFC_PIN_GROUP(hscif1_ctrl_e),
>> +     SH_PFC_PIN_GROUP(hscif2_data),
>> +     SH_PFC_PIN_GROUP(hscif2_clk),
>> +     SH_PFC_PIN_GROUP(hscif2_ctrl),
>> +     SH_PFC_PIN_GROUP(hscif2_data_b),
>> +     SH_PFC_PIN_GROUP(hscif2_ctrl_b),
>> +     SH_PFC_PIN_GROUP(hscif2_data_c),
>> +     SH_PFC_PIN_GROUP(hscif2_clk_c),
>>       SH_PFC_PIN_GROUP(i2c0),
>>       SH_PFC_PIN_GROUP(i2c0_b),
>>       SH_PFC_PIN_GROUP(i2c0_c),
>> @@ -4183,6 +4387,40 @@ static const char * const eth_groups[] = {
>>       "eth_rmii",
>>  };
>>
>> +static const char * const hscif0_groups[] = {
>> +     "hscif0_data",
>> +     "hscif0_clk",
>> +     "hscif0_ctrl",
>> +     "hscif0_data_b",
>> +     "hscif0_ctrl_b",
>> +     "hscif0_data_c",
>> +     "hscif0_clk_c",
>> +};
>> +
>> +static const char * const hscif1_groups[] = {
>> +     "hscif1_data",
>> +     "hscif1_clk",
>> +     "hscif1_ctrl",
>> +     "hscif1_data_b",
>> +     "hscif1_data_c",
>> +     "hscif1_clk_c",
>> +     "hscif1_ctrl_c",
>> +     "hscif1_data_d",
>> +     "hscif1_data_e",
>> +     "hscif1_clk_e",
>> +     "hscif1_ctrl_e",
>> +};
>> +
>> +static const char * const hscif2_groups[] = {
>> +     "hscif2_data",
>> +     "hscif2_clk",
>> +     "hscif2_ctrl",
>> +     "hscif2_data_b",
>> +     "hscif2_ctrl_b",
>> +     "hscif2_data_c",
>> +     "hscif2_clk_c",
>> +};
>> +
>>  static const char * const i2c0_groups[] = {
>>       "i2c0",
>>       "i2c0_b",
>> @@ -4547,6 +4785,9 @@ static const struct sh_pfc_function pinmux_functions[]
>> = { SH_PFC_FUNCTION(du0),
>>       SH_PFC_FUNCTION(du1),
>>       SH_PFC_FUNCTION(eth),
>> +     SH_PFC_FUNCTION(hscif0),
>> +     SH_PFC_FUNCTION(hscif1),
>> +     SH_PFC_FUNCTION(hscif2),
>>       SH_PFC_FUNCTION(i2c0),
>>       SH_PFC_FUNCTION(i2c1),
>>       SH_PFC_FUNCTION(i2c2),
>
> --
> Regards,
>
> Laurent Pinchart
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Nobuhiro Iwamatsu
