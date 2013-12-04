Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3LDKJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:09:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59778 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3LDKJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:09:47 -0500
X-AuditID: cbfee690-b7f676d00000310d-c5-529eff691d3a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, kishon@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, t.figa@samsung.com, jwerner@chromium.org,
        k.debski@samsung.com
Subject: [PATCH v2 0/4] Add Exynos5 USB 3.0 phy driver based on generic PHY
 framework
Date: Wed, 04 Dec 2013 15:39:03 +0530
Message-id: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSq5v5f16QwaLnMhYH79dbHJj9kNWi
	efF6NovLCy+xWnQcesxk8eP1BTaL3gVX2SwuPO1hs1jYtoTF4vKuOWwWM87vY7JYtKyV2eLw
	igNMFofftLNarJ/xmsWB32PB5yvsHrMbLrJ47J+7ht3j/IyFjB59W1Yxehy/sZ3J4/MmuQD2
	KC6blNSczLLUIn27BK6MY38PsBQskq149OQ3SwPjWbEuRk4OCQETiXWLtrBC2GISF+6tZ+ti
	5OIQEljKKDFr4R+WLkYOsKKpBx0g4tMZJSa1L2SCcKYwSXzecZkZpJtNQFei6e0uRhBbRCBd
	4v/dfjCbWWAmk8SUzZIgtrBAuMSyZ7/AtrEIqEq8PfmJDWQBr4C7RGdLNsQRChJvbj9jBpkv
	IXCOXWLrow3MEPUCEt8mH4I6SFZi0wFmiHpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchErzgx
	t7g0L10vOT93EyMwLk7/ezZhB+O9A9aHGJOBxk1klhJNzgfGVV5JvKGxmZGFqYmpsZG5pRlp
	wkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPoc+y2zOTjjk+m93R8lt9beCqw7
	v2iC1A6RT677Zq/QKpf0iMivazKLeeo4R2zDtuWzf4anzLrsn350sV/g0pjK/cc3rJZYITPf
	KlC7ZrPDchH1Pl/nluico7ltaRHVl08cXvH//u+d7v82Tjk2ZcJ902UMOecPnN/7g3/RlkU2
	+ceFLQ/Ku+9VYinOSDTUYi4qTgQAY0+/tqECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jQd3M//OCDDacFLI4eL/e4sDsh6wW
	zYvXs1lcXniJ1aLj0GMmix+vL7BZ9C64ymZx4WkPm8XCtiUsFpd3zWGzmHF+H5PFomWtzBaH
	Vxxgsjj8pp3VYv2M1ywO/B4LPl9h95jdcJHFY//cNewe52csZPTo27KK0eP4je1MHp83yQWw
	RzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHa6k
	UJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzDj29wBLwSLZikdPfrM0MJ4V
	62Lk4JAQMJGYetChi5ETyBSTuHBvPVsXIxeHkMB0RolJ7QuZIJwpTBKfd1xmBqliE9CVaHq7
	ixHEFhFIl/h/tx/MZhaYySQxZbMkiC0sEC6x7NkvVhCbRUBV4u3JT2wgy3gF3CU6W7IhlilI
	vLn9jHkCI/cCRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFR90x6B+OqBotDjAIcjEo8
	vAmc84KEWBPLiitzDzFKcDArifBm/gEK8aYkVlalFuXHF5XmpBYfYkwGWj6RWUo0OR+YEPJK
	4g2NTcxNjU0tTSxMzCxJE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgbHJqLZGgXdhQPjz
	7F+3bW+Ia10K/bw5c7YKs5DlrMVP5WZt9nn3YFr3nbqnZVpSx5j3Xze83qEhNsNHZE2KRPme
	pwJKp14r1a3Ln2X+RdlpwzzehEnq/Gr7f8db37m26sOTTYylot916lK+VN6VeHe103nThPLj
	LUl/+WcIHK3z8nfRKWM2O6bEUpyRaKjFXFScCABLdEGW/gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a phy driver for USB 3.0 PHY controller present on Exynos5
series of SoCs alongwith DWC3 controller for USB 3.0 operations.

Few functions used in this driver to translate ref clock rate are
common to Kamil's usb2.0 phy driver [1]. So we can figure out how
to re-use them across these drivers.

Theses patches are based on usb-next branch and tested with
Kishon's patches for adapting DWC3 to generic phy framework, [2]
on smdk5250 as well as smdk5420 board.

[1] [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
    https://lkml.org/lkml/2013/11/5/272
[2] [PATCH v2 1/7] usb: dwc3: get "usb_phy" only if the platform indicates the presence of PHY's
    (http://www.spinics.net/lists/linux-usb/msg95733.html)
    [PATCH v2 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY Framework
    (http://www.spinics.net/lists/linux-usb/msg95734.html)

Changed from RFC patch-set:
1) fixes in documentation file
 - added provision for syscon interface for using PMU register.
 - added clock names and description
 - modified description style for 'compatible property'
 - made usb30_sclk as additional clock rather then making it optional, since
   it is actually an additional clock for Exynos5420 Soc.
2) fixes in phy-exynos5-usb3 driver file
 - removed unnecessary #ifndef around KHZ and MHZ definitions
 - removed 'samsung_cpu_type', 'usb3phy_state' enums; and merged necessary
   necessary from 'usb3phy_instance' structure to 'usb3phy_driver'.
 - changed name 'sclk_usbphy30' to 'usb30_sclk_100m' since this is the name
   indicated as input to the PHY block; and also added (!IS_ERR()) check for
   using usb30_sclk.
 - removed unnecessary 'state' check code.
 - moved 'of_device_id' structure definitions before 'probe()' to avoid
   unnecessary declaration.
 - added (pdev->dev.of_node == NULL) check at the starting of probe()
 - moved 'devm_of_phy_provider_register()' call to end of the probe().
 - removed 'label' for usb3drd phy.
 - corrected macros definition 'PHYCLKRST_MPLL_MULTIPLIER_50M_REF' from
   0x02 to 0x32 after confirming same from PHY's data sheet.
 - replaced pmu register handling, used for power-isolation, with syscon
   interface api's.
 - added '.init' and '.exit' callbacks and using them for one time
   PHY-initialization and deinitialization.
 - Filtering out the PHY 'power-on' and 'power-off' sequence to '.power_on"
   and ".power_off" callbacks.
 - Removed drivers/usb/phy/phy-samsung-usb3.c driver and related code.
3) fixes in dt files
 - added reference for 'samsung,syscon-phandle' to used for PMU register.
 - removed second register field which was earlier used for PMU.

Vivek Gautam (4):
  phy: Add new Exynos5 USB 3.0 PHY driver
  dt: exynos5250: Enable support for generic USB 3.0 phy
  dt: exynos5420: Enable support for USB 3.0 PHY controller
  dt: exynos5420: Enable support for DWC3 controller

 .../devicetree/bindings/phy/samsung-phy.txt        |   43 ++
 arch/arm/boot/dts/exynos5250.dtsi                  |   16 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |   54 ++
 drivers/phy/Kconfig                                |    8 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5-usb3.c                     |  545 ++++++++++++++++++++
 drivers/usb/phy/Kconfig                            |   10 +-
 drivers/usb/phy/Makefile                           |    1 -
 drivers/usb/phy/phy-samsung-usb.h                  |   80 ---
 drivers/usb/phy/phy-samsung-usb3.c                 |  350 -------------
 10 files changed, 658 insertions(+), 450 deletions(-)
 create mode 100644 drivers/phy/phy-exynos5-usb3.c
 delete mode 100644 drivers/usb/phy/phy-samsung-usb3.c

-- 
1.7.6.5

