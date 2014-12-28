Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaL1LVy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 06:21:54 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37372 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaL1LVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 06:21:51 -0500
Message-ID: <549FE7C9.5010909@gmail.com>
Date: Sun, 28 Dec 2014 20:21:45 +0900
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: kgene.kim@samsung.com, mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net,
        catalin.marinas@arm.com, will.deacon@arm.com, s.nawrocki@samsung.com,
        thomas.abraham@linaro.org, linus.walleij@linaro.org,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, a.kesavan@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/19] pinctrl: exynos: Add support for Exynos5433
References: <1417073716-22997-1-git-send-email-cw00.choi@samsung.com> <1417073716-22997-2-git-send-email-cw00.choi@samsung.com>
In-Reply-To: <1417073716-22997-2-git-send-email-cw00.choi@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 27.11.2014 16:34, Chanwoo Choi wrote:
> This patch adds driver data for Exynos5433 SoC. Exynos5433 includes 228 multi-
> functional input/output port pins and 135 memory port pins. There are 41 general
> port groups and 2 memory port groups.
>
> Cc: Tomasz Figa <tomasz.figa@gmail.com>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
> Acked-by: Inki Dae <inki.dae@samsung.com>
> ---
>   drivers/pinctrl/samsung/pinctrl-exynos.c  | 163 ++++++++++++++++++++++++++++++
>   drivers/pinctrl/samsung/pinctrl-samsung.c |   2 +
>   drivers/pinctrl/samsung/pinctrl-samsung.h |   1 +
>   3 files changed, 166 insertions(+)

Any plans for a respin? Apparently this patch needs a rebase. Also some 
comments below.

>
> diff --git a/drivers/pinctrl/samsung/pinctrl-exynos.c b/drivers/pinctrl/samsung/pinctrl-exynos.c
> index 8e3e0c0..bd4c4ec 100644
> --- a/drivers/pinctrl/samsung/pinctrl-exynos.c
> +++ b/drivers/pinctrl/samsung/pinctrl-exynos.c
> @@ -1268,6 +1268,169 @@ struct samsung_pin_ctrl exynos5420_pin_ctrl[] = {
>   	},
>   };
>
> +/* pin banks of exynos5433 pin-controller - ALIVE */
> +static struct samsung_pin_bank exynos5433_pin_banks0[] = {

Maybe instead the structure could be named exynos5433_pin_bank_alive? 
Similarly for remaining banks.

Also please, if not done already, please remember about documenting 
alias IDs of particular controllers in DT binding documentation.

> +	EXYNOS_PIN_BANK_EINTW(8, 0x000, "gpa0", 0x00),
> +	EXYNOS_PIN_BANK_EINTW(8, 0x020, "gpa1", 0x04),
> +	EXYNOS_PIN_BANK_EINTW(8, 0x040, "gpa2", 0x08),
> +	EXYNOS_PIN_BANK_EINTW(8, 0x060, "gpa3", 0x0c),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - AUD */
> +static struct samsung_pin_bank exynos5433_pin_banks1[] = {
> +	EXYNOS_PIN_BANK_EINTG(7, 0x000, "gpz0", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x020, "gpz1", 0x04),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - CPIF */
> +static struct samsung_pin_bank exynos5433_pin_banks2[] = {
> +	EXYNOS_PIN_BANK_EINTG(2, 0x000, "gpv6", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - eSE */
> +static struct samsung_pin_bank exynos5433_pin_banks3[] = {
> +	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj2", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - FINGER */
> +static struct samsung_pin_bank exynos5433_pin_banks4[] = {
> +	EXYNOS_PIN_BANK_EINTG(4, 0x000, "gpd5", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - FSYS */
> +static struct samsung_pin_bank exynos5433_pin_banks5[] = {
> +	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gph1", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x020, "gpr4", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x040, "gpr0", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x060, "gpr1", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x080, "gpr2", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpr3", 0x14),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - IMEM */
> +static struct samsung_pin_bank exynos5433_pin_banks6[] = {
> +	EXYNOS_PIN_BANK_EINTG(8, 0x000, "gpf0", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - NFC */
> +static struct samsung_pin_bank exynos5433_pin_banks7[] = {
> +	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj0", 0x00),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - PERIC */
> +static struct samsung_pin_bank exynos5433_pin_banks8[] = {
> +	EXYNOS_PIN_BANK_EINTG(6, 0x000, "gpv7", 0x00),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x020, "gpb0", 0x04),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x040, "gpc0", 0x08),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x060, "gpc1", 0x0c),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x080, "gpc2", 0x10),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x0a0, "gpc3", 0x14),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x0c0, "gpg0", 0x18),
> +	EXYNOS_PIN_BANK_EINTG(4, 0x0e0, "gpd0", 0x1c),
> +	EXYNOS_PIN_BANK_EINTG(6, 0x100, "gpd1", 0x20),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x120, "gpd2", 0x24),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x140, "gpd4", 0x28),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x160, "gpd8", 0x2c),
> +	EXYNOS_PIN_BANK_EINTG(7, 0x180, "gpd6", 0x30),
> +	EXYNOS_PIN_BANK_EINTG(3, 0x1a0, "gpd7", 0x34),
> +	EXYNOS_PIN_BANK_EINTG(5, 0x1c0, "gpg1", 0x38),
> +	EXYNOS_PIN_BANK_EINTG(2, 0x1e0, "gpg2", 0x3c),
> +	EXYNOS_PIN_BANK_EINTG(8, 0x200, "gpg3", 0x40),
> +};
> +
> +/* pin banks of exynos5433 pin-controller - TOUCH */
> +static struct samsung_pin_bank exynos5433_pin_banks9[] = {
> +	EXYNOS_PIN_BANK_EINTG(3, 0x000, "gpj1", 0x00),
> +};
> +
> +/*
> + * Samsung pinctrl driver data for Exynos5433 SoC. Exynos5433 SoC includes
> + * four gpio/pin-mux/pinconfig controllers.

Looks like "four" is a copy/paste error here.

Sorry for the delay. Unfortunately things are quite busy on my side 
nowadays.

Best regards,
Tomasz
