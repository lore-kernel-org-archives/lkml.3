Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbaETR31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:29:27 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:47014 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaETR30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:29:26 -0400
Date: Tue, 20 May 2014 18:29:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        broonie@linaro.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: correct addresses of always-on trigger
 registers
Message-ID: <20140520172920.GC32538@lee--X1>
References: <20140520124851.GB13900@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520124851.GB13900@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Update the addresses and names to match current silicon.
> The WM8997 regmap tables have been adjusted to match the new
> names.
> Missing registers have been added to WM5110 default value table.
> 
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c           |    2 ++
>  drivers/mfd/wm5110-tables.c           |   12 ++++++++----
>  drivers/mfd/wm8997-tables.c           |   12 ++++++------
>  include/linux/mfd/arizona/registers.h |   14 ++++++++------
>  4 files changed, 24 insertions(+), 16 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index 9b9923c..641aed7 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -1037,6 +1037,8 @@ static bool wm5102_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_4:
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_5:
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_6:
> +	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_7:
> +	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_8:
>  	case ARIZONA_COMFORT_NOISE_GENERATOR:
>  	case ARIZONA_HAPTICS_CONTROL_1:
>  	case ARIZONA_HAPTICS_CONTROL_2:
> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index d10fc44..9b98ee5 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -683,10 +683,12 @@ static const struct reg_default wm5110_reg_default[] = {
>  	{ 0x00000062, 0x01FF },    /* R98    - Sample Rate Sequence Select 2 */
>  	{ 0x00000063, 0x01FF },    /* R99    - Sample Rate Sequence Select 3 */
>  	{ 0x00000064, 0x01FF },    /* R100   - Sample Rate Sequence Select 4 */
> -	{ 0x00000068, 0x01FF },    /* R104   - Always On Triggers Sequence Select 1 */
> -	{ 0x00000069, 0x01FF },    /* R105   - Always On Triggers Sequence Select 2 */
> -	{ 0x0000006A, 0x01FF },    /* R106   - Always On Triggers Sequence Select 3 */
> -	{ 0x0000006B, 0x01FF },    /* R107   - Always On Triggers Sequence Select 4 */
> +	{ 0x00000066, 0x01FF },    /* R102   - Always On Triggers Sequence Select 1 */
> +	{ 0x00000067, 0x01FF },    /* R103   - Always On Triggers Sequence Select 2 */
> +	{ 0x00000068, 0x01FF },    /* R104   - Always On Triggers Sequence Select 3 */
> +	{ 0x00000069, 0x01FF },    /* R105   - Always On Triggers Sequence Select 4 */
> +	{ 0x0000006A, 0x01FF },    /* R106   - Always On Triggers Sequence Select 5 */
> +	{ 0x0000006B, 0x01FF },    /* R107   - Always On Triggers Sequence Select 6 */
>  	{ 0x00000070, 0x0000 },    /* R112   - Comfort Noise Generator */
>  	{ 0x00000090, 0x0000 },    /* R144   - Haptics Control 1 */
>  	{ 0x00000091, 0x7FFF },    /* R145   - Haptics Control 2 */
> @@ -1716,6 +1718,8 @@ static bool wm5110_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_2:
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_3:
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_4:
> +	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_5:
> +	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_6:
>  	case ARIZONA_COMFORT_NOISE_GENERATOR:
>  	case ARIZONA_HAPTICS_CONTROL_1:
>  	case ARIZONA_HAPTICS_CONTROL_2:
> diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
> index 529adc1..d641474 100644
> --- a/drivers/mfd/wm8997-tables.c
> +++ b/drivers/mfd/wm8997-tables.c
> @@ -174,10 +174,10 @@ static const struct reg_default wm8997_reg_default[] = {
>  	{ 0x00000062, 0x01FF },    /* R98    - Sample Rate Sequence Select 2 */
>  	{ 0x00000063, 0x01FF },    /* R99    - Sample Rate Sequence Select 3 */
>  	{ 0x00000064, 0x01FF },    /* R100   - Sample Rate Sequence Select 4 */
> -	{ 0x00000068, 0x01FF },    /* R104   - Always On Triggers Sequence Select 1 */
> -	{ 0x00000069, 0x01FF },    /* R105   - Always On Triggers Sequence Select 2 */
> -	{ 0x0000006A, 0x01FF },    /* R106   - Always On Triggers Sequence Select 3 */
> -	{ 0x0000006B, 0x01FF },    /* R107   - Always On Triggers Sequence Select 4 */
> +	{ 0x00000068, 0x01FF },    /* R104   - Always On Triggers Sequence Select 3 */
> +	{ 0x00000069, 0x01FF },    /* R105   - Always On Triggers Sequence Select 4 */
> +	{ 0x0000006A, 0x01FF },    /* R106   - Always On Triggers Sequence Select 5 */
> +	{ 0x0000006B, 0x01FF },    /* R107   - Always On Triggers Sequence Select 6 */
>  	{ 0x00000070, 0x0000 },    /* R112   - Comfort Noise Generator */
>  	{ 0x00000090, 0x0000 },    /* R144   - Haptics Control 1 */
>  	{ 0x00000091, 0x7FFF },    /* R145   - Haptics Control 2 */
> @@ -814,10 +814,10 @@ static bool wm8997_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_SAMPLE_RATE_SEQUENCE_SELECT_2:
>  	case ARIZONA_SAMPLE_RATE_SEQUENCE_SELECT_3:
>  	case ARIZONA_SAMPLE_RATE_SEQUENCE_SELECT_4:
> -	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_1:
> -	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_2:
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_3:
>  	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_4:
> +	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_5:
> +	case ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_6:
>  	case ARIZONA_COMFORT_NOISE_GENERATOR:
>  	case ARIZONA_HAPTICS_CONTROL_1:
>  	case ARIZONA_HAPTICS_CONTROL_2:
> diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
> index c445bf0..dbd23c3 100644
> --- a/include/linux/mfd/arizona/registers.h
> +++ b/include/linux/mfd/arizona/registers.h
> @@ -42,12 +42,14 @@
>  #define ARIZONA_SAMPLE_RATE_SEQUENCE_SELECT_2    0x62
>  #define ARIZONA_SAMPLE_RATE_SEQUENCE_SELECT_3    0x63
>  #define ARIZONA_SAMPLE_RATE_SEQUENCE_SELECT_4    0x64
> -#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_1 0x68
> -#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_2 0x69
> -#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_3 0x6A
> -#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_4 0x6B
> -#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_5 0x6C
> -#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_6 0x6D
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_1 0x66
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_2 0x67
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_3 0x68
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_4 0x69
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_5 0x6A
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_6 0x6B
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_7 0x6C
> +#define ARIZONA_ALWAYS_ON_TRIGGERS_SEQUENCE_SELECT_8 0x6D
>  #define ARIZONA_COMFORT_NOISE_GENERATOR          0x70
>  #define ARIZONA_HAPTICS_CONTROL_1                0x90
>  #define ARIZONA_HAPTICS_CONTROL_2                0x91

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
