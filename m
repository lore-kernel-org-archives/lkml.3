Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbaKRPYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:24:55 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35402 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbaKRPYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:24:51 -0500
Date: Tue, 18 Nov 2014 15:24:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, IIO <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>, Carlo Caione <carlo@caione.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>
Subject: Re: [PATCH 2/3] mfd/axp20x: avoid irq numbering collision
Message-ID: <20141118152443.GA13792@x1>
References: <1415734210-5657-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1415734210-5657-3-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415734210-5657-3-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Jacob Pan wrote:

> IRQ numbers in axp20x devices are defined with high-order bit first
> in each IRQ enable/status registers. On Intel platforms it is more
> common to number IRQs with least significant bit first. Therefore,
> sharing IRQ# between the two is very difficult. Since AXP288 is a
> customized PMIC for Intel platform and the amount of shared IRQs are
> very small, we use separate IRQ numbering. This also fixes collision
> and a duplicate in WBTO interrupt.
> 
> e.g. For the 16 interrupts controlled in IRQ enabled registers 1 & 2,
> on axp20x for ARM, the PMIC local IRQ numbers and register bits are
> mapped as:
> IRQ#:  0  1  2  3  4  5  6  7      8  9 10 11 12 13 14 15
> ---------------------------------------------------------
> ARM:   7  6  5  4  3  2  1  0      7  6  5  4  3  2  1  0
> Intel: 0  1  2  3  4  5  6  7      0  1  2  3  4  5  6  7
> 
> Signed-off-by: Todd Brandt <todd.e.brandt@linux.intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/mfd/axp20x.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> index daf3c8d..0a8fcd9 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp20x.c
> @@ -183,21 +183,21 @@ static const struct regmap_irq axp20x_regmap_irqs[] = {
>  
>  /* some IRQs are compatible with axp20x models */
>  static const struct regmap_irq axp288_regmap_irqs[] = {
> -	INIT_REGMAP_IRQ(AXP20X, VBUS_REMOVAL,           0, 2),
> -	INIT_REGMAP_IRQ(AXP20X, VBUS_PLUGIN,            0, 3),
> -	INIT_REGMAP_IRQ(AXP20X, VBUS_OVER_V,            0, 4),
> +	INIT_REGMAP_IRQ(AXP288, VBUS_FALL,              0, 2),
> +	INIT_REGMAP_IRQ(AXP288, VBUS_RISE,              0, 3),
> +	INIT_REGMAP_IRQ(AXP288, OV,                     0, 4),
>  
> -	INIT_REGMAP_IRQ(AXP20X, CHARG_DONE,             1, 2),
> -	INIT_REGMAP_IRQ(AXP20X, CHARG,                  1, 3),
> +	INIT_REGMAP_IRQ(AXP288, DONE,                   1, 2),
> +	INIT_REGMAP_IRQ(AXP288, CHARGING,               1, 3),
>  	INIT_REGMAP_IRQ(AXP288, SAFE_QUIT,              1, 4),
>  	INIT_REGMAP_IRQ(AXP288, SAFE_ENTER,             1, 5),
> -	INIT_REGMAP_IRQ(AXP20X, BATT_REMOVAL,           1, 6),
> -	INIT_REGMAP_IRQ(AXP20X, BATT_PLUGIN,            1, 7),
> +	INIT_REGMAP_IRQ(AXP288, ABSENT,                 1, 6),
> +	INIT_REGMAP_IRQ(AXP288, APPEND,                 1, 7),
>  
>  	INIT_REGMAP_IRQ(AXP288, QWBTU,                  2, 0),
>  	INIT_REGMAP_IRQ(AXP288, WBTU,                   2, 1),
>  	INIT_REGMAP_IRQ(AXP288, QWBTO,                  2, 2),
> -	INIT_REGMAP_IRQ(AXP288, WBTU,                   2, 3),
> +	INIT_REGMAP_IRQ(AXP288, WBTO,                   2, 3),
>  	INIT_REGMAP_IRQ(AXP288, QCBTU,                  2, 4),
>  	INIT_REGMAP_IRQ(AXP288, CBTU,                   2, 5),
>  	INIT_REGMAP_IRQ(AXP288, QCBTO,                  2, 6),
> @@ -215,7 +215,7 @@ static const struct regmap_irq axp288_regmap_irqs[] = {
>  	INIT_REGMAP_IRQ(AXP288, POKS,                   4, 4),
>  	INIT_REGMAP_IRQ(AXP288, POKN,                   4, 5),
>  	INIT_REGMAP_IRQ(AXP288, POKP,                   4, 6),
> -	INIT_REGMAP_IRQ(AXP20X, TIMER,                  4, 7),
> +	INIT_REGMAP_IRQ(AXP288, TIMER,                  4, 7),
>  
>  	INIT_REGMAP_IRQ(AXP288, MV_CHNG,                5, 0),
>  	INIT_REGMAP_IRQ(AXP288, BC_USB_CHNG,            5, 1),

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
