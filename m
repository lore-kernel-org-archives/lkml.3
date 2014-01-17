Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaAQTwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:52:08 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62056 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbaAQTwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:52:05 -0500
X-IronPort-AV: E=Sophos;i="4.95,675,1384329600"; 
   d="scan'208";a="9673084"
Message-ID: <52D989C2.6030603@broadcom.com>
Date: Fri, 17 Jan 2014 11:51:30 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Stephen Warren <swarren@nvidia.com>, Christian Daudt <bcm@fixthebug.org>
Subject: Re: [PATCH] pinctrl: capri: add dependency on OF
References: <1389912312-16285-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1389912312-16285-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-16 02:45 PM, Linus Walleij wrote:
> As this driver is using pinconf_generic_dt_node_to_map_pin() it
> needs to depend on OF so as not to cause build problems on
> archs that do not support OF.
>
> Cc: Sherman Yin <syin@broadcom.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>   drivers/pinctrl/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index f1dda4d9de13..be361b7cd30f 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -106,6 +106,7 @@ config PINCTRL_BCM2835
>
>   config PINCTRL_CAPRI
>   	bool "Broadcom Capri pinctrl driver"
> +	depends on OF
>   	select PINMUX
>   	select PINCONF
>   	select GENERIC_PINCONF
>

Thanks for the fix, Linus.  While we're visiting this config, should we 
add "depends on MACH_BCM_MOBILE" as well?

Thanks,
Sherman
