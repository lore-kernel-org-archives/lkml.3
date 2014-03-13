Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaCMNfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:35:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52401 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaCMNf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:35:29 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-51-5321b41ee266
From: Kamil Debski <k.debski@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: Tomasz Figa <t.figa@samsung.com>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <10501799.dhM9cVfZmk@wuerfel>
In-reply-to: <10501799.dhM9cVfZmk@wuerfel>
Subject: RE: [PATCH] phy: exynos: fix building as a module
Date: Thu, 13 Mar 2014 14:35:26 +0100
Message-id: <000801cf3ec1$18117040$483450c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8+Co8xAs5Ms6ALRHWm+jOxhMgRywAtjmNg
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t/xy7ryWxSDDY5GWfyddIzd4sLTHjaL
	TY+vsVpc3jWHzWL9jNcsDqwev39NYvTYvKTeo2/LKkaP4ze2M3l83iQXwBrFZZOSmpNZllqk
	b5fAldF24xxLwQ/eipON9xkbGD9ydzFyckgImEisfnudDcIWk7hwbz2QzcEhJLCUUeI4E0hY
	SKCBSeLy5iqQMJuApsSqex4gYREBZYnjL++wdDFycTALTGGUWDPxNDNEvaZE2+3drCA2p4CW
	xK1HW1lAbGEBK4mO3u2MIDaLgKrE6YUL2EFsXgEHiWk33kPZghI/Jt8Dq2cG6l2/E+IGZgF5
	ic1r3jKD3CAhoC7x6K8uxA1GEg/mT4YqEZG42/CcdQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRN
	LU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJh687GJceszrEKMDBqMTDG7BUIViINbGsuDL3EKME
	B7OSCK/1JsVgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzs7o3uv0OlZDZIaCrqWTH+tP4SPv/H
	i4kn2KJuckQ2Ps93a8u+NrVgx55OG/E4NgVrhgAnvjAO8SZfJcWLWwtVVolOnb7U++nBmN7U
	S5uDthjXzjFcKdB5++pTh70RWVJhm0++yf6sk7eFmT1my8a6deK8X66pL004vjwnfTZTUsph
	H6c1s5RYijMSDbWYi4oTAU5DbeZlAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Wednesday, March 12, 2014 4:48 PM
> 
> The top-level phy-samsung-usb2 driver may be configured as a loadable
> module, which currently causes link errors because of the dependency on
> the exynos{5250,4x12,4210}_usb2_phy_config
> symbol. Solving this could be achieved by exporting these symbols, but
> as the SoC-specific parts of the driver are not currently built as
> modules, it seems better to just link everything into one module and
> avoid the need for the export.

Thank you for this patch and spotting this error.

Acked-by: Kamil Debski <k.debski@samsung.com>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile index
> 2faf78e..7728518 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -13,8 +13,9 @@ obj-$(CONFIG_TI_PIPE3)			+=
phy-ti-pipe3.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
>  obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+= phy-exynos5250-sata.o
>  obj-$(CONFIG_PHY_SUN4I_USB)		+= phy-sun4i-usb.o
> -obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
> -obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
> -obj-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
> -obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
> +obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-exynos-usb2.o
> +phy-exynos-usb2-y			+= phy-samsung-usb2.o
> +phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+=
phy-exynos4210-usb2.o
> +phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+=
phy-exynos4x12-usb2.o
> +phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+=
phy-exynos5250-usb2.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o

