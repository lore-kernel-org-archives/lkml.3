Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbaH1Luv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 07:50:51 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61982 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaH1Lut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 07:50:49 -0400
Date: Thu, 28 Aug 2014 12:50:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pm@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 2/8] mfd: max14577: Map charger device to its own
 of_node
Message-ID: <20140828115041.GP24579@lee--X1>
References: <1409152814-17302-1-git-send-email-k.kozlowski@samsung.com>
 <1409152814-17302-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409152814-17302-3-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Krzysztof Kozlowski wrote:

> Add a "maxim,max14577-charger" of_compatible to the mfd_cell so the
> MFD child device (the charger) will have its own of_node set. This will
> be used by the max14577 charger driver in next patches to obtain battery
> configuration from DTS.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/mfd/max14577.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 4a5e885383f8..6599407b5624 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -35,7 +35,10 @@ static const struct mfd_cell max14577_devs[] = {
>  		.name = "max14577-regulator",
>  		.of_compatible = "maxim,max14577-regulator",
>  	},
> -	{ .name = "max14577-charger", },
> +	{
> +		.name = "max14577-charger",
> +		.of_compatible = "maxim,max14577-charger",
> +	},
>  };
>  
>  static const struct mfd_cell max77836_devs[] = {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
