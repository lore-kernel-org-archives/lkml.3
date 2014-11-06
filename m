Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaKFOTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:19:50 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:65168 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaKFOTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:19:44 -0500
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, johan@kernel.org,
        mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: [PATCH v3 0/2] poweroff-source DT property renaming
Date: Thu,  6 Nov 2014 14:23:01 +0000
Message-Id: <1415283784-10885-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this serie is to rename the property "poweroff-source" to
"system-power-controller". After discussions, it makes more sense to rename back
to the old established property name. This patches serie reverts
commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").

Changes since v2:
  - of_is_system_power_controller is inline in of.h and only supports
    backward compatibility with device drivers which used this helper
    (which is tps65910)
  - Quashed all changes into a single patch (except documentation)
  - Add a separated commit to fix typos and mispellings in documentation

Changes since v1:

  - The first patch defines "of_is_system_power_controller" which is compatible
    with both "vendor,system-power-controller" and "system-power-controller"
    properties. Also, It keeps the old helper function of_system_has_poweroff_source
    for source compatibility until everything is renamed (in this way, bisections
    are not broken and change is made "atomically" between each commit)

    Note: the property "poweroff-source" itself is not used in dts files yet.
    Before this patch tps65910 was broken due to missing backward compatibility
    with "vendor,system-power-controller". As the old helper uses the new one,
    it works again.

  - act8865 and tps65910 are ported to the new helper function

  - The last commit removes the olf helper which was only used for source compatibility

Romain Perier (2):
  of: Rename "poweroff-source" property to "system-power-controller"
  dt-bindings: Update documentation for "system-power-controller" and
    fix misspellings

 .../devicetree/bindings/power/power-controller.txt     | 18 ++++++++++++++++++
 Documentation/devicetree/bindings/power/poweroff.txt   | 18 ------------------
 .../bindings/regulator/act8865-regulator.txt           |  4 ++--
 drivers/mfd/tps65910.c                                 |  2 +-
 drivers/regulator/act8865-regulator.c                  |  2 +-
 include/linux/of.h                                     |  8 +++++---
 6 files changed, 27 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power-controller.txt
 delete mode 100644 Documentation/devicetree/bindings/power/poweroff.txt

-- 
1.9.1

