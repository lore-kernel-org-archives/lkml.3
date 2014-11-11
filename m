Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096AbaKKMFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:05:12 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:49312 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaKKMFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 07:05:06 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 0/3] regulator: max77802: Configure suspend modes
Date: Tue, 11 Nov 2014 13:04:42 +0100
Message-Id: <1415707485-28563-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This series configures the max77802 regulators mode when entering in the
Suspend-to-RAM state. The patches in this series were part of a previous
patch-set that also added initial and suspend mode support for the core.
The previous patch-set was [0] but the feedback was that instead mixing
core changes, bugfixes and new driver features, the series should be split
and core changes posted separately from driver new features.

So this series build on top of the series:

"[PATCH v6 0/5] regulator: of: Add initial and suspend modes support" [1]

and to avoid merge conflicts also depends on Krzysztof's series:

"[PATCH v2 0/3] regulator: max77686/802: Cleanup" [2].

The patch-set is composed of the following patches:

Javier Martinez Canillas (3):
  regulator: max77802: Document binding for regulator operating modes
  regulator: max77802: Fill regulator modes translation callback
  ARM: dts: Configure regulators for suspend on exynos Peach boards

 .../devicetree/bindings/regulator/max77802.txt     | 35 ++++++++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         | 81 ++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts          | 81 ++++++++++++++++++++++
 drivers/regulator/max77802.c                       |  6 ++
 4 files changed, 203 insertions(+)

Patch #1 documents the operating modes that are supported by the regulators
in the Maxim 77802 PMIC.

Patch #2 fills the .of_map_mode callback function that is used to translate
between the device specific modes configured in the Device Tree and the
standard modes used by the regulator core.

Patch #3 configures the regulators in the Exynos Peach boards which use a
max77802 PMIC. This patch should be merged through the linux-samsung tree
but I added to the series since shows how the DT binding is used in a DTS.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/11/3/397
[1]: https://lkml.org/lkml/2014/11/10/325
[2]: https://lkml.org/lkml/2014/11/5/118
