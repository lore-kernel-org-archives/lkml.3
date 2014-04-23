Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbaDWOvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:51:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:12975 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaDWOvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:51:07 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-53-5357d358f9c3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH part2 0/6] charger/mfd: max14577: Part 2 of adding support for
 MAX77836
Date: Wed, 23 Apr 2014 16:50:34 +0200
Message-id: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnluLIzCtJLcpLzFFi42I5/e/4Nd2Iy+HBBl9ec1kc3KppsXHGelaL
	qQ+fsFlMevKe2WLiysnMFq9fGFqcbXrDbnH/61FGi29XOpgsLu+aw2ax9shddovT3awW62e8
	ZnHg9ZjQ/4nRY+esu+wem1doeWxa1cnmcefaHjaPeScDPfq2rGL0+LxJLoAjissmJTUnsyy1
	SN8ugSvjwMSZrAU/pSt6d09mbmDsE+ti5OSQEDCROLfkEyuELSZx4d56NhBbSGApo8SJXp8u
	Ri4gu49JYmvnShaQBJuAscTm5UvYQBIiAt1MEq1rfrKDOMwCvUwSM662go0SFoiUmDJnItgo
	FgFViQNnf7OD2LwC7hKH38yAWicncfLYZNYJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl
	5+duYoQE3pcdjIuPWR1iFOBgVOLhlVgeFizEmlhWXJl7iFGCg1lJhHfJovBgId6UxMqq1KL8
	+KLSnNTiQ4xMHJxSDYxl4VoT/WrsxNfM+lshmCD9T+PRBM15q3S2LzpYuadK6fCaU3KFB2pP
	7jXdWbImWcXO9IZ1ekxb9rmsbuHK/twz847+39UkcmCZuvyJVb9y7S+Y/eX+2P9650FOIemC
	lbdPzln484gP51RX+bh4lfkczhlMLNUPzq9vSJ6YPPFlE/vKSe/sl61XYinOSDTUYi4qTgQA
	8ef6HxoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is second part of patches adding support for MAX77836 device
to the max14577 drivers.

The first part [1] was applied by Lee Jones [2][3] and this patchset *depends*
on it.

This patchset changes the max14577 charger and regulator drivers
and documents Device Tree bindings.

The patches 1 to 3 depends on each other so they should be pulled at once.
Patches 4, 5 and 6 can be applied independently. However still the
smoothest way to apply this would be through one tree after obtaining
necessary acks from maintainers.

I need acks from power (patches: 1, 3, 4) and regulator (patch 5) trees.


Changes since v4 (for this second part only)
============================================
1. Updated Kconfig entries mentioning MAX77836.
2. Added patch 5/6 (regulator: max14577: Implement SUSPEND mode for
   MAX77836 LDO-s)
3. Charger: Require a charger subnode in DTS with charger settings.
   Previously the charger driver didn't use any properties from DTS.
   Now it needs a subnode with settings because it supports different
   devices with different charging characteristics.
4. Rebased on 3.15-rc2.

Changes since v3
================
1. Applied minor fixes (pointed by Lee Jones).
2. Added one ACK (Lee Jones) and Review-by (Tomasz Figa).
3. Patch 14/charger: Minor change in parsing EOC value from DTS.
4. Rebased on next-20140224.

Changes since v2
================
1. Added ACK-s.
2. Applied minor checkpatch fixes (pointed by Lee Jones).
3. Rebased on next-20140217.

Changes since v1
================
1. Added ACK-s, reviews and tested-by tags.
2. Removed applied patches (they were merged to the linux-next tree).
3. Applied comments from review (Lee Jones) to 5/15 (detection of device type)
   and 8/15 (add max77836 support to max14577).
4. Rebased on next tree.
5. Added patch 13 and 14 (pointed by Jenny Tc):
   - regulator/mfd: max14577: Export symbols for calculating charger current
   - charger: max14577: Configure battery-dependent settings from DTS
6. Updated bindings documentation with new charger bindings.


References
==========
[1] http://thread.gmane.org/gmane.linux.kernel/1682503
[2] http://www.spinics.net/lists/kernel/msg1728274.html
[3] https://git.kernel.org/cgit/linux/kernel/git/lee/mfd.git/log/?h=ib-mfd-extcon-3.16

Previous, full v4 patchset can be found here:
http://thread.gmane.org/gmane.linux.kernel/1654267


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (6):
  charger: max14577: Add support for MAX77836 charger
  regulator/mfd: max14577: Export symbols for calculating charger
    current
  charger: max14577: Configure battery-dependent settings from DTS
  power: max17040: Add ID for MAX77836 Fuel Gauge block
  regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
  devicetree: mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++
 drivers/mfd/max14577.c                             | 100 ++++++-
 drivers/power/Kconfig                              |   4 +-
 drivers/power/max14577_charger.c                   | 291 ++++++++++++++++++---
 drivers/power/max17040_battery.c                   |   1 +
 drivers/regulator/max14577.c                       | 139 +++++-----
 include/linux/mfd/max14577-private.h               |  92 +++++--
 include/linux/mfd/max14577.h                       |  31 +++
 8 files changed, 673 insertions(+), 137 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.9.1

