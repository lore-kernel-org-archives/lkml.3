Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaFYUxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:53:48 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:52599 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbaFYUxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:53:47 -0400
Message-ID: <53AB36DE.7090908@cogentembedded.com>
Date: Thu, 26 Jun 2014 00:53:50 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kishon@ti.com
Subject: Re: [PATCH 2/4] phy: miphy365x: Add MiPHY365x header file for DT
 x Driver defines
References: <1400766819-22286-1-git-send-email-lee.jones@linaro.org> <1400766819-22286-3-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1400766819-22286-3-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/22/2014 05:53 PM, Lee Jones wrote:

> This provides the shared header file which will be reference from both
> the MiPHY365x driver and its associated Device Tree node(s).

> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   include/dt-bindings/phy/phy-miphy365x.h | 25 +++++++++++++++++++++++++
>   1 file changed, 25 insertions(+)
>   create mode 100644 include/dt-bindings/phy/phy-miphy365x.h

> diff --git a/include/dt-bindings/phy/phy-miphy365x.h b/include/dt-bindings/phy/phy-miphy365x.h
> new file mode 100644
> index 0000000..8757c02
> --- /dev/null
> +++ b/include/dt-bindings/phy/phy-miphy365x.h
> @@ -0,0 +1,25 @@
> +/*
> + * This header provides constants for the phy framework
> + * based on the STMicroelectronics miphy365x.
> + */
> +#ifndef _DT_BINDINGS_PHY_MIPHY
> +#define _DT_BINDINGS_PHY_MIPHY
> +
> +/* Supports 16 ports without a datatype change (u8 & 0xF0). */
> +#define MIPHY_PORT_0			0
> +#define MIPHY_PORT_1			1
> +#define MIPHY_PORT_2			2
> +#define MIPHY_PORT_3			3
> +
> +/* Supports 16 types without a datatype change (u8 & 0x0F). */
> +#define MIPHY_TYPE_SHIFT		4
> +#define MIPHY_TYPE_SATA			(0 << MIPHY_TYPE_SHIFT)
> +#define MIPHY_TYPE_PCIE			(1 << MIPHY_TYPE_SHIFT)
> +#define MIPHY_TYPE_USB			(2 << MIPHY_TYPE_SHIFT)
> +
> +#define MIPHY_SATA_PORT0		(MIPHY_TYPE_SATA) | (MIPHY_PORT_0)
> +#define MIPHY_SATA_PORT1		(MIPHY_TYPE_SATA) | (MIPHY_PORT_1)
> +#define MIPHY_PCIE_PORT0		(MIPHY_TYPE_PCIE) | (MIPHY_PORT_0)
> +#define MIPHY_PCIE_PORT1		(MIPHY_TYPE_PCIE) | (MIPHY_PORT_1)

    No need to have parens around macros but you should instead enclose the 
'|' operator and its arguments into parens.

WBR, Sergei

