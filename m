Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3GQL2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 07:28:09 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:54355 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3GQL2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 07:28:07 -0400
Date: Wed, 17 Jul 2013 12:27:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sbkim73@samsung.com, sameo@linux.intel.com, mturquette@linaro.org,
        broonie@kernel.org, yadi.brar01@gmail.com
Subject: Re: [PATCH 3/3] mfd: s2mps11: Remove clocks from regulators list
Message-ID: <20130717112759.GD3336@laptop>
References: <1373197462-4033-1-git-send-email-yadi.brar@samsung.com>
 <1373197462-4033-4-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1373197462-4033-4-git-send-email-yadi.brar@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Jul 2013, Yadwinder Singh Brar wrote:

> Since these are fixed rate clocks which are registered with common clock
> framework so remove these from list of regulators which were unnecessarily
> incrementing the count(S2MPS11_REGULATOR_MAX) of regulators.
> 
> Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
> ---
>  include/linux/mfd/samsung/s2mps11.h |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mfd/samsung/s2mps11.h b/include/linux/mfd/samsung/s2mps11.h
> index d0d52ea..b3ddf98 100644
> --- a/include/linux/mfd/samsung/s2mps11.h
> +++ b/include/linux/mfd/samsung/s2mps11.h
> @@ -167,11 +167,8 @@ enum s2mps11_regulators {
>  	S2MPS11_BUCK8,
>  	S2MPS11_BUCK9,
>  	S2MPS11_BUCK10,
> -	S2MPS11_AP_EN32KHZ,
> -	S2MPS11_CP_EN32KHZ,
> -	S2MPS11_BT_EN32KHZ,

These aren't mentioned anywhere else in the kernel, so I'll just apply
the patch.

> -	S2MPS11_REG_MAX,
> +	S2MPS11_REGULATOR_MAX,
>  };
>  
>  #define S2MPS11_BUCK_MIN1	600000
> @@ -203,6 +200,5 @@ enum s2mps11_regulators {
>  #define S2MPS11_BUCK4_RAMP_EN_SHIFT	1
>  #define S2MPS11_BUCK6_RAMP_EN_SHIFT	0
>  #define S2MPS11_PMIC_EN_SHIFT	6
> -#define S2MPS11_REGULATOR_MAX (S2MPS11_REG_MAX - 3)
>  
>  #endif /*  __LINUX_MFD_S2MPS11_H */

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
