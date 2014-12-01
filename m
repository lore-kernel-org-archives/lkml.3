Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaLACLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 21:11:49 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14134 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaLACLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 21:11:46 -0500
X-AuditID: cbfee68f-f791c6d000004834-bc-547bce60b337
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v4 0/2] Add regulator-haptic driver
Date: Mon, 01 Dec 2014 11:11:11 +0900
Message-id: <1417399873-19575-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWyRsSkSDfhXHWIwZxzshaHF71gtNjRcITV
	onfBVTaLm5++sVpc3jWHzWLG+X1MDmweO2fdZffo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSu
	jDdtnawFLzgrjp5/x9bAeJK9i5GTQ0LAROLMlG8sELaYxIV769lAbCGBpYwSD65xw9RsmbGL
	tYuRCyg+nVHiY+MGqKI2JonVM41AbDYBbYnv6xezgtgiAqESny/MYgZpYBboZJQ4e/UeE0hC
	WMBY4ltTC9hmFgFViV+d/8BsXgEPiQMznwE1cwBtU5CYM8kGpFdC4DWbxPdXN6HqBSS+TT7E
	AlEjK7HpADPEcZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmBYnv73
	rH8H490D1ocYBTgYlXh4JeZXhwixJpYVV+YeYjQF2jCRWUo0OR8Y/Hkl8YbGZkYWpiamxkbm
	lmZK4rwLpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBkeab+/KvTlOAap9lxE2zP1Drx
	xPXsW2z3uGHVetMtRxKM9lUHmaplPD4xQ0fS120754Ue7QaPgLq1jn9lCsqmfZHPfcxbs73S
	2yp1eUoEm6e88x5Lv3v3PNVjmnfPC5OsCNpoqla+PEX5WF9N0PrZTw3rfnotljsXXN4uuc/l
	8UzOhZ9ezlJiKc5INNRiLipOBACwo03SRgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jQd2Ec9UhBrMOiVkcXvSC0WJHwxFW
	i94FV9ksbn76xmpxedccNosZ5/cxObB57Jx1l92jb8sqRo/Pm+QCmKMaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPetHWyFrzgrDh6/h1bA+NJ9i5GTg4JAROJLTN2sULY
	YhIX7q1n62Lk4hASmM4o8bFxAxtIQkigjUli9UwjEJtNQFvi+/rFYA0iAqESny/MYgZpYBbo
	ZJQ4e/UeE0hCWMBY4ltTC9gGFgFViV+d/8BsXgEPiQMznwE1cwBtU5CYM8lmAiP3AkaGVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjBYf9MagfjygaLQ4wCHIxKPLwH51SHCLEmlhVX5h5i
	lOBgVhLhPecBFOJNSaysSi3Kjy8qzUktPsRoCrR8IrOUaHI+MCbzSuINjU3MjCyNzA0tjIzN
	lcR5b9zMDRESSE8sSc1OTS1ILYLpY+LglGpgPHZmx9yjh/YXha+Uz7sQE1K8/HxiqwNHn5xV
	6/tWL2WD1U9enX9dGF4e99tp8uSvnlXnJr6/9CZegfmW/LYva+4eduFUc5n3L3Tnwzec/Z/z
	z12ebNcjO/3u6QjHVhETydP9ZzlPdujmX/B1XbpN6Y5g3r5ZmStazFrau58kM1kf/yX5v+S2
	uBJLcUaioRZzUXEiALbPjr6RAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic driver.
The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Changes in v4:
 - _regulator_get() -> _regulator_get_exclusive()

Changes in v3:
 - fix typo in Documentation
 - add define in header file

Changes in v2:
 - remove driver owner
 - merge enable/disable function
 - support platform data
 - fix wrong suspends_state check in regulator_haptic_resume()


Jaewon Kim (2):
  Input: add regulator haptic driver
  ARM: dts: Add regulator-haptic device node for exynos3250-rinato

 .../devicetree/bindings/input/regulator-haptic.txt |   21 ++
 arch/arm/boot/dts/exynos3250-rinato.dts            |    7 +
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  247 ++++++++++++++++++++
 include/linux/input/regulator-haptic.h             |   31 +++
 6 files changed, 318 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/input/regulator-haptic.h

-- 
1.7.9.5

