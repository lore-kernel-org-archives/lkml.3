Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaEONbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:31:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32936 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaEONba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:31:30 -0400
X-AuditID: cbfee61b-b7f766d00000646c-c2-5374c1af5379
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Rahul Sharma <rahul.sharma@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org, a.hajda@samsung.com,
        t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com
Subject: Re: [PATCH v3 1/3] phy: Add exynos-simple-phy driver
Date: Thu, 15 May 2014 15:31:15 +0200
Message-id: <1584926.JkD1mqdaNu@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
 <1400095043-685-2-git-send-email-rahul.sharma@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xgO6GgyXBBtfPsFncWneO1WL+ESBx
	5et7NosDf3YwWnzf9YXdonfBVTaLC0972CzONr1ht7i8aw6bxYzz+5gspiw6zGrRuvcIu8W8
	zzuZLOa1v2R14PPYOesuu8emVZ1sHneu7WHzuN99nMmjb8sqRo/jN7YzeXzeJBfAHsVlk5Ka
	k1mWWqRvl8CVMeHARJaCDt6KzhvPmRsYf3F2MXJwSAiYSHy7ptPFyAlkiklcuLeeDcQWEljE
	KLHvRlEXIxeQ3cIk0fFyOyNIgk3ASmJi+yowW0RAW6LhWAsbSBGzwDUmiX0/9rCDJIQFbCX6
	3i1hAbFZBFQlJrzvZQaxeQU0JZ7+O8IEYosKeErs2L6SDeQITgF3iZvz1SGWNTNKbD12lgWi
	XlDix+R7YDazgLzEvv1TWSFsHYn9rdPYJjAKzEJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBMfPM+kdjKsaLA4xCnAwKvHwMkwuDhZiTSwrrsw9xCjBwawkwts4vSRY
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQimCwTB6dUA2Nmllem/HcL
	41fhgTc2hdU9VrmhlTl7NldTZNP1FUcs+QrrJ9U9fjy963qWpljo7jTtd3XT23xV/eKu3cuX
	105QMvrQvy8vV1cnbF6OYf5enm8ZDII6v3Rfz9Pr4DjSfvpv9qnrC1wCVQS5LNmFdm3tDVzV
	duCqwIK6LwstG98/v2abz5V5QImlOCPRUIu5qDgRAHSOijybAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday, May 15, 2014 12:47:21 AM Rahul Sharma wrote:
> From: Tomasz Stanislawski <t.stanislaws@samsung.com>
> 
> Add exynos-simple-phy driver to support a single register
> PHY interfaces present on Exynos4 SoC.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Rahul Sharma <Rahul.Sharma@samsung.com>
> 
> ---
>  .../devicetree/bindings/phy/samsung-phy.txt        |   56 ++++++
>  drivers/phy/Kconfig                                |    5 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/exynos-simple-phy.c                    |  189 ++++++++++++++++++++
>  include/dt-bindings/phy/exynos-simple-phy.h        |   27 +++
>  5 files changed, 278 insertions(+)
>  create mode 100644 drivers/phy/exynos-simple-phy.c
>  create mode 100644 include/dt-bindings/phy/exynos-simple-phy.h

[...]

> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 16a2f06..2a13e0d 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -178,4 +178,9 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config EXYNOS_SIMPLE_PHY
> +	tristate "Exynos Simple PHY driver"

Please limit this driver to EXYNOS platforms with:

	depends on ARCH_EXYNOS 

or (optionally)

	depends on ARCH_EXYNOS || COMPILE_TEST

Moreover the generic PHY dependency is missing.  It can be fixed with:

	select GENERIC_PHY

> +	help
> +	  Support for 1-bit PHY controllers on SoCs from Exynos family.
> +
>  endmenu

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

