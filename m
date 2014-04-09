Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbaDINeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:34:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33183 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761AbaDINeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:34:06 -0400
Message-ID: <1397050384.22858.27.camel@iivanov-dev>
Subject: Re: [PATCH 4/4] pinctrl: msm: Add definitions for the APQ8064
 platform
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Wed, 09 Apr 2014 16:33:04 +0300
In-Reply-To: <1396302597-31801-4-git-send-email-bjorn.andersson@sonymobile.com>
References: <1396302597-31801-4-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Mon, 2014-03-31 at 14:49 -0700, Bjorn Andersson wrote:
> This adds pinctrl definitions for the GPIO pins of the TLMM v2 block in the
> Qualcomm APQ8064 platform.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  drivers/pinctrl/Kconfig           |   8 +
>  drivers/pinctrl/Makefile          |   1 +
>  drivers/pinctrl/pinctrl-apq8064.c | 567 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 576 insertions(+)
>  create mode 100644 drivers/pinctrl/pinctrl-apq8064.c
> 
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index 32b6b49..526f1c6 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -222,6 +222,14 @@ config PINCTRL_MSM
>  	select PINCONF
>  	select GENERIC_PINCONF
>  
> +config PINCTRL_APQ8064
> +	tristate "Qualcomm APQ8064 pin controller driver"
> +	depends on GPIOLIB && OF
> +	select PINCTRL_MSM
> +	help
> +	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
> +	  Qualcomm TLMM block found in the Qualcomm APQ8064 platform.

The comment is not directly related to this patch, but..
Should we start adding select PINCTRL in Qualcomm arches 
which support PINCTRL, otherwise there is no way to select 
desired implementation.

Regards,
Ivan


