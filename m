Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaLQDfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 22:35:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:55723 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLQDfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 22:35:15 -0500
X-AuditID: cbfee68f-f791c6d000004834-cb-5490f9f04d64
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-input@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v7 0/3] Add regulator-haptic driver
Date: Wed, 17 Dec 2014 12:35:05 +0900
Message-id: <1418787308-29019-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWyRsSkQPfDzwkhBl/bTCyuf3nOanF40QtG
	ix0NR1gtehdcZbO4+ekbq8XlXXPYLGac38fkwO6xc9Zddo++LasYPT5vkgtgjuKySUnNySxL
	LdK3S+DKuL3pAEvBbZ6K2f+2MjcwfuDsYuTkkBAwkdh3dBELhC0mceHeerYuRi4OIYGljBL7
	pm9igyk63/gNzBYSWMQo8X0eF4TdxiQx4100iM0moC3xff1iVhBbRCBU4vOFWcwgg5gFNjJK
	/Hp0GSwhLGAs8e3ddLBtLAKqEl8aloIN5RXwkNh/8RFQnANomYLEnEk2IL0SAu/ZJGb0fmOG
	qBeQ+Db5EFSNrMSmA8wQt0lKHFxxg2UCo+ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmb
	GIEBevrfs/4djHcPWB9iFOBgVOLhfXF9QogQa2JZcWXuIUZToA0TmaVEk/OBcZBXEm9obGZk
	YWpiamxkbmmmJM67UOpnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGlqo77yPzN0Zo3lUq
	vbkzMbT6iNvG7ZeemDxiXbBQt9DUSmgrg8dNVt+M/ZVJ9frvrnO+i9//0rX/RPKiiHddJmln
	kuXFp2qF2dtYbH81KdVNJPOe0eHWqOlh16fEu8zqDGVt4J3+rtGMQXSquXPerruHjtbetdeM
	aZTLSioQeSkVPctJ21iJpTgj0VCLuag4EQDTPtYmSwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgO6HnxNCDH5d1bG4/uU5q8XhRS8Y
	LXY0HGG16F1wlc3i5qdvrBaXd81hs5hxfh+TA7vHzll32T36tqxi9Pi8SS6AOaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMeP2pgMsBbd5Kmb/28rcwPiBs4uRk0NCwETi
	fOM3NghbTOLCvfVgtpDAIkaJ7/O4IOw2JokZ76JBbDYBbYnv6xezgtgiAqESny/MYu5i5OJg
	FtjIKPHr0WWwhLCAscS3d9NZQGwWAVWJLw1LwYbyCnhI7L/4CCjOAbRMQWLOJJsJjNwLGBlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH/zPpHYyrGiwOMQpwMCrx8L68PiFEiDWxrLgy
	9xCjBAezkgivxSKgEG9KYmVValF+fFFpTmrxIUZToOUTmaVEk/OBsZlXEm9obGJmZGlkbmhh
	ZGyuJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cAY5c20QYln9xWdndPrtLSOC4kpTkhZfKBi
	j/iRzSk16Tn22QfiOXi/nzq+SWhPzZb70zjnpD2XKfrhVPNh7cIYbmX3xYbaj5J72Spfm519
	yGPxPGvPqetheR2HJFVjJ8b8nbDwX6TkdP394eL9kle2OP8t4Hq43XlV3vLXSy5/zxdX0buZ
	5fxTiaU4I9FQi7moOBEAu0x8E5UCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds regulator-haptic driver.
The regulator-haptic has haptic motor and it is controlled by
voltage of regulator via force feedback framework.

Changes in v7:
 - move platform_data or of_node check.
 - prevent to start playing effect when kernel entering suspend state.

Changes in v6:
 - prevent racing condition

Changes in v5:
 - give preference to platform data

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

Jaewon Kim (3):
  Input: add regulator haptic driver
  ARM: dts: exynos3250-rinato: Add regulator-haptic node for haptics
  ARM: dts: exynos3250-monk: Add regulator-haptic node for haptics

 .../devicetree/bindings/input/regulator-haptic.txt |   21 ++
 arch/arm/boot/dts/exynos3250-monk.dts              |    7 +
 arch/arm/boot/dts/exynos3250-rinato.dts            |    7 +
 drivers/input/misc/Kconfig                         |   11 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/regulator-haptic.c              |  247 ++++++++++++++++++++
 include/linux/platform_data/regulator-haptic.h     |   29 +++
 7 files changed, 323 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/regulator-haptic.txt
 create mode 100644 drivers/input/misc/regulator-haptic.c
 create mode 100644 include/linux/platform_data/regulator-haptic.h

-- 
1.7.9.5

