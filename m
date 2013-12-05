Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab3LEPHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:07:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34291 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3LEPHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:07:20 -0500
Message-ID: <52A0969A.5070607@ti.com>
Date: Thu, 5 Dec 2013 20:37:06 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>
Subject: Re: [PATCH v4 0/9] phy: Add new Exynos USB 2.0 PHY driver
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 05 December 2013 05:59 PM, Kamil Debski wrote:
> Hi,
> 
> This is the fourth version of the patchset adding the new Exynos USB 2.0 PHY
> driver. The driver uses the Generic PHY Framework.
> 
> A month has passed since the last version. I have addressed numerous comments
> that appeared on the mailing list in this patch. I would like to specially
> thank Kishon, Tomasz, Matt and Vivek for their comments.
> 
> This patch contains two necessary patches to the phy core.
> It is very useful to be able to get phy using a device tree node.
> 
> In addition this patch depends on:
> [PATCH V11 1/3] ARM: dts: Add pmu sysreg node to exynos5250 and exynos5420 dtsi
> files [1].
> 
> Best wishes,
> Kamil Debski

The last four patches are missing [1]

[1] -> https://lkml.org/lkml/2013/12/5/166

Thanks
Kishon
> 
> [1] - http://www.spinics.net/lists/linux-samsung-soc/msg24528.html
> 
> ----------------
> Changes from v3:
> - using PMU and system registers indirectly via syscon
> - change labelling
> - change Kconfig name
> - fixed typos/stray whitespace
> - move of_phy_provider_register() to the end of probe
> - add a regular error return code to the rate_to_clk functions
> - cleanup code and remove unused code
> - change struct names to avoid collisions
> - add mechanism to support multiple phys by the ehci driver
> 
> ----------------
> Changes from v2:
> - rebase all patches to the usb-next branch
> - fixes in the documentation file
>   - remove wrong entries in the phy node (ranges, and #address- & #size-cells)
>   - add clocks and clock-names as required properites
>   - rephrase a few sentences
> - fixes in the ehci-exynos.c file
>   - move phy_name variable next to phy in exynos_ehci_hcd
>   - remove otg from exynos_ehci_hcd as it was no longer used
>   - move devm_phy_get after the Exynos5440 skip_phy check
> - fixes in the s3c-hsotg.c file
>   - cosmetic fixes (remove empty line that was wrongfully added)
> - fixes in the main driver
>   - remove cpu_type in favour for a boolean flag matched with the compatible
>     value
>   - rename files, structures, variables and Kconfig entires - change from simple
>     "uphy" to "usb2_phy"
>   - fix multiline comments style
>   - simplify #ifdefs in of_device_id
>   - fix Kconfig description
>   - change dev_info to dev_dbg where reasonable
>   - cosmetic changes (remove wrongful blank lines)
>   - remove unnecessary reference counting
> 
> ----------------
> Changes from v1:
> - the changes include minor fixes of the hardware initialization of the PHY
>   module
> - some other minor fixes were introduced
> 
> ----------------------
> Original cover letter:
> 
> Hi,
> 
> This patch adds a new drive for USB PHYs for Samsung SoCs. The driver is
> using the Generic PHY Framework created by Kishon Vijay Abrahan I. It
> can be found here https://lkml.org/lkml/2013/8/21/29. This patch adds
> support to Exynos4 family of SoCs. Support for Exynos3 and Exynos5 is
> planned to be added in the near future.
> 
> I welcome your comments.
> 
> ----------------------
> 
> [1] https://lkml.org/lkml/2013/8/21/29
> 
> 
> Kamil Debski (8):
>   phy: core: Change the way of_phy_get is called
>   phy: core: Add devm_of_phy_get to phy-core
>   phy: Add new Exynos USB PHY driver
>   usb: ehci-s5p: Change to use phy provided by the generic phy
>     framework
>   usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic
>     phy framework
>   phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver
>   dts: Add usb2phy to Exynos 4
>   dts: Add usb2phy to Exynos 5250
> 
> Mateusz Krawczuk (1):
>   phy: Add support for S5PV210 to the Exynos USB PHY driver
> 
>  .../devicetree/bindings/arm/samsung/pmu.txt        |    2 +
>  .../devicetree/bindings/phy/samsung-usbphy.txt     |   56 +++
>  .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 +
>  Documentation/devicetree/bindings/usb/usb-ehci.txt |   35 ++
>  arch/arm/boot/dts/exynos4.dtsi                     |   31 ++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   17 +
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   17 +
>  arch/arm/boot/dts/exynos5250.dtsi                  |   33 +-
>  drivers/phy/Kconfig                                |   35 ++
>  drivers/phy/Makefile                               |    5 +
>  drivers/phy/phy-core.c                             |   43 ++-
>  drivers/phy/phy-exynos4210-usb2.c                  |  264 ++++++++++++++
>  drivers/phy/phy-exynos4212-usb2.c                  |  312 +++++++++++++++++
>  drivers/phy/phy-exynos5250-usb2.c                  |  363 ++++++++++++++++++++
>  drivers/phy/phy-s5pv210-usb2.c                     |  206 +++++++++++
>  drivers/phy/phy-samsung-usb2.c                     |  240 +++++++++++++
>  drivers/phy/phy-samsung-usb2.h                     |   74 ++++
>  drivers/usb/gadget/s3c-hsotg.c                     |   11 +-
>  drivers/usb/host/ehci-exynos.c                     |   95 +++--
>  include/linux/phy/phy.h                            |    3 +
>  20 files changed, 1789 insertions(+), 57 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>  create mode 100644 drivers/phy/phy-exynos4210-usb2.c
>  create mode 100644 drivers/phy/phy-exynos4212-usb2.c
>  create mode 100644 drivers/phy/phy-exynos5250-usb2.c
>  create mode 100644 drivers/phy/phy-s5pv210-usb2.c
>  create mode 100644 drivers/phy/phy-samsung-usb2.c
>  create mode 100644 drivers/phy/phy-samsung-usb2.h
> 

