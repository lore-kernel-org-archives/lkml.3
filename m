Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965535AbaFRJXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:23:15 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60963 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964840AbaFRJXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:23:13 -0400
Date: Wed, 18 Jun 2014 10:23:07 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: sec-core: Prepare regulators for suspend state to
 reduce power-consumption
Message-ID: <20140618092307.GH23945@lee--X1>
References: <1402311930-24056-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402311930-24056-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014, Chanwoo Choi wrote:

> This patch use regulator_suspend_prepare() function to prepare the proper state
> of regulators for suspend state to remove un-necessary leakage power-consumption.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> This patch has a dependency on following patchset[1].
> - [1] https://lkml.org/lkml/2014/6/9/255
>   [PATCHv4 0/3] mfd: sec-core: Add support S2MPU02 PMIC device

... which has now been applied, so:

Applied, thanks.

>  drivers/mfd/sec-core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 5e8784b..e3413d5 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -30,6 +30,7 @@
>  #include <linux/mfd/samsung/s2mps14.h>
>  #include <linux/mfd/samsung/s5m8763.h>
>  #include <linux/mfd/samsung/s5m8767.h>
> +#include <linux/regulator/machine.h>
>  #include <linux/regmap.h>
>  
>  static const struct mfd_cell s5m8751_devs[] = {
> @@ -406,6 +407,13 @@ static int sec_pmic_suspend(struct device *dev)
>  	 */
>  	disable_irq(sec_pmic->irq);
>  
> +	switch (sec_pmic->device_type) {
> +	case S2MPS14X:
> +	case S2MPU02:
> +		regulator_suspend_prepare(PM_SUSPEND_MEM);
> +		break;
> +	};
> +
>  	return 0;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
