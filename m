Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbaEIIUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:20:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54637 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaEIIUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:20:12 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-df-536c8fba5e2d
Message-id: <536C8FB8.7020806@samsung.com>
Date: Fri, 09 May 2014 10:20:08 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, jg1.han@samsung.com
Subject: Re: [PATCH v6 3/4] usb: ohci-exynos: Add facility to use phy provided
 by the generic phy framework
References: <5363D835.7010804@gmail.com>
 <1399266177-31765-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1399266177-31765-1-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xa7q7+nOCDW5ssrY4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWix+vL7BZ9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaLRctamR14
	PPbPXcPusXlJvUffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugSvj8WG3grm8Fd0P1rM0
	MJ7k6mLk5JAQMJHYu/0FK4QtJnHh3nq2LkYuDiGBpYwSf86cZIZwPjNK/Dx9iQ2kildAS2LH
	3BmMIDaLgKrEr/VrwLrZBNQkPjc8AqvhB6pZ03SdBcQWFYiQuNd4mBWiV1Dix+R7YHERgWyJ
	X9vbwGxmgfeMEn+n5HYxcnAIC+RKHLsRARIWEkiXePluF1gJp4CnxIQ96xghynUk9rdOY4Ow
	5SU2r3nLPIFRcBaSDbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkikfN3B
	uPSY1SFGAQ5GJR7eBTIZwUKsiWXFlbmHGCU4mJVEeD16c4KFeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MO4PUVsYFiW2SKF6ho/U6pVzN8zMVVoapdFsu7Z9vdbTIp1n1+t3BIpqmwZpLhWuP7zO
	W6nl4YviQ3wrDP/NYZuqNvec6j0P1v/3JDZpPH64SNfjxo6s9Jn5zi03Nmw9/UriYAdrWGvJ
	JB8FlccV2e/OZqrtb66Scjr+krFzY6LKIq4gb0mWz0osxRmJhlrMRcWJAOr2r4VyAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 05.05.2014 07:02, Vivek Gautam wrote:
> Add support to consume phy provided by Generic phy framework.
> Keeping the support for older usb-phy intact right now, in order
> to prevent any functionality break in absence of relevant
> device tree side change for ohci-exynos.
> Once we move to new phy in the device nodes for ohci, we can
> remove the support for older phys.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
> 
> Changes from v5:
>  - Removed setting phy explicitly to error pointer.
>  - Changed error check to '-ENOSYS' instead of '-ENXIO' in failure case of
>    devm_of_phy_get().
> 
> Changes from v4:
>  - Removed 'phy-names' property from the bindings since we don't need it.
>  - Restructured exynos_ohci_get_phy() function to handle error codes as
>    well as return relevant error codes effectively.
>  - Added IS_ERR() check for PHYs in exynos_ohci_phy_enable()/disable().
> 
> Changes from v3:
>  - Calling usb_phy_shutdown() when exynos_ohci_phy_enable() is failing.
>  - Made exynos_ohci_phy_disable() return void, since its return value
>    did not serve any purpose.
>  - Calling clk_disable_unprepare() in exynos_ohci_resume() when
>    exynos_ohci_phy_enable() is failed.
> 
>  .../devicetree/bindings/usb/exynos-usb.txt         |   16 +++
>  drivers/usb/host/ohci-exynos.c                     |  118 +++++++++++++++++---
>  2 files changed, 118 insertions(+), 16 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
