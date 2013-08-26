Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791Ab3HZQTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:19:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:11172 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3HZQTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:19:35 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ad-521b8015a0c6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com, t.figa@samsung.com,
        tomasz.figa@gmail.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, mturquette@linaro.org, thomas.abraham@linaro.org,
        t.stanislaws@samsung.com, m.chehab@samsung.com, s.nawrocki@samsung.com,
        m.szyprowski@samung.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC 3/5] ARM: samsung: add clock setup for FIMC and FIMD
Date: Mon, 26 Aug 2013 18:19:18 +0200
Message-id: <1445676.NMCyFEC5q4@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1377517114-20222-4-git-send-email-m.krawczuk@partner.samsung.com>
References: <1377517114-20222-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1377517114-20222-4-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jQV3RBukggy/njC3mHznHavGmt4PF
	onfBVTaLs01v2C02Pb7GarGwbQmLxeVdc9gsZpzfx2Rx+zKvxcV18han15xitnjdd5jFYun1
	i0wWTydcZLOYMH0ti8XhFQeYLNa9nA5kvWlntXh1sI3FYv2M1ywW89pfslocm7GE0WLVrj+M
	DuIea+atYfRoae5h81jw+Qq7x+vJExg9ds66y+7xavVMVo871/aweWxeUu9x8N0eJo++LasY
	Pbo/3WL1+LxJzmPj3NAA3igum5TUnMyy1CJ9uwSujMfL3zIVbJOoePunh7GBsUOki5GTQ0LA
	RKJnyh1mCFtM4sK99WxdjFwcQgLTGSVWrTvCCOG0MEkcmbCQHaSKTcBKYmL7KkYQW0TAVOLd
	3WtgHcwCu1gk3j5YATZKWMBHYuPzt2wgNouAqsTPB5/A4rwCmhLnu6+A2aICrhLnFv1gAbE5
	Bfwl9i2cyQpiCwlMZpTY89QRol5Q4sfke2A1zALyEvv2T2WFsHUk9rdOY5vAKDALSdksJGWz
	kJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc0c+kdzCuarA4xCjAwajEwxvAJh0k
	xJpYVlyZe4hRgoNZSYSXIxUoxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6Yklqdmpq
	QWoRTJaJg1MKGNBLJequ7Sg0u1Y5TSxkhsd2n6r9ulH8uVVxoqnrWSyvJliwf728QL8qfF/Y
	CkONjj9VCeqVJfkHIlriEgrWZDi++tbXXL7EdZsPR7bycb09hrtlAvSFdnF/bi+L2D3z4KTj
	qnL7Xdy8xCLq5ftvFlpwRAlNaV08x9E8yUmxZGlI1PH9SjOUWIozEg21mIuKEwGphZ8r5AIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, August 26, 2013 01:38:32 PM Mateusz Krawczuk wrote:
> This patch adds code that sets correct parents and rates for clocks
> used by FIMC and FIMD on Goni board.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> ---
>  arch/arm/mach-s5pv210/mach-goni.c | 48 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
> index e5cd9fb..309b5ad 100644
> --- a/arch/arm/mach-s5pv210/mach-goni.c
> +++ b/arch/arm/mach-s5pv210/mach-goni.c
> @@ -55,6 +55,7 @@
>  #include <media/s5p_fimc.h>
>  #include <media/noon010pc30.h>
>  
> +#include <linux/clk.h>
>  #include "common.h"
>  
>  /* Following are default values for UCON, ULCON and UFCON UART registers */
> @@ -195,6 +196,49 @@ static struct platform_device goni_spi_gpio = {
>  	},
>  };
>  
> +static void set_fimd_clock(void)

It can be marked as __init.

> +{
> +	struct clk *lcd_clk, *parent_clk;
> +
> +	lcd_clk = clk_get(NULL, "sclk_fimd");
> +	parent_clk = clk_get(NULL, "mout_mpll");
> +	clk_set_parent(lcd_clk, parent_clk);
> +	clk_set_rate(lcd_clk, clk_get_rate(parent_clk)/3);
> +
> +	clk_put(parent_clk);
> +	clk_put(lcd_clk);
> +}
> +
> +static void set_fimc_clock(void)

ditto

> +{
> +	struct clk *cam0_clk, *cam1_clk, *fimc2_clk, *fimc1_clk,
> +			*fimc0_clk, *parent_clk, *vpll_clk, *csis_clk;
> +
> +	parent_clk = clk_get(NULL, "mout_mpll");
> +	vpll_clk = clk_get(NULL, "mout_vpll");
> +	cam0_clk = clk_get(NULL, "mout_cam0");
> +	cam1_clk = clk_get(NULL, "mout_cam1");
> +	fimc2_clk = clk_get(NULL, "mout_fimc2");
> +	fimc1_clk = clk_get(NULL, "mout_fimc1");
> +	fimc0_clk = clk_get(NULL, "mout_fimc0");
> +	csis_clk = clk_get(NULL, "mout_csis");

Shouldn't you check clk_get() return value with IS_ERR()?

You can do one big check here and than just do clk_put() if !IS_ERR(), i.e.

if (IS_ERR(parent_clk) || IS_ERR(vpll_clk) || ...)
...

clk_set_parent()
...

if (!IS_ERR(parent_clk))
	clk_put(parent_clk);
...

> +	clk_set_parent(cam0_clk, vpll_clk);
> +	clk_set_parent(cam1_clk, vpll_clk);
> +	clk_set_parent(fimc2_clk, parent_clk);
> +	clk_set_parent(fimc1_clk, parent_clk);
> +	clk_set_parent(fimc0_clk, parent_clk);
> +	clk_set_parent(csis_clk, parent_clk);
> +
> +	clk_put(parent_clk);
> +	clk_put(vpll_clk);
> +	clk_put(cam0_clk);
> +	clk_put(cam1_clk);
> +	clk_put(fimc2_clk);
> +	clk_put(fimc1_clk);
> +	clk_put(fimc0_clk);
> +}
> +
>  /* KEYPAD */
>  static uint32_t keymap[] __initdata = {
>  	/* KEY(row, col, keycode) */
> @@ -931,6 +975,10 @@ static void __init goni_machine_init(void)
>  	s3c_i2c2_set_platdata(&i2c2_data);
>  	i2c_register_board_info(2, i2c2_devs, ARRAY_SIZE(i2c2_devs));
>  
> +	/* FIMD AND FIMC set clock config */
> +	set_fimd_clock();
> +	set_fimc_clock();
> +
>  	/* PMIC */
>  	goni_pmic_init();
>  	i2c_register_board_info(AP_I2C_GPIO_PMIC_BUS_4, i2c_gpio_pmic_devs,

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

