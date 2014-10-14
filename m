Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbaJNMgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:36:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:15557 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbaJNMgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:36:49 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-1d-543d18de412e
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
Subject: [PATCH 0/7] power_supply: Decrement the device reference counter
Date: Tue, 14 Oct 2014 14:35:10 +0200
Message-id: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xK7r3JGxDDFqbVSwObtW02DhjPavF
	kqYMi0lP3jNbTFw5mdli2kZxi9cvDC2WLX7KaHG26Q27xf2vRxktpvxZzmSx6fE1VovLu+aw
	WXzuPcJo8XHpBlaLtUfusltcOrCAyeLuqaNsFo9XvGW3ON3NanF6d4nF5k1TmS1+bHjM6iDu
	MaH/E6PHzll32T0WbCr12LxCy2PxnpdMHptWdbJ53Lm2h83j3blz7B7zTgZ6bF5S7/Hx6S0W
	j/f7rrJ59G1ZxeixYvV3do/Pm+Q8TrR8YQ0QiOKySUnNySxLLdK3S+DK6Lh/jq2gj7fi1NGX
	zA2MJ7i6GDk5JARMJLrPnGGCsMUkLtxbz9bFyMUhJLCUUeLNwS4op49J4tvMp2BVbALGEpuX
	LwFLiAhsYpXYtmIBE4jDLHCdUWL11dvsXYwcHMICnhI353GCNLAIqEpMaNrBDGLzCrhLXD11
	nRVinZzEyWOTWScwci9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERIjX3cwLj1mdYhR
	gINRiYe3INImRIg1say4MvcQowQHs5IIrwKHbYgQb0piZVVqUX58UWlOavEhRiYOTqkGxtsf
	zAJer9jONeOyd3T9U3cz9rtpF8UneE67/PJGpNyPvwsvNp0zW2P17530bn+f7Y2SpunijZyl
	HA58i8r3FK0Us194Wb5/Zdq6XIsdH04sLZQxiO3kFd6WnCrGr9ivHbCl5NPaV9tuHVnXebRe
	eqZMRTvLx51H93l0xDjcS1h64LLSWvWmX0osxRmJhlrMRcWJAJ8f8X1vAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The reference counter of device allocated for power supply was
incremented with each call to power_supply_get_by_name() and
power_supply_get_by_phandle().

Add a symmetric 'put' operation so the device could be released after
final put_device() call during supply unregistering.


Rebased on next-20141007 + mine [1] patchset.
Tested on Trats2 board (max77693 + charger manager).

Kindly asking for reviewing/testing other drivers.

Best regards,
Krzysztof


[1] power_supply: Add API for safe access of get_property-like function attrs
https://lkml.org/lkml/2014/10/14/155


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
 drivers/power/charger-manager.c        | 69 ++++++++++++++++++++++------------
 drivers/power/power_supply_core.c      | 41 ++++++++++++++++++++
 include/linux/power_supply.h           |  1 +
 8 files changed, 108 insertions(+), 30 deletions(-)

-- 
1.9.1

