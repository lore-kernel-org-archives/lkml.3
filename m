Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaGAHCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:02:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54073 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaGAHCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:02:18 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c6-53b25cf71513
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH 0/5] charger/mfd: max14577: Add support for MAX77836
Date: Tue, 01 Jul 2014 09:01:55 +0200
Message-id: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/xq7rfYzYFG9ybYmKxccZ6VoupD5+w
	WUx68p7ZYuLKycwW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaPHtSgeTxeVdc9gs1h65y26x
	9PpFJosJ09eyWLTuPcJucbqb1UHAY828NYwel/t6mTx2zrrL7rFy+Rc2j80rtDw2repk87hz
	bQ+bx7yTgR59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVsW3vG9aCaxIVv/f0sDQwzhXuYuTk
	kBAwkdh55gEbhC0mceHeeiCbi0NIYCmjxPvHK1ghnD4mia6Zh8Cq2ASMJTYvXwJmiwhUSnw7
	fYIFpIhZYBqLxL+7HUwgCWEBb4npt/8DdXNwsAioSnxbxAkS5hVwl3jY/5sJYpucxMljk1kn
	MHIvYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESql92MC4+ZnWIUYCDUYmHt3HFhmAh
	1sSy4srcQ4wSHMxKIrycfpuChXhTEiurUovy44tKc1KLDzEycXBKNTBaz35/P3G7gFHttkVT
	TY/wHmGqsWj4GuGTtXzVKtm0aTqTLz+OkXyR/Xcj3/N1avO4pratr/lc/nzCjd5z+7xYBase
	PNMt8NW2X+XooMPl3iF9XMFr48/Dj9mmaBu7Zx5Z0G7KeTxBU2XZ85m1u3iz3xz6uvjwqmcy
	czpFHUoO5/h0CSx5KsmkxFKckWioxVxUnAgAfIFc+DMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is resend of second part of patches adding support for MAX77836
device to the max14577 drivers. The first part (main MFD, extcon
and regulator drivers) was merged already.

The patches 1, 2 and 3 depends on each other so they should be
pulled at once. Patches 4 and 5 can be applied independently.

This patchset was already reviewed by some of the maintainers in during
previous submissions.

I only need acks from power tree (patches: 1, 3, 4).



Changelog from previous submissions [1][2]:

Changes since v4
================
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
[1] http://thread.gmane.org/gmane.linux.kernel/1689130
[2] http://thread.gmane.org/gmane.linux.kernel/1682503


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (5):
  charger: max14577: Add support for MAX77836 charger
  regulator/mfd: max14577: Export symbols for calculating charger
    current
  charger: max14577: Configure battery-dependent settings from DTS
  power: max17040: Add ID for MAX77836 Fuel Gauge block
  devicetree: mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++
 drivers/mfd/max14577.c                             | 100 ++++++-
 drivers/power/Kconfig                              |   4 +-
 drivers/power/max14577_charger.c                   | 291 ++++++++++++++++++---
 drivers/power/max17040_battery.c                   |   1 +
 drivers/regulator/max14577.c                       |  80 +-----
 include/linux/mfd/max14577-private.h               |  92 +++++--
 include/linux/mfd/max14577.h                       |  31 +++
 8 files changed, 614 insertions(+), 137 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.9.1

