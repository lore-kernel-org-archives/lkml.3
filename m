Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3LOMhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 07:37:52 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38207 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab3LOMht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 07:37:49 -0500
Message-ID: <52ADA231.4080603@ti.com>
Date: Sun, 15 Dec 2013 18:06:01 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 2/6] This patch converts the davinci gpio driver to
 use irqdomain support.
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com> <1385057731-4348-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1385057731-4348-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 November 2013 11:45 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> [grygorii.strashko@ti.com:
>  - switch to use one irq-domain per  all GPIO banks
>  - keep irq_create_mapping() call in gpio_to_irq_banked() as it
>    simply transformed to irq_find_mapping() if IRQ mapping exist
>    already]
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

A proper subject line is missing. I added the following as the subject:

gpio: davinci: convert to use irqdomain

and moved your current subject line to become the commit text.

> @@ -396,6 +411,20 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
>  	}
>  	clk_prepare_enable(clk);
>  
> +	irq = irq_alloc_descs(-1, 0, ngpio, 0);
> +	if (irq < 0) {
> +		dev_err(dev, "Couldn't allocate IRQ numbers\n");
> +		return -ENODEV;

modified this to:

		return irq;

since your have already received a more relevant error code. With these
modifications and Linus's ack, queuing for v3.14.

Thanks,
Sekhar
