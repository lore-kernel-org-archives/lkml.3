Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaKJP0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:26:10 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:51079 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaKJP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:26:08 -0500
Date: Mon, 10 Nov 2014 15:25:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm8997: Mark INTERRUPT_STATUS_2_MASK as readable
Message-ID: <20141110152546.GE24004@x1>
References: <1415114782-32691-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415114782-32691-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014, Charles Keepax wrote:

> Technically this register is not used on wm8997 however the regmap core
> requires a continuous block of IRQs. The simplest solution is just to
> add the register.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm8997-tables.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm8997-tables.c b/drivers/mfd/wm8997-tables.c
> index 06c3093..c0c25d7 100644
> --- a/drivers/mfd/wm8997-tables.c
> +++ b/drivers/mfd/wm8997-tables.c
> @@ -670,6 +670,7 @@ static const struct reg_default wm8997_reg_default[] = {
>  	{ 0x00000C23, 0x0000 },    /* R3107  - Misc Pad Ctrl 4 */
>  	{ 0x00000C24, 0x0000 },    /* R3108  - Misc Pad Ctrl 5 */
>  	{ 0x00000D08, 0xFFFF },    /* R3336  - Interrupt Status 1 Mask */
> +	{ 0x00000D09, 0xFFFF },    /* R3337  - Interrupt Status 2 Mask */
>  	{ 0x00000D0A, 0xFFFF },    /* R3338  - Interrupt Status 3 Mask */
>  	{ 0x00000D0B, 0xFFFF },    /* R3339  - Interrupt Status 4 Mask */
>  	{ 0x00000D0C, 0xFEFF },    /* R3340  - Interrupt Status 5 Mask */
> @@ -1330,6 +1331,7 @@ static bool wm8997_readable_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_INTERRUPT_STATUS_4:
>  	case ARIZONA_INTERRUPT_STATUS_5:
>  	case ARIZONA_INTERRUPT_STATUS_1_MASK:
> +	case ARIZONA_INTERRUPT_STATUS_2_MASK:
>  	case ARIZONA_INTERRUPT_STATUS_3_MASK:
>  	case ARIZONA_INTERRUPT_STATUS_4_MASK:
>  	case ARIZONA_INTERRUPT_STATUS_5_MASK:

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
