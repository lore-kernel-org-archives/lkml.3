Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaF3O02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaF3O01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:26:27 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: [PATCH resend v2 0/3]  mfd-core: Don't register supplies from add_device, add register_supply_aliases()
Date: Mon, 30 Jun 2014 16:26:06 +0200
Message-Id: <1404138369-23907-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I already send this series before (in time for 3.16) and AFAIK we agreed
on going with this series instead of the incomplete fix for the related oops
which now has been merged as commit d137be00ee017bc40e6027cb66d667a2e0b450fd

I still believe that this series is the more correct fix, as platform
devices must simply not be used at all before they have been added.

This series changes the probe messages for the axp209 pmic regulators from:

[    1.386371] Adding alias for supply acin,(null) -> acin,0-0034
[    1.392205] Adding alias for supply vin2,(null) -> vin2,0-0034
[    1.398112] Adding alias for supply vin3,(null) -> vin3,0-0034
[    1.403995] Adding alias for supply ldo24in,(null) -> ldo24in,0-0034
[    1.410344] Adding alias for supply ldo3in,(null) -> ldo3in,0-0034
[    1.416551] Adding alias for supply ldo5in,(null) -> ldo5in,0-0034

To:

[    1.410545] Adding alias for supply acin,axp20x-regulator -> acin,0-0034
[    1.417288] Adding alias for supply vin2,axp20x-regulator -> vin2,0-0034
[    1.424002] Adding alias for supply vin3,axp20x-regulator -> vin3,0-0034
[    1.430695] Adding alias for supply ldo24in,axp20x-regulator -> ldo24in,0-003
4
[    1.437922] Adding alias for supply ldo3in,axp20x-regulator -> ldo3in,0-0034
[    1.444973] Adding alias for supply ldo5in,axp20x-regulator -> ldo5in,0-0034

Notice how all the "(null)" bits are gone.

No need to rush this into 3.16, but I would still like to see this merged
into 3.17 .

Changes since v1:
-Rebased on top of 3.16-rc1 / commit d137be00ee017bc40e6027cb66d667a2e0b450fd

Thanks & Regards,

Hans
