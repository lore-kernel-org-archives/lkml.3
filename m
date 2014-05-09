Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaEIIT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 04:19:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54612 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaEIITz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 04:19:55 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-88-536c8fa90899
Message-id: <536C8FA7.2040401@samsung.com>
Date: Fri, 09 May 2014 10:19:51 +0200
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
Subject: Re: [PATCH v12 4/4] usb: ehci-exynos: Change to use phy provided by
 the generic phy framework
References: <1399034855-9686-5-git-send-email-gautam.vivek@samsung.com>
 <1399266148-31729-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1399266148-31729-1-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xa7or+3OCDQ7N1LA4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWix+vL7BZ9C64ymax6fE1VouFbUtYLC7vmsNmMeP8PiaLRctamR14
	PPbPXcPusXlJvUffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1SN8ugSvj8MpLbAWrBCpOfP7C
	2sA4h7eLkZNDQsBEYtHBr0wQtpjEhXvr2boYuTiEBJYySvxf/ZwNJCEk8JlRYmVnLYjNK6Al
	cfX4BcYuRg4OFgFViaN7tEDCbAJqEp8bHoGV8wOVrGm6zgJiiwpESNxrPMwK0Soo8WPyPbC4
	iEC2xK/tbWA2s8B7Rom/U3JBRgoLZEisOcANcUIbo0TnjrdgvZwCnhKTFjcyQ9TrSOxvncYG
	YctLbF7zlnkCo+AsJCtmISmbhaRsASPzKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQSPm6
	g3HpMatDjAIcjEo8vAtkMoKFWBPLiitzDzFKcDArifB69OYEC/GmJFZWpRblxxeV5qQWH2Jk
	4uCUamC0EeRKLZcqOJz3i0dr047rx9P4/1bbHLx/ok3xJitnkmmO/t13Nnpclwz+em37X1y4
	X7NkWfLX61+3euj9S3yYobtUXTbsQubUmKdXSjz2TuT58KpW+8GP53LHXuj8kTWcnjD73kv/
	2L2Vva/r2ORvmdudnZ7vNONC3g6xRVqvllzN7dUsO3FYiaU4I9FQi7moOBEAPdzBjnICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 05.05.2014 07:02, Vivek Gautam wrote:
> From: Kamil Debski <k.debski@samsung.com>
> 
> Add the phy provider, supplied by new Exynos-usb2phy using
> Generic phy framework.
> Keeping the support for older USB phy intact right now, in order
> to prevent any functionality break in absence of relevant
> device tree side change for ehci-exynos.
> Once we move to new phy in the device nodes for ehci, we can
> remove the support for older phys.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> [gautam.vivek@samsung.com: Addressed review comments from mailing list]
> [gautam.vivek@samsung.com: Kept the code for old usb-phy, and just
> added support for new exynos5-usb2phy in generic phy framework]
> [gautam.vivek@samsung.com: Edited the commit message]
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
> 
> Changes from v11:
>  - Removed setting phy explicitly to error pointer.
>  - Changed error check to '-ENOSYS' instead of '-ENXIO' in failure case of
>    devm_of_phy_get().
> 
> Changes from v10:
>  - Removed 'phy-names' property from the bindings since we don't need it.
>  - Restructured exynos_ehci_get_phy() function to handle error codes as
>    well as return relevant error codes effectively.
>  - Added IS_ERR() check for PHYs in exynos_ehci_phy_enable()/disable().
> 
> Changes from v9:
>  - Calling usb_phy_shutdown() when exynos_ehci_phy_enable() is failing.
>  - Made exynos_ehci_phy_disable() return void, since its return value
>    did not serve any purpose.
>  - Calling clk_disable_unprepare() in exynos_ehci_resume() when
>    exynos_ehci_phy_enable() is failed.
> 
>  .../devicetree/bindings/usb/exynos-usb.txt         |   15 +++
>  drivers/usb/host/ehci-exynos.c                     |  129 +++++++++++++++++---
>  2 files changed, 124 insertions(+), 20 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
