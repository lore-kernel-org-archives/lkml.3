Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3JYOPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 10:15:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22502 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab3JYOPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 10:15:52 -0400
Date: Fri, 25 Oct 2013 16:15:24 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 0/5] phy: Add new Exynos USB PHY driver
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        Kamil Debski <k.debski@samsung.com>
Message-id: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-AuditID: cbfee61a-b7f836d0000025d7-89-526a7d16952a
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jQV2x2qwgg08dUhbzj5xjtWi7cpDd
	4sfrC2wWF572sFmcbXrDbjFt539Wi8u75rBZzDi/j8li0bJWZou1R+6yW5ztv81mcfhNO6vF
	+hmvWRx4PXbOusvu0bdlFaPH8RvbmTw+b5ILYInisklJzcksSy3St0vgyujccoCtoFG84uGy
	2SwNjCsFuxg5OCQETCSaJpd0MXICmWISF+6tZ+ti5OIQEpjOKLH4wGtmCKeDSeLzlP+sIA1s
	ApoSq+55gDSICMxklNi82BTEZhY4yyjRctsXxBYWMJf4ePotM4jNIqAqseP1MjYQm1fAReJF
	x392iL0KEnMm2Uxg5F7AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIziknkntYFzZYHGI
	UYCDUYmHN2FGZpAQa2JZcWXuIUYJDmYlEd6e8qwgId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwH
	Wq0DhQTSE0tSs1NTC1KLYLJMHJxSDYzhPc71h0SrfistbxdilbwTlJJrVOYRVXJZ+2Hmu/us
	MzJOKps6zF3/WcnTu855b2zjhtj+6K0Vs8uf7jd4LLVQPuXollWcpoYHDLcp27IFzH/xrNSj
	e0Lvu+AEroqIqyyXPs6MenpkV8Cm5YU9HpPezNldHbntxLW0ZW6btLO/z64zeHR75yslluKM
	REMt5qLiRABWaeCxJQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second version of the patch adding support for USB PHY module
of the Exynos series of SoCs by Samsung. The driver is utilising the newly
added Generic PHY Framework by Kishon Vijay Abraham I [1].

In addition to the PHY driver this patchset contains:
- work in progress support for Exynos 5250
  (based on the drivers/usb/phy/phy-samsung-usb2.c driver)
- support for S5PV210 added by Mateusz Krawczuk during his summer internship at
  Samsung
- change to the ehci-s5p driver which modifies the driver to use the General
  PHY Framework
- change to the s3c-hsotg driver which modifies the driver to use the General
  PHY Framework

Best wishes,
Kamil Debski
----------------
Changes from v1:
- the changes include minor fixes of the hardware initialization of the PHY
  module
- some other minor fixes were introduced

----------------------
Original cover letter:

Hi,

This patch adds a new drive for USB PHYs for Samsung SoCs. The driver is using
the Generic PHY Framework created by Kishon Vijay Abrahan I. It can be found
here https://lkml.org/lkml/2013/8/21/29. This patch adds support to Exynos4
family of SoCs. Support for Exynos3 and Exynos5 is planned to be added in the
near future.

I welcome your comments.

----------------------

[1] https://lkml.org/lkml/2013/8/21/29

Kamil Debski (4):
  phy: Add new Exynos USB PHY driver
  phy: Add WIP Exynos 5250 support to the Exynos USB PHY driver
  usb: ehci-s5p: Change to use phy provided by the generic phy
    framework
  usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic
    phy framework

Mateusz Krawczuk (1):
  phy: Add support for S5PV210 to the Exynos USB PHY driver

 .../devicetree/bindings/phy/samsung-usbphy.txt     |   51 +++
 drivers/phy/Kconfig                                |   35 ++
 drivers/phy/Makefile                               |    4 +
 drivers/phy/phy-exynos-usb.c                       |  265 +++++++++++++
 drivers/phy/phy-exynos-usb.h                       |   96 +++++
 drivers/phy/phy-exynos4210-usb.c                   |  295 ++++++++++++++
 drivers/phy/phy-exynos4212-usb.c                   |  343 ++++++++++++++++
 drivers/phy/phy-exynos5250-usb.c                   |  411 ++++++++++++++++++++
 drivers/phy/phy-s5pv210-usb.c                      |  236 +++++++++++
 drivers/usb/gadget/s3c-hsotg.c                     |   13 +-
 drivers/usb/host/ehci-s5p.c                        |   21 +-
 11 files changed, 1755 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
 create mode 100644 drivers/phy/phy-exynos-usb.c
 create mode 100644 drivers/phy/phy-exynos-usb.h
 create mode 100644 drivers/phy/phy-exynos4210-usb.c
 create mode 100644 drivers/phy/phy-exynos4212-usb.c
 create mode 100644 drivers/phy/phy-exynos5250-usb.c
 create mode 100644 drivers/phy/phy-s5pv210-usb.c

-- 
1.7.9.5

