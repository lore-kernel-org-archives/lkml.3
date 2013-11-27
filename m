Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3K0N0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:26:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:55411 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab3K0N0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:26:40 -0500
X-AuditID: cbfee61a-b7f316d000007e34-74-5295f30e0451
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: t.figa@samsung.com, kgene.kim@samsung.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, sylvester.nawrocki@gmail.com, kishon@ti.com,
        kyungmin.park@samsung.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH] phy: Add exynos-phy driver
Date: Wed, 27 Nov 2013 14:26:27 +0100
Message-id: <1385558788-10880-1-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t9jAV2+z1ODDI60y1vMP3KO1eLAnx2M
	Fr0LrrJZXHjaw2ZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLwysOMFnM+7yTyWL9jNcsFvPaX7I6
	8Hgs+HyF3WPnrLvsHneu7WHz2Lyk3qNvyypGj+M3tjN5fN4kF8AexWWTkpqTWZZapG+XwJVx
	66ljQTt/xdOr69gbGGfwdDFyckgImEisu9zOBmGLSVy4tx7I5uIQEljEKPF37kZmCKeLSeLK
	rrlMIFVsQB3HlnxmBEmICLQzStz9/Y8FxGEWuM0osf/jVqAqDg5hAW2JBzdiQRpYBFQldmy9
	C9bMK+AhcXbDV0aIdfIST+/3sU1g5F7AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzjU
	nkntYFzZYHGIUYCDUYmHd8LlKUFCrIllxZW5hxglOJiVRHgzT04NEuJNSaysSi3Kjy8qzUkt
	PsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cDYbxL8PuKe10nWSY835l2dVyL4SmOe
	FHt6jmJ9z6rfJbuZixb3NL9YVbArY0LsbCZWRv6izKvfE6dpFhu/2JLRsm+Lc/HzGZ31tn9U
	2tfd5FrQvWNlYuPC1GOVG9vdWFrFD8m5nM8xWHji6nwvtt/CJzvEY+rDf07U02F7wRFnV7WN
	O629UViJpTgj0VCLuag4EQC5RMJ0MQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,
The Samsung SoCs from Exynos family are enhanced with a bunch of switches
dedicated for IP blocks. Those switches are called PHYs in Exynos
specification. They are usually controlled by a single bit in a single
one-word-long register.

A IP driver has to control such a switch in an abstract manner.  Therefore,
such 'enablers' were implemented as clocks in older versions of Linux kernel.
With the dawn of PHY subsystems, PHYs become a natural way of exporting the
'enabler' functionality to drivers.  However, there is an unexpected
consequence. Some of those 1-bit PHYs were implemented as separate drivers.
This means that one has to create a struct device, struct phy, its phy provider
and 100-150 lines of driver code to basically set one bit.

The DP phy driver is a good example:
https://lkml.org/lkml/2013/7/18/53

And simple-phy RFC (shares only driver code but not other resources):
https://lkml.org/lkml/2013/10/21/313

To avoid waste of resources I propose to create all such 1-bit phys from Exynos
SoC using a single device, driver and phy provider.

This patchset contains a proposed solution.

All comment are welcome.

Hopefully in future the functionality introduced by this patch may be merged
into a larger Power Management Unit (PMU) gluer driver.  On Samsusng SoC , the
PMU part contains a number of register barely linked to power management (like
clock gating, clock dividers, CPU resetting, etc.).  It may be tempting to
create a hybrid driver that export clocks/phys/etc that are controlled by PMU
unit.

Regards,
Tomasz Stanislawski

Tomasz Stanislawski (1):
  phy: Add exynos-phy driver

 drivers/phy/Kconfig      |    5 ++
 drivers/phy/Makefile     |    1 +
 drivers/phy/exynos-phy.c |  152 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 158 insertions(+)
 create mode 100644 drivers/phy/exynos-phy.c

-- 
1.7.9.5

