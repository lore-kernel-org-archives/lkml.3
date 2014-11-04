Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbaKDPKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:10:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16747 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaKDPKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:47 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-51-5458ec7546bd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 0/7] power_supply: Decrement the device reference
 counter
Date: Tue, 04 Nov 2014 16:10:29 +0100
Message-id: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xy7qlbyJCDDYvULE4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr49CPY0wFh/krXqw/
	w9rAuIuni5GTQ0LARGLSqd/sELaYxIV769m6GLk4hASWMkr0/17HCuH0MUlsP97HBFLFJmAs
	sXn5ErAqEYFGVolzW98wgTjMAh1MErdbdgK1cHAIC4RK7D+XBtLAIqAqcWTeZbAwr4C7xPKf
	fBDb5CROHpvMOoGRewEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkAj5uoNx6TGrQ4wC
	HIxKPLwr4iNChFgTy4orcw8xSnAwK4nwqj8GCvGmJFZWpRblxxeV5qQWH2Jk4uCUamDkOrxC
	63aO27qqebGbBe/xSp+PffXAoitgmtr/7TyBz1xL/+XklgYfkGl5vtS8l9eh/30I/3JHy39t
	85QPns/T3rdOPfG1kFTeWodpb1+ctd788sy5qf2miWb6Rx5IFf9plH7M833FzMyD6o5rtluJ
	FJpOepF7RyEx6ZN82weDSWW5T6/nb5dTYinOSDTUYi4qTgQAS1hmtG4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Resending with some new acks.
Whole patchset should be taken at once (everything depends on patch 1).
Depends on [1].


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


Rebased on next-20141104 + mine [1] patchset.
Tested on Trats2 board (max77693 + charger manager).

Kindly asking for reviewing and testing other drivers.

Best regards,
Krzysztof


[1] power_supply: Add API for safe access of get_property-like function attrs
https://lkml.org/lkml/2014/11/4/527


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

