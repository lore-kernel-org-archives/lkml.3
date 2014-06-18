Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409AbaFRJVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:21:25 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38912 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840AbaFRJVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:21:23 -0400
Date: Wed, 18 Jun 2014 10:21:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm8994: Add a bunch of missing defaults/readables
Message-ID: <20140618092118.GG23945@lee--X1>
References: <1402949731-3344-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402949731-3344-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Charles Keepax wrote:

> Ever since this commit:
> 
> commit d4807ad2c4c0e17b6f00e3be9492c81de0804f40
> regmap: Check readable regs in _regmap_read
> 
> Regmap will refuse to read a register which is not marked as readable,
> this has highlighted a number of controls in this driver which are not
> marked as readable/missing defaults.
> 
> This patch corrects the situation, by adding the missing
> readables/defaults.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8994-regmap.c |   64 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)

Applied, thanks.

> diff --git a/drivers/mfd/wm8994-regmap.c b/drivers/mfd/wm8994-regmap.c
> index 2fbce9c..770a256 100644
> --- a/drivers/mfd/wm8994-regmap.c
> +++ b/drivers/mfd/wm8994-regmap.c
> @@ -123,14 +123,23 @@ static struct reg_default wm1811_defaults[] = {
>  	{ 0x0402, 0x00C0 },    /* R1026 - AIF1 DAC1 Left Volume */
>  	{ 0x0403, 0x00C0 },    /* R1027 - AIF1 DAC1 Right Volume */
>  	{ 0x0410, 0x0000 },    /* R1040 - AIF1 ADC1 Filters */
> +	{ 0x0411, 0x0000 },    /* R1041 - AIF1 ADC2 Filters */
>  	{ 0x0420, 0x0200 },    /* R1056 - AIF1 DAC1 Filters (1) */
>  	{ 0x0421, 0x0010 },    /* R1057 - AIF1 DAC1 Filters (2) */
> +	{ 0x0422, 0x0200 },    /* R1058 - AIF1 DAC2 Filters (1) */
> +	{ 0x0423, 0x0010 },    /* R1059 - AIF1 DAC2 Filters (2) */
>  	{ 0x0430, 0x0068 },    /* R1072 - AIF1 DAC1 Noise Gate */
> +	{ 0x0431, 0x0068 },    /* R1073 - AIF1 DAC2 Noise Gate */
>  	{ 0x0440, 0x0098 },    /* R1088 - AIF1 DRC1 (1) */
>  	{ 0x0441, 0x0845 },    /* R1089 - AIF1 DRC1 (2) */
>  	{ 0x0442, 0x0000 },    /* R1090 - AIF1 DRC1 (3) */
>  	{ 0x0443, 0x0000 },    /* R1091 - AIF1 DRC1 (4) */
>  	{ 0x0444, 0x0000 },    /* R1092 - AIF1 DRC1 (5) */
> +	{ 0x0450, 0x0098 },    /* R1104 - AIF1 DRC2 (1) */
> +	{ 0x0451, 0x0845 },    /* R1105 - AIF1 DRC2 (2) */
> +	{ 0x0452, 0x0000 },    /* R1106 - AIF1 DRC2 (3) */
> +	{ 0x0453, 0x0000 },    /* R1107 - AIF1 DRC2 (4) */
> +	{ 0x0454, 0x0000 },    /* R1108 - AIF1 DRC2 (5) */
>  	{ 0x0480, 0x6318 },    /* R1152 - AIF1 DAC1 EQ Gains (1) */
>  	{ 0x0481, 0x6300 },    /* R1153 - AIF1 DAC1 EQ Gains (2) */
>  	{ 0x0482, 0x0FCA },    /* R1154 - AIF1 DAC1 EQ Band 1 A */
> @@ -152,6 +161,27 @@ static struct reg_default wm1811_defaults[] = {
>  	{ 0x0492, 0x0559 },    /* R1170 - AIF1 DAC1 EQ Band 5 B */
>  	{ 0x0493, 0x4000 },    /* R1171 - AIF1 DAC1 EQ Band 5 PG */
>  	{ 0x0494, 0x0000 },    /* R1172 - AIF1 DAC1 EQ Band 1 C */
> +	{ 0x04A0, 0x6318 },    /* R1184 - AIF1 DAC2 EQ Gains (1) */
> +	{ 0x04A1, 0x6300 },    /* R1185 - AIF1 DAC2 EQ Gains (2) */
> +	{ 0x04A2, 0x0FCA },    /* R1186 - AIF1 DAC2 EQ Band 1 A */
> +	{ 0x04A3, 0x0400 },    /* R1187 - AIF1 DAC2 EQ Band 1 B */
> +	{ 0x04A4, 0x00D8 },    /* R1188 - AIF1 DAC2 EQ Band 1 PG */
> +	{ 0x04A5, 0x1EB5 },    /* R1189 - AIF1 DAC2 EQ Band 2 A */
> +	{ 0x04A6, 0xF145 },    /* R1190 - AIF1 DAC2 EQ Band 2 B */
> +	{ 0x04A7, 0x0B75 },    /* R1191 - AIF1 DAC2 EQ Band 2 C */
> +	{ 0x04A8, 0x01C5 },    /* R1192 - AIF1 DAC2 EQ Band 2 PG */
> +	{ 0x04A9, 0x1C58 },    /* R1193 - AIF1 DAC2 EQ Band 3 A */
> +	{ 0x04AA, 0xF373 },    /* R1194 - AIF1 DAC2 EQ Band 3 B */
> +	{ 0x04AB, 0x0A54 },    /* R1195 - AIF1 DAC2 EQ Band 3 C */
> +	{ 0x04AC, 0x0558 },    /* R1196 - AIF1 DAC2 EQ Band 3 PG */
> +	{ 0x04AD, 0x168E },    /* R1197 - AIF1 DAC2 EQ Band 4 A */
> +	{ 0x04AE, 0xF829 },    /* R1198 - AIF1 DAC2 EQ Band 4 B */
> +	{ 0x04AF, 0x07AD },    /* R1199 - AIF1 DAC2 EQ Band 4 C */
> +	{ 0x04B0, 0x1103 },    /* R1200 - AIF1 DAC2 EQ Band 4 PG */
> +	{ 0x04B1, 0x0564 },    /* R1201 - AIF1 DAC2 EQ Band 5 A */
> +	{ 0x04B2, 0x0559 },    /* R1202 - AIF1 DAC2 EQ Band 5 B */
> +	{ 0x04B3, 0x4000 },    /* R1203 - AIF1 DAC2 EQ Band 5 PG */
> +	{ 0x04B4, 0x0000 },    /* R1204 - AIF1 DAC2 EQ Band 1 C */
>  	{ 0x0500, 0x00C0 },    /* R1280 - AIF2 ADC Left Volume */
>  	{ 0x0501, 0x00C0 },    /* R1281 - AIF2 ADC Right Volume */
>  	{ 0x0502, 0x00C0 },    /* R1282 - AIF2 DAC Left Volume */
> @@ -194,6 +224,8 @@ static struct reg_default wm1811_defaults[] = {
>  	{ 0x0605, 0x0000 },    /* R1541 - AIF2ADC Right Mixer Routing */
>  	{ 0x0606, 0x0000 },    /* R1542 - AIF1 ADC1 Left Mixer Routing */
>  	{ 0x0607, 0x0000 },    /* R1543 - AIF1 ADC1 Right Mixer Routing */
> +	{ 0x0608, 0x0000 },    /* R1544 - AIF1 ADC2 Left Mixer Routing */
> +	{ 0x0609, 0x0000 },    /* R1545 - AIF1 ADC2 Right Mixer Routing */
>  	{ 0x0610, 0x02C0 },    /* R1552 - DAC1 Left Volume */
>  	{ 0x0611, 0x02C0 },    /* R1553 - DAC1 Right Volume */
>  	{ 0x0612, 0x02C0 },    /* R1554 - AIF2TX Left Volume */
> @@ -846,14 +878,23 @@ static bool wm1811_readable_register(struct device *dev, unsigned int reg)
>  	case WM8994_AIF1_DAC1_LEFT_VOLUME:
>  	case WM8994_AIF1_DAC1_RIGHT_VOLUME:
>  	case WM8994_AIF1_ADC1_FILTERS:
> +	case WM8994_AIF1_ADC2_FILTERS:
>  	case WM8994_AIF1_DAC1_FILTERS_1:
>  	case WM8994_AIF1_DAC1_FILTERS_2:
> +	case WM8994_AIF1_DAC2_FILTERS_1:
> +	case WM8994_AIF1_DAC2_FILTERS_2:
>  	case WM8958_AIF1_DAC1_NOISE_GATE:
> +	case WM8958_AIF1_DAC2_NOISE_GATE:
>  	case WM8994_AIF1_DRC1_1:
>  	case WM8994_AIF1_DRC1_2:
>  	case WM8994_AIF1_DRC1_3:
>  	case WM8994_AIF1_DRC1_4:
>  	case WM8994_AIF1_DRC1_5:
> +	case WM8994_AIF1_DRC2_1:
> +	case WM8994_AIF1_DRC2_2:
> +	case WM8994_AIF1_DRC2_3:
> +	case WM8994_AIF1_DRC2_4:
> +	case WM8994_AIF1_DRC2_5:
>  	case WM8994_AIF1_DAC1_EQ_GAINS_1:
>  	case WM8994_AIF1_DAC1_EQ_GAINS_2:
>  	case WM8994_AIF1_DAC1_EQ_BAND_1_A:
> @@ -875,6 +916,27 @@ static bool wm1811_readable_register(struct device *dev, unsigned int reg)
>  	case WM8994_AIF1_DAC1_EQ_BAND_5_B:
>  	case WM8994_AIF1_DAC1_EQ_BAND_5_PG:
>  	case WM8994_AIF1_DAC1_EQ_BAND_1_C:
> +	case WM8994_AIF1_DAC2_EQ_GAINS_1:
> +	case WM8994_AIF1_DAC2_EQ_GAINS_2:
> +	case WM8994_AIF1_DAC2_EQ_BAND_1_A:
> +	case WM8994_AIF1_DAC2_EQ_BAND_1_B:
> +	case WM8994_AIF1_DAC2_EQ_BAND_1_PG:
> +	case WM8994_AIF1_DAC2_EQ_BAND_2_A:
> +	case WM8994_AIF1_DAC2_EQ_BAND_2_B:
> +	case WM8994_AIF1_DAC2_EQ_BAND_2_C:
> +	case WM8994_AIF1_DAC2_EQ_BAND_2_PG:
> +	case WM8994_AIF1_DAC2_EQ_BAND_3_A:
> +	case WM8994_AIF1_DAC2_EQ_BAND_3_B:
> +	case WM8994_AIF1_DAC2_EQ_BAND_3_C:
> +	case WM8994_AIF1_DAC2_EQ_BAND_3_PG:
> +	case WM8994_AIF1_DAC2_EQ_BAND_4_A:
> +	case WM8994_AIF1_DAC2_EQ_BAND_4_B:
> +	case WM8994_AIF1_DAC2_EQ_BAND_4_C:
> +	case WM8994_AIF1_DAC2_EQ_BAND_4_PG:
> +	case WM8994_AIF1_DAC2_EQ_BAND_5_A:
> +	case WM8994_AIF1_DAC2_EQ_BAND_5_B:
> +	case WM8994_AIF1_DAC2_EQ_BAND_5_PG:
> +	case WM8994_AIF1_DAC2_EQ_BAND_1_C:
>  	case WM8994_AIF2_ADC_LEFT_VOLUME:
>  	case WM8994_AIF2_ADC_RIGHT_VOLUME:
>  	case WM8994_AIF2_DAC_LEFT_VOLUME:
> @@ -917,6 +979,8 @@ static bool wm1811_readable_register(struct device *dev, unsigned int reg)
>  	case WM8994_DAC2_RIGHT_MIXER_ROUTING:
>  	case WM8994_AIF1_ADC1_LEFT_MIXER_ROUTING:
>  	case WM8994_AIF1_ADC1_RIGHT_MIXER_ROUTING:
> +	case WM8994_AIF1_ADC2_LEFT_MIXER_ROUTING:
> +	case WM8994_AIF1_ADC2_RIGHT_MIXER_ROUTING:
>  	case WM8994_DAC1_LEFT_VOLUME:
>  	case WM8994_DAC1_RIGHT_VOLUME:
>  	case WM8994_DAC2_LEFT_VOLUME:

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
