Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaJPHdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:33:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58025 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaJPHde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:33:34 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e7-543f74cbae24
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/8] power_supply: Add API for safe access of
 get_property-like function attrs
Date: Thu, 16 Oct 2014 09:32:49 +0200
Message-id: <1413444777-24107-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xy7qnS+xDDN7OV7M4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4MvZeXMVa8FKo
	YtfiTcwNjK38XYwcHBICJhIfXst0MXICmWISF+6tZ+ti5OIQEljKKNE0+SEThNPHJNG16Tgr
	SBWbgLHE5uVLwKpEBK4zSXSumMAC4jALNDJLvGtoZgIZKyyQLHHqegVIA4uAqsThVz1sIGFe
	AXeJ/V84IbbJSZw8Npl1AiP3AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghAfx1B+PS
	Y1aHGAU4GJV4eDWC7UOEWBPLiitzDzFKcDArifA2FwKFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MG77OTm5IEnYubJkhzrrE8mlb2rfv6hZW5pe8HOPXfHDXMPHV4Trxc3igs4FPxCwXr1I4Vjd
	DRazoA+HprKrTGGcF3ldXiuNTUfA16K5Zvtnvhx59ZVisyb92TBrneNMSxl/119MNxcwtyu/
	zMlpVpuafHTGMbsp7dLslw7dK42aEDZd9XNkuhJLcUaioRZzUXEiAClfWNQ+AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v1:
=================
1. Remove checks for non-NULL in added functions (suggested by
   Pavel Machek).
2. Fix typos in commit messages.
3. Add acks: Pavel Machek, Jonghwa Lee, Lee Jones (only 5/8).


Description:
============
After fixing issue with referencing old power supply after driver
unbind in charger manager [1] I noticed that the race condition in such
case may still exist. It would be harder to trigger but still possible.

The race is between using a reference to power supply (obtained
with power_supply_get_by_name()) and removing the driver.

This patchset aims to fix the race by introducing wrappers for
accessing the power supply function attributes.

Patch 1 introduces new API. Other patches replace direct calls in
drivers.

Rebased on next-20141007.
Tested on Trats2 board (max77693 + charger manager).


Kindly asking for reviewing/testing the drivers, although the changes
are straightforward.


Best regards,
Krzysztof


[1] https://lkml.org/lkml/2014/10/13/272


Krzysztof Kozlowski (8):
  power_supply: Add API for safe access of power supply function attrs
  power_supply: sysfs: Use power_supply_*() API for accessing function
    attrs
  power: 88pm860x_charger: Use power_supply_*() API for accessing
    function attrs
  power: ab8500: Use power_supply_*() API for accessing function attrs
  mfd: ab8500: Use power_supply_*() API for accessing function attrs
  power: apm_power: Use power_supply_*() API for accessing function
    attrs
  power: bq2415x_charger: Use power_supply_*() API for accessing
    function attrs
  power: charger-manager: Use power_supply_*() API for accessing
    function attrs

 drivers/mfd/ab8500-sysctrl.c       |  7 +++--
 drivers/power/88pm860x_charger.c   | 13 +++++----
 drivers/power/ab8500_btemp.c       |  2 +-
 drivers/power/ab8500_charger.c     |  2 +-
 drivers/power/ab8500_fg.c          |  2 +-
 drivers/power/abx500_chargalg.c    |  4 +--
 drivers/power/apm_power.c          |  4 +--
 drivers/power/bq2415x_charger.c    |  3 +-
 drivers/power/charger-manager.c    | 37 +++++++++++++------------
 drivers/power/power_supply_core.c  | 57 ++++++++++++++++++++++++++++++++++++--
 drivers/power/power_supply_sysfs.c |  6 ++--
 include/linux/power_supply.h       | 16 +++++++++++
 12 files changed, 115 insertions(+), 38 deletions(-)

-- 
1.9.1

