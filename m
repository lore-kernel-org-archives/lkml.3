Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3JHPhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 11:37:06 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:39496 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab3JHPhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 11:37:03 -0400
Message-ID: <5254269B.9020109@atmel.com>
Date: Tue, 8 Oct 2013 17:36:59 +0200
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
Subject: Re: [PATCH v3 10/19] ARM: at91/dt: add system clk id definitions
 in dt-bindings include dir
References: <1375937608-3773-1-git-send-email-b.brezillon@overkiz.com> <1375942504-9010-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375942504-9010-1-git-send-email-b.brezillon@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 08:15, Boris BREZILLON :
> This patch adds system clk ids definitions into dt-bindinds include dir
> (include/dt-bindings/clk/at91/'soc-name'/system-clk.h).
>
> These definitions will be used by dt definition to define and reference
> system clks.

As said earlier, I think that these definitions can be removed. We can 
stick with raw numbers and just document that we are using the offset of 
the coresponding bit in the register.

> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>   .../dt-bindings/clk/at91/at91rm9200/clk-system.h   |   16 +++++++++++++++
>   .../dt-bindings/clk/at91/at91sam9261/clk-system.h  |   15 ++++++++++++++
>   include/dt-bindings/clk/at91/common/clk-system.h   |   21 ++++++++++++++++++++
>   3 files changed, 52 insertions(+)
>   create mode 100644 include/dt-bindings/clk/at91/at91rm9200/clk-system.h
>   create mode 100644 include/dt-bindings/clk/at91/at91sam9261/clk-system.h
>   create mode 100644 include/dt-bindings/clk/at91/common/clk-system.h
>
> diff --git a/include/dt-bindings/clk/at91/at91rm9200/clk-system.h b/include/dt-bindings/clk/at91/at91rm9200/clk-system.h
> new file mode 100644
> index 0000000..43bccd5
> --- /dev/null
> +++ b/include/dt-bindings/clk/at91/at91rm9200/clk-system.h
> @@ -0,0 +1,16 @@
> +/*
> + * This header provides constants for AT91RM9200 system clocks.
> + *
> + * The constants defined in this header are being used in dts.
> + */
> +
> +#ifndef _DT_BINDINGS_CLK_AT91RM9200_SYSTEM_H
> +#define _DT_BINDINGS_CLK_AT91RM9200_SYSTEM_H
> +
> +#include <dt-bindings/clk/at91/common/system-clk.h>
> +
> +#define AT91RM9200_UDP_SYS_CLK		1
> +#define AT91RM9200_MCKUDP_SYS_CLK	2
> +#define AT91RM9200_UHP_SYS_CLK		4
> +
> +#endif
> diff --git a/include/dt-bindings/clk/at91/at91sam9261/clk-system.h b/include/dt-bindings/clk/at91/at91sam9261/clk-system.h
> new file mode 100644
> index 0000000..28a140a
> --- /dev/null
> +++ b/include/dt-bindings/clk/at91/at91sam9261/clk-system.h
> @@ -0,0 +1,15 @@
> +/*
> + * This header provides constants for AT91SAM9261 system clocks.
> + *
> + * The constants defined in this header are being used in dts.
> + */
> +
> +#ifndef _DT_BINDINGS_CLK_AT91SAM9261_SYSTEM_H
> +#define _DT_BINDINGS_CLK_AT91SAM9261_SYSTEM_H
> +
> +#include <dt-bindings/clk/at91/common/system-clk.h>
> +
> +#define AT91SAM9261_HCK0_SYS_CLK	16
> +#define AT91SAM9261_HCK1_SYS_CLK	17
> +
> +#endif
> diff --git a/include/dt-bindings/clk/at91/common/clk-system.h b/include/dt-bindings/clk/at91/common/clk-system.h
> new file mode 100644
> index 0000000..c0fb124
> --- /dev/null
> +++ b/include/dt-bindings/clk/at91/common/clk-system.h
> @@ -0,0 +1,21 @@
> +/*
> + * This header provides constants for AT91 system clocks.
> + *
> + * The constants defined in this header are being used in dts.
> + */
> +
> +#ifndef _DT_BINDINGS_CLK_AT91_SYSTEM_H
> +#define _DT_BINDINGS_CLK_AT91_SYSTEM_H
> +
> +#define AT91_PCK_SYS_CLK	0
> +#define AT91_DDRCK_SYS_CLK	2
> +#define AT91_LCDCK_SYS_CLK	3
> +#define AT91_SMDCK_SYS_CLK	4
> +#define AT91_UHP_SYS_CLK	6
> +#define AT91_UDP_SYS_CLK	7
> +
> +#define AT91_PROG_SYS_CLK(id)	(8 + id)
> +
> +#define AT91_MAX_SYS_CLKS	32
> +
> +#endif
>


-- 
Nicolas Ferre
