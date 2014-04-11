Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaDKMAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:00:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53699 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaDKMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:00:08 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-bc-5347d6bad1f0
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-doc@vger.kernel.org
Cc: t.figa@samsung.com, kyungmin.park@samsung.com, m.szyprowski@samsung.com,
        robh+dt@kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, kgene.kim@samsung.com, rdunlap@infradead.org,
        ben-linux@fluff.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 0/2] Add support for sii9234 chip
Date: Fri, 11 Apr 2014 13:48:28 +0200
Message-id: <1397216910-15904-1-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd1d19yDDZ51KFj8nXSM3WLSugNM
	FvOPnGO1uPL1PZvFgT87GC2aF69ns+hdcJXN4mzTG3aLTY+vsVosbFvCYnF51xw2i54NW1kt
	Zpzfx2Sx9shddou3d6azWLTuPcJusX7GaxaLee0vWR2EPH7/msTo8XfVC2aPzSu0PDat6mTz
	uHNtD5vH/rlr2D3udx9n8ti8pN6jb8sqRo/Pm+QCuKK4bFJSczLLUov07RK4Mhq+P2UuWCdU
	sf7LabYGxh18XYycHBICJhIPHu9hh7DFJC7cW88GYgsJLGKUaLpV2sXIBWR3MUlsfdDJApJg
	A2o4tuQzI0hCROAJo8S6uwfYQRxmgTlMEt/fH2QGqRIWMJSYf3c/I4jNIqAqcXxnKxOIzSvg
	ITH77wJmiHWKEt3PJrBNYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4iJ9J7WBc
	2WBxiFGAg1GJhzfjgluwEGtiWXFl7iFGCQ5mJRHeTVfdg4V4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwSug7XuTunhuRmSy+/vI53/ef0sslFFnjrzQc
	Ndl/0P8u18E/VzV+m53P3vWLQ/I0y6UXyzZ+65PepBr+3snQW+vhxsKkuoU7VqrP7ljQ9/D2
	r8v7pab9WH7rhv/xZ4uVdmkd+frpiLkl077XMxT2ZD1QlTyh98di593IxIlye5h2ivusUjrg
	+liJpTgj0VCLuag4EQAPevrJXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
This patchset adds support for sii9234 HD Mobile Link Bridge.  The chip is used
to convert HDMI signal into MHL.  The driver enables HDMI output on Trats and
Trats2 boards.

The code is based on the driver [1] developed by:
       Adam Hampson <ahampson@sta.samsung.com>
       Erik Gilling <konkers@android.com>
with additional contributions from:
       Shankar Bandal <shankar.b@samsung.com>
       Dharam Kumar <dharam.kr@samsung.com>

The drivers architecture was greatly simplified and transformed into a form
accepted (hopefully) by opensource community.  The main differences from
original code are:
* using single I2C client instead of 4 subclients
* remove all logic non-related to establishing HDMI link
* simplify error handling
* rewrite state machine in interrupt handler
* wakeup and discovery triggered by an extcon event
* integrate with Device Tree

For now, the driver is added to drivers/misc/ directory because it has neigher
userspace nor kernel interface.  The chip is capable of receiving and
processing CEC events, so the driver may export an input device in /dev/ in the
future.  However CEC could be also handled by HDMI driver.

I kindly ask for suggestions about the best location for this driver.

Both the chip and the driver are quite autonomic. The chip works as 'invisible
proxy' for HDMI signal, so there is no need to integrate it with HDMI drivers
by helper-subsystems like v4l2_subdev or drm_bridge.  If the driver is merged
then the driver from drivers/media/platform/s5p-tv/sii9234_drv.c could be safely
removed.

All comments are welcome.

Regards,
Tomasz Stanislawski


References:
[1] https://github.com/junpei0824/SC02C-linux/tree/master-jelly-cm-aokp/drivers/media/video/mhl


Tomasz Stanislawski (2):
  misc: add sii9234 driver
  arm: dts: trats2: add SiI9234 node

 Documentation/devicetree/bindings/sii9234.txt |   22 +
 arch/arm/boot/dts/exynos4412-trats2.dts       |   43 +
 drivers/misc/Kconfig                          |    8 +
 drivers/misc/Makefile                         |    1 +
 drivers/misc/sii9234.c                        | 1081 +++++++++++++++++++++++++
 5 files changed, 1155 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sii9234.txt
 create mode 100644 drivers/misc/sii9234.c

-- 
1.7.9.5

