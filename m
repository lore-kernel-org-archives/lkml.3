Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab3KEQOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:14:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49745 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab3KEQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:14:17 -0500
Date: Tue, 05 Nov 2013 17:13:18 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH v3 0/3] phy: Add new Exynos USB 2.0 PHY driver
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        Kamil Debski <k.debski@samsung.com>
Message-id: <1383668001-19141-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-AuditID: cbfee61a-b7f836d0000025d7-5f-5279195756b1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsVy+t9jAd1wycoggznXDC2W7L7BajH/yDlW
	i/43C1kt2q4cZLe4vPASq8WP1xfYLC487WGzONv0ht1i2s7/rBaXd81hs5hxfh+TxaJlrcwW
	a4/cZbc423+bzeL8lk4mi8Nv2lkt1s94zWLRcfYgu4OQx+W+XiaPnbPusnv0bVnF6HH8xnYm
	j8+b5AJYo7hsUlJzMstSi/TtErgyXu/4yFbQJ1mx/dFk9gbGTuEuRg4OCQETiaaLHl2MnECm
	mMSFe+vZuhi5OIQEFjFKtM27ygLhdDBJPJmyngWkgU1AU2LVPbAGEYGZjBKbF5uC1DALHGWS
	aH26hREkISxgJ/Gj+zELiM0ioCrxcMYddhCbV8BF4vX+ThaIxQoScybZTGDkXsDIsIpRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjOCCfSe1gXNlgcYhRgINRiYf3wdnyICHWxLLiytxDjBIc
	zEoivMf+VwQJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRq
	YORaGi1Xqpp0oYF50uz+W5KKIicVRHVudPydvqatYrKp9dxvsVr6r9nCLiuesJQrPR+h0Ox4
	bFlUyqTTsVY6ZasD+c07HsUe0iyN6639UZaZfkd51xULMT5W1ifvZp++2Pkj/Lv6AesEwbPx
	Mk+uiqzK8TN+qJVy30/4+cd37Cy7V0sf4eSaq8RSnJFoqMVcVJwIAC34TzxEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the third version of the patchset adding the new Exynos USB 2.0 PHY
driver, which uses the Generic PHY Framework.

It contains numerous fixes and cleanups, which are the results of the feedback
to the second version.

Best wishes,
Kamil Debski

----------------
Changes from v2:
- rebase all patches to the usb-next branch
- fixes in the documentation file
  - remove wrong entries in the phy node (ranges, and #address- & #size-cells)
  - add clocks and clock-names as required properites
  - rephrase a few sentences
- fixes in the ehci-exynos.c file
  - move phy_name variable next to phy in exynos_ehci_hcd
  - remove otg from exynos_ehci_hcd as it was no longer used
  - move devm_phy_get after the Exynos5440 skip_phy check
- fixes in the s3c-hsotg.c file
  - cosmetic fixes (remove empty line that was wrongfully added)
- fixes in the main driver
  - remove cpu_type in favour for a boolean flag matched with the compatible
    value
  - rename files, structures, variables and Kconfig entires - change from simple
    "uphy" to "usb2_phy"
  - fix multiline comments style
  - simplify #ifdefs in of_device_id
  - fix Kconfig description
  - change dev_info to dev_dbg where reasonable
  - cosmetic changes (remove wrongful blank lines)
  - remove unnecessary reference counting

----------------
Changes from v1:
- the changes include minor fixes of the hardware initialization of the PHY
  module
- some other minor fixes were introduced

----------------------
Original cover letter:

Hi,

This patch adds a new drive for USB PHYs for Samsung SoCs. The driver is
using the Generic PHY Framework created by Kishon Vijay Abrahan I. It can
be found here https://lkml.org/lkml/2013/8/21/29. This patch adds support
to Exynos4 family of SoCs. Support for Exynos3 and Exynos5 is planned to
be added in the near future.

I welcome your comments.

----------------------

[1] https://lkml.org/lkml/2013/8/21/29

*** BLURB HERE ***

Kamil Debski (3):
  phy: Add new Exynos USB PHY driver
  usb: ehci-s5p: Change to use phy provided by the generic phy
    framework
  usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic
    phy framework

 .../devicetree/bindings/phy/samsung-usbphy.txt     |   52 ++++
 drivers/phy/Kconfig                                |   23 +-
 drivers/phy/Makefile                               |    4 +
 drivers/phy/phy-exynos-usb2.c                      |  234 ++++++++++++++
 drivers/phy/phy-exynos-usb2.h                      |   87 ++++++
 drivers/phy/phy-exynos4210-usb2.c                  |  272 ++++++++++++++++
 drivers/phy/phy-exynos4212-usb2.c                  |  324 ++++++++++++++++++++
 drivers/usb/gadget/s3c-hsotg.c                     |   12 +-
 drivers/usb/host/ehci-exynos.c                     |   34 +-
 9 files changed, 1013 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
 create mode 100644 drivers/phy/phy-exynos-usb2.c
 create mode 100644 drivers/phy/phy-exynos-usb2.h
 create mode 100644 drivers/phy/phy-exynos4210-usb2.c
 create mode 100644 drivers/phy/phy-exynos4212-usb2.c

-- 
1.7.9.5

