Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaEZHsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:48:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43582 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbaEZHsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:48:10 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-96-5382f1b8bd31
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tomasz Figa <t.figa@samsung.com>,
        devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH 0/5] charger/mfd: max14577: Part 2 of adding support for
 MAX77836
Date: Mon, 26 May 2014 09:47:30 +0200
Message-id: <1401090455-28726-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xy7o7PjYFG2zcyWOxccZ6VoupD5+w
	WUx68p7ZYv6Rc6wWE1dOZrbof7OQ1eLcq5WMFq9fGFqcbXrDbnH/61FGi29XOpgsLu+aw2ax
	9shddoul1y8yWUyYvpbFonXvEXaL092sFutnvGZxEPJYM28No8flvl4mj52z7rJ7rFz+hc1j
	8wotj02rOtk87lzbw+Yx72SgR9+WVYwenzfJBXBFcdmkpOZklqUW6dslcGXs2XOVteCNYsWN
	OVPZGhgfSHUxcnJICJhIdHfuYYawxSQu3FvP1sXIxSEksJRR4sGsJmYIp49JYtHLBlaQKjYB
	Y4nNy5ewgdgiApUS306fYAGxmQWusUiseJYLYgsLREk8WbQOrIZFQFXi3K6VYDavgLvErrcd
	jBDb5CROHpvMOoGRewEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkPD9uoNx6TGrQ4wC
	HIxKPLwv8pqChVgTy4orcw8xSnAwK4nwNn8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamC0nRW7
	dGXisTRBYZ3u9COLV0Qsrf+9uN7nN3tvySQXicsVvs1Tea6sn6hT/VMs65L53oVva+bIOy53
	eOW6m2sR344N2zZsjZy+UPL3bJ3WfQ4vd1e7ZBwX3sJy8U+v6O9Vqu6ytovzCuWC9/z67nn0
	F9eN5B+/D2nI+fE5nNg+P+PcokO770z3V2Ipzkg01GIuKk4EAEeGzgk9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dmitry, David,


This is resend of second part of patches adding support for MAX77836
device to the max14577 drivers.

These patches are hanging on the lists for some time. Could you
look at them and give me acks or any comment what have to be fixed?

It is still before 3.16 merge window so your acks would be appreciated.
If it is possible I would like to push the patches through Lee Jones'
MFD tree (I already have other necessary acks).


I need acks or reviews from power supply subsystem maintainers for
patches:
 - 1/5: charger: max14577: Add support for MAX77836 charger
 - 3/5: charger: max14577: Configure battery-dependent settings from DTS
 - 4/5: power: max17040: Add ID for MAX77836 Fuel Gauge block
These patches were published for the first time around February 2014.

Could you look at them?


Below is original cover letter.


Best regards,
Krzysztof Kozlowski


Cover letter
============

This is second part of patches adding support for MAX77836 device
to the max14577 drivers.

The first part [1] was applied by Lee Jones [2][3] and this patchset
*depends* on it.

This patchset changes the max14577 charger and regulator drivers
and documents Device Tree bindings.

The patches 1 to 3 depends on each other so they should be pulled at once.
Patches 4, 5 and 6 can be applied independently. However still the
smoothest way to apply this would be through one tree after obtaining
necessary acks from maintainers.



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

