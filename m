Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab3JGPSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 11:18:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:11265 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3JGPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 11:18:00 -0400
Message-ID: <5252D0A5.60304@atmel.com>
Date: Mon, 7 Oct 2013 17:17:57 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, "Felipe Balbi" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, Richard Genoud <richard.genoud@gmail.com>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 04/19] clk: at91: add PMC macro file for dt definitions
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375938270-3965-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375938270-3965-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 07:04, Boris BREZILLON :
> This patch adds a new macro file for PMC macros.
>
> This macro file includes the definitions of SR (status register) bit
> offsets and will be use to reference PMC irqs.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   include/dt-bindings/clk/at91/common/pmc.h |   20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
>   create mode 100644 include/dt-bindings/clk/at91/common/pmc.h
>
> diff --git a/include/dt-bindings/clk/at91/common/pmc.h b/include/dt-bindings/clk/at91/common/pmc.h
> new file mode 100644
> index 0000000..edc51d6
> --- /dev/null
> +++ b/include/dt-bindings/clk/at91/common/pmc.h
> @@ -0,0 +1,20 @@
> +/*
> + * This header provides constants for AT91 pmc status.
> + *
> + * The constants defined in this header are being used in dts.

It is better to add one line about license: for example:

  * Licensed under GPLv2 or later.


> + */
> +
> +#ifndef _DT_BINDINGS_CLK_AT91_PMC_H
> +#define _DT_BINDINGS_CLK_AT91_PMC_H
> +
> +#define AT91_PMC_MOSCS		0		/* MOSCS Flag */
> +#define AT91_PMC_LOCKA		1		/* PLLA Lock */
> +#define AT91_PMC_LOCKB		2		/* PLLB Lock */
> +#define AT91_PMC_MCKRDY		3		/* Master Clock */
> +#define AT91_PMC_LOCKU		6		/* UPLL Lock */
> +#define AT91_PMC_PCKRDY(id)	(8 + id)	/* Programmable Clock */

I prefer with parenthesis around "id" (8 + (id))

> +#define AT91_PMC_MOSCSELS	16		/* Main Oscillator Selection */
> +#define AT91_PMC_MOSCRCS	17		/* Main On-Chip RC */
> +#define AT91_PMC_CFDEV		18		/* Clock Failure Detector Event */
> +
> +#endif
>


-- 
Nicolas Ferre
