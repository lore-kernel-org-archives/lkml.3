Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3LVPgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 10:36:53 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59378 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab3LVPgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 10:36:51 -0500
Message-ID: <52B706AF.8040408@ti.com>
Date: Sun, 22 Dec 2013 21:05:11 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rob Herring <rob.herring@calxeda.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <prabhakar.csengg@gmail.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] gpio: davinci: reuse for Keystone SoC
References: <1387361272-20861-1-git-send-email-grygorii.strashko@ti.com> <1387361272-20861-3-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1387361272-20861-3-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob,

On Wednesday 18 December 2013 03:37 PM, Grygorii Strashko wrote:
> The similar GPIO HW block is used by keystone SoCs as
> in Davinci SoCs.
> Hence, reuse Davinci GPIO driver for Keystone taking into
> account that Keystone contains ARM GIC IRQ controller which
> is implemented using IRQ Chip.
> 
> Documentation:
> 	http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: devicetree@vger.kernel.org
> 
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  .../devicetree/bindings/gpio/gpio-davinci.txt      |    4 +-
>  drivers/gpio/gpio-davinci.c                        |   46 ++++++++++++++++----
>  2 files changed, 40 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> index a2e839d..4ce9862 100644
> --- a/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> +++ b/Documentation/devicetree/bindings/gpio/gpio-davinci.txt
> @@ -1,7 +1,7 @@
> -Davinci GPIO controller bindings
> +Davinci/Keystone GPIO controller bindings
>  
>  Required Properties:
> -- compatible: should be "ti,dm6441-gpio"
> +- compatible: should be "ti,dm6441-gpio", "ti,keystone-gpio"

Can I get your ack for this change? Its pretty trivial, but still..

Thanks,
Sekhar
