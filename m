Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaJPHmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:42:21 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18847 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaJPHmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:42:18 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-70-543f76d81c38
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 0/7] power_supply: Decrement the device reference counter
Date: Thu, 16 Oct 2014 09:42:00 +0200
Message-id: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xa7o3yuxDDBpaOS0ObtW02DhjPavF
	kqYMi0lP3jNbTFw5mdli2kZxi9cvDC2WLX7KaHG26Q27xf2vRxktpvxZzmSx6fE1VovLu+aw
	WXzuPcJo8XHpBlaLtUfusltcOrCAyeLuqaNsFo9XvGW3ON3NanF6d4nF5k1TmS1+bHjM6iDu
	MaH/E6PHzll32T0WbCr12LxCy2PxnpdMHptWdbJ53Lm2h83j3blz7B7zTgZ6bF5S7/Hx6S0W
	j/f7rrJ59G1ZxeixYvV3do/Pm+Q8TrR8YQ0QiOKySUnNySxLLdK3S+DKWDJhBnvBTb6K7tYe
	9gbG19xdjJwcEgImEjuf/mKDsMUkLtxbD2RzcQgJLGWU+PZ3KzuE08cksfXTfWaQKjYBY4nN
	y5eAVYkIbGKV2LZiAROIwyxwnVFi9dXb7CBVwgI+EveXt7N0MXJwsAioSly6pwkS5hVwl/iz
	9AY7xDo5iZPHJrNOYORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkRr7uYFx6zOoQ
	owAHoxIPr0awfYgQa2JZcWXuIUYJDmYlEd7mQqAQb0piZVVqUX58UWlOavEhRiYOTqkGxqIF
	/AfW94QvX35Sv9uzbKHMgTK+ssCJr8zt6tantfsq+0V5nmE0SHorFVZl+Oztue3TLU+omkb4
	m3WzHO55W/E/q4U51mvizRfV1TmuQerLX+dJOggqq2d+V1h6yJ+99/kPQemwWcf2PNPOW1f2
	1uJ/2Im3xsr8LAc4efpW6VmaR+hu/B6sxFKckWioxVxUnAgAq2dtPm8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Changes since v1:
=================
1. Remove check for non-NULL in power_supply_put (suggested by
   Pavel Machek).
2. Add Pavel Machek's ack.


Description:
============
The reference counter of device allocated for power supply was
incremented with each call to power_supply_get_by_name() and
power_supply_get_by_phandle().

Add a symmetric 'put' operation so the device could be released after
final put_device() call during supply unregistering.


Rebased on next-20141007 + mine [1] patchset.
Tested on Trats2 board (max77693 + charger manager).

Kindly asking for reviewing and testing other drivers.

Best regards,
Krzysztof


[1] power_supply: Add API for safe access of get_property-like function attrs
http://www.spinics.net/lists/arm-kernel/msg369870.html


Krzysztof Kozlowski (7):
  power_supply: Add power_supply_put for decrementing device reference
    counter
  power: charger-manager: Decrement the power supply's device reference
    counter
  x86/olpc/xo1/sci: Use newly added power_supply_put API
  x86/olpc/xo15/sci: Use newly added power_supply_put API
  power: 88pm860x_charger: Decrement the power supply's device reference
    counter
  power: bq2415x_charger: Decrement the power supply's device reference
    counter
  mfd: ab8500: Decrement the power supply's device reference counter

 arch/x86/platform/olpc/olpc-xo1-sci.c  |  4 +-
 arch/x86/platform/olpc/olpc-xo15-sci.c |  4 +-
 drivers/mfd/ab8500-sysctrl.c           |  2 +
 drivers/power/88pm860x_charger.c       | 11 +++++-
 drivers/power/bq2415x_charger.c        |  6 ++-
 drivers/power/charger-manager.c        | 70 +++++++++++++++++++++++-----------
 drivers/power/power_supply_core.c      | 38 ++++++++++++++++++
 include/linux/power_supply.h           |  1 +
 8 files changed, 106 insertions(+), 30 deletions(-)

-- 
1.9.1

