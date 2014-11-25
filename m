Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaKYM2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:28:37 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:58232 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaKYM2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:28:33 -0500
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: johan@kernel.org, lee.jones@linaro.org, broonie@kernel.org,
        grant.likely@linaro.org, robh@kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: [PATCH v5 0/2] poweroff-source DT property renaming
Date: Tue, 25 Nov 2014 12:28:24 +0000
Message-Id: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this serie is to rename the property "poweroff-source" to
"system-power-controller". After discussions, it makes more sense to rename back
to the old established property name. This patches serie reverts
commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").

Changes since v4:
  - Renamed the helper function to of_device_is_system_power_controller
  - Removed changes in tps65910, as this commit will be removed from the mfd tree
  - Updated doc

Changes since v3:
  - Move backward compatibility from of_is_system_power_controller to
    tps65910, as it was only required for this driver.

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
 drivers/regulator/act8865-regulator.c                  |  2 +-
 include/linux/of.h                                     |  6 +++---
 5 files changed, 24 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/power/power-controller.txt
 delete mode 100644 Documentation/devicetree/bindings/power/poweroff.txt

-- 
1.9.1

