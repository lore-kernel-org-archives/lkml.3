Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaDQKa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:30:26 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:56760 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaDQKaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:30:24 -0400
Date: Thu, 17 Apr 2014 11:30:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Silvio F <silvio.fricke@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com
Subject: Re: [PATCH 2/6] mfd: stmpe: add optional regulators
Message-ID: <20140417103018.GK28725@lee--X1>
References: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
 <1397659455-13638-3-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397659455-13638-3-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The STMPE has VCC and VIO supply lines, and sometimes (as on
> Ux500) this comes from a software-controlled regulator. Make
> it possible to supply the STMPE with power from these
> regulators.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/stmpe.c       | 18 ++++++++++++++++++
>  include/linux/mfd/stmpe.h |  5 +++++
>  2 files changed, 23 insertions(+)

[...]

> +	stmpe->vcc = devm_regulator_get_optional(ci->dev, "vcc");
> +	if (!IS_ERR(stmpe->vcc)) {
> +		ret = regulator_enable(stmpe->vcc);
> +		if (ret)
> +			dev_warn(ci->dev, "failed to enable VCC supply\n");
> +	}
> +	stmpe->vio = devm_regulator_get_optional(ci->dev, "vio");
> +	if (!IS_ERR(stmpe->vio)) {
> +		ret = regulator_enable(stmpe->vio);
> +		if (ret)
> +			dev_warn(ci->dev, "failed to enable VIO supply\n");
> +	}

[...]

>  int stmpe_remove(struct stmpe *stmpe)
>  {
> +	if (!IS_ERR(stmpe->vio))
> +		regulator_disable(stmpe->vio);
> +	if (!IS_ERR(stmpe->vcc))
> +		regulator_disable(stmpe->vcc);
> +

Genuine question:
  Doesn't the regulator core take care of this for you on removal?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
