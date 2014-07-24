Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbaGXKgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:36:46 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52285 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758577AbaGXKgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:36:44 -0400
Message-ID: <1406198202.20036.17.camel@x220>
Subject: Re: [PATCH 27/28] phy: miphy365x: Provide support for the MiPHY356x
 Generic PHY
From: Paul Bolle <pebolle@tiscali.nl>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 Jul 2014 12:36:42 +0200
In-Reply-To: <1406026611-30493-28-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
	 <1406026611-30493-28-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2014 10:36:42.0731 (UTC) FILETIME=[28D1E3B0:01CFA72B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-22 at 16:26 +0530, Kishon Vijay Abraham I wrote:
> From: Lee Jones <lee.jones@linaro.org>
> 
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---

This patch landed in today's linux-next (ie, next-20140724).

>[...]
> --- /dev/null
> +++ b/drivers/phy/phy-miphy365x.c
> @@ -0,0 +1,616 @@
>[...]
> +
> +#define PLL_CTRL1_REG		0x50
> +#define PLL_START_CAL		BIT(0)
> +#define BUF_EN			BIT(2)
> +#define SYNCHRO_TX		BIT(3)
> +#define SSC_EN			BIT(6)
> +#define CONFIG_PLL		BIT(7)

This is probably a pet peeve very few people share, but anyway: would it
be possible to not use the CONFIG_ prefix here? Ie, to use, say, CONF_
or CFG_ instead.

I know there are quite a few preprocessor defines for macros starting
with CONFIG_ already. And I realize CONFIG_ is rather generic. But that
is what the build system uses so I do think it would preferable to try
to use it only for actual Kconfig macros.


Paul Bolle

