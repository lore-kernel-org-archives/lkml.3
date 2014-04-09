Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbaDILNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:13:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10019 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:13:34 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-8a-53452b5de0ea
Message-id: <53452B59.8030901@samsung.com>
Date: Wed, 09 Apr 2014 13:13:29 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, jg1.han@samsung.com,
        sylvester.nawrocki@gmail.com
Subject: Re: [PATCH V4 5/5] usb-phy: samsung-usb3: Remove older
 phy-samsung-usb3 driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-6-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1396967803-28868-6-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t/xK7qx2q7BBg+Wc1scvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbO48LSHzWLT42usFgvblrBYXN41h81ixvl9TBaL
	lrUyW8z7vJPJgc9j56y77B77565h99i8pN6jb8sqRo/jN7YzeXzeJBfAFsVlk5Kak1mWWqRv
	l8CVsW7fXuaCX1wVu049Z2xg/MXRxcjJISFgIjF//iFWCFtM4sK99WxdjFwcQgJLGSV67l5m
	h3A+M0pMPHCaHaSKV0BLonPvEjCbRUBV4lv7G2YQm01ATeJzwyM2EJsfqGZN03UWEFtUIELi
	XuNhVoheQYkfk++xgAwVEfjJKPGusQcswSzQxyhx+oQtiC0sECnxtXkDI8TmdkaJCfN+AW3j
	4OAU8JS4eN0Yot5aYuWkbYwQtrzE5jVvmScwCs5CsmMWkrJZSMoWMDKvYhRNLU0uKE5KzzXS
	K07MLS7NS9dLzs/dxAiJpq87GJceszrEKMDBqMTDq2DpEizEmlhWXJl7iFGCg1lJhPc5m2uw
	EG9KYmVValF+fFFpTmrxIUYmDk6pBsao23JN52eZzGUreH+1jMPlcdISiZcxrI33nzisz1yZ
	7bIkfY3i/TCDAxzM9d+t46P7k/v9Lt740RtVp6QnHXZp/h6daydfyGTI8RcYauo5eh7frSNT
	FbhZIOCD7KmpqTvk4gSkEo8fjjw3/bLO36TzC5a7Zi0JP5ES8kfHzIJFak7Nov9zziuxFGck
	GmoxFxUnAgCd5fcdhAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 08.04.2014 16:36, Vivek Gautam wrote:
> Removing this older USB 3.0 DRD controller PHY driver, since
> a new driver based on generic phy framework is now available.
>
> Also removing the dt node for older driver from Exynos5250
> device tree and updating the dt node for DWC3 controller.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>
> NOTE: This patch should be merged only when the new USB 3.0
> DRD phy controller driver is available in the tree from the
> patches:
> 	phy: Add new Exynos5 USB 3.0 PHY driver; and
> 	dt: exynos5250: Enable support for generic USB DRD phy
>
>   arch/arm/boot/dts/exynos5250.dtsi  |   17 +-
>   drivers/usb/phy/phy-samsung-usb.h  |   83 ---------
>   drivers/usb/phy/phy-samsung-usb3.c |  350 ------------------------------------
>   3 files changed, 2 insertions(+), 448 deletions(-)
>   delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 92c6fcd..1cb1e91 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi

IMHO driver and dts changes should be separated into two patches, first 
updating device tree to use the new driver and second removing the driver.

After fixing this issue,

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
