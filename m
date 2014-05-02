Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaEBNSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:18:07 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61064 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaEBNSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:18:04 -0400
Message-ID: <53639B02.1020101@samsung.com>
Date: Fri, 02 May 2014 22:17:54 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com
Subject: Re: [PATCH v5 0/4] usb: ehci/ohci-exynos: Move to generic phy framework
References: <1399034855-9686-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1399034855-9686-1-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 21:47, Vivek Gautam wrote:
> Based and tested on 'usb-next' branch of Greg's usb tree, with relevant
> device tree patches[1]
>
> Hi Alan,
>   I have included your Acked-by in all the four patches, but there has been
>   some amount of restructuring as suggested by Tomasz Figa.
>   Please let me know if you have some comments on this patch-series.
>
> Changes from v4:
>   - Addressed review comments for restructuring exynos_ohci_get_phy()
>     and exynos_ehci_get_phy(); and thereby adding proper checks in
>     exynos_ohci_phy_enable()/disable() as well as exynos_ehci_phy_enable()/
>     disable().
>
> Changes from v3:
>   - Calling usb_phy_shutdown() when exynos_o/ehci_phy_enable() is failing.
>   - Made exynos_o/ehci_phy_disable() return void, since its return value
>     did not serve any purpose.
>   - Calling clk_disable_unprepare() in exynos_o/ehci_resume() when
>     exynos_o/ehci_phy_enable() is failed.
>
> Changes from v2:
>   - Added two patches in the series for some cleanup.
>     usb: ohci-exynos: Use struct device instead of platform_device
>     usb: ehci-exynos: Use struct device instead of platform_device
>   - Addressed review comments.
>     -- Moved exynos_ohci_phyg_on()/off routines inside
>        exynos_ohci_phy_enable()/disable.
>     -- Added functions exynos_ehci_phy_enable() and exynos_ehci_phy_disable()
>        and moved exynos_ehci_phyg_on()/off routines respectively in them.
>     -- Added necessary checks.
>
> [1]: [PATCH 0/4] dts: Add usb2phy to Exynos 5250/5420
>       https://lkml.org/lkml/2014/4/30/119
>
> Kamil Debski (1):
>    usb: ehci-exynos: Change to use phy provided by the generic phy
>      framework
>
> Vivek Gautam (3):
>    usb: ohci-exynos: Use struct device instead of platform_device
>    usb: ehci-exynos: Use struct device instead of platform_device
>    usb: ohci-exynos: Add facility to use phy provided by the generic phy
>      framework
>
>   .../devicetree/bindings/usb/exynos-usb.txt         |   31 +++++
>   drivers/usb/host/ehci-exynos.c                     |  136 ++++++++++++++++----
>   drivers/usb/host/ohci-exynos.c                     |  134 +++++++++++++++----
>   3 files changed, 254 insertions(+), 47 deletions(-)
>
This series looks good to me, please feel free to add my ack on this series,

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin
