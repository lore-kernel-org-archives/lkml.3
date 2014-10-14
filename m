Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaJNMh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:37:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12330 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbaJNMhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:37:20 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-fe-543d18fe3950
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
Subject: [PATCH 7/7] mfd: ab8500: Decrement the power supply's device reference
 counter
Date: Tue, 14 Oct 2014 14:35:17 +0200
Message-id: <1413290117-13082-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t/xK7r/JGxDDE41cFsc3KppsXHGelaL
	JU0ZFpOevGe2mLhyMrPFtI3iFq9fGFosW/yU0eJs0xt2i/tfjzJaTPmznMli0+NrrBaXd81h
	s/jce4TR4uPSDawWa4/cZbe4dGABk8XdU0fZLB6veMtucbqb1eL07hKLzZumMlv82PCY1UHc
	Y0L/J0aPnbPusnss2FTqsXmFlsfiPS+ZPDat6mTzuHNtD5vHu3Pn2D3mnQz02Lyk3uPj01ss
	Hu/3XWXz6NuyitFjxerv7B6fN8l5nGj5whogEMVlk5Kak1mWWqRvl8CVcfHvX+aC9WwVs+fP
	Y21gnMraxcjJISFgIvHw+zF2CFtM4sK99WxdjFwcQgJLGSX+7l7GBOH0MUk8/fiQDaSKTcBY
	YvPyJWBVIgKbWCW2rVgAVsUscJ1RYvXV22CzhAUiJZpO72QBsVkEVCX27HzMBGLzCrhLzJ59
	mhFin5zEyWOTge7g4OAU8JCYuEsNxBQCKpn1THYCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGCER9WUH4+JjVocYBTgYlXh4CyJtQoRYE8uKK3MPMUpwMCuJ8Cpw2IYI8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYGzu/lb0/svf/MD5BeXfL3Z9uXn06s/l30Uk13Rw5v9RMn644U3G
	KhEe4+Q4CfFoSyP5c5LWGUFlDLdnOwQyfthqULsoVuzvx4z8q0LNDzbrye1z6LNm8l3wTslx
	/5Hw/R/9WSdG84kx2Uj/rMjcZCbl1zYh6sSKw4w39Ar1bnJXdapM5Fe5p8RSnJFoqMVcVJwI
	AN7PCxmGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use power_supply_put() to decrement the power supply's device reference
counter.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/ab8500-sysctrl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-sysctrl.c b/drivers/mfd/ab8500-sysctrl.c
index 93b2d2c32ca3..d05a5719cfc4 100644
--- a/drivers/mfd/ab8500-sysctrl.c
+++ b/drivers/mfd/ab8500-sysctrl.c
@@ -51,6 +51,7 @@ static void ab8500_power_off(void)
 
 		ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_ONLINE,
 				&val);
+		power_supply_put(psy);
 
 		if (!ret && val.intval) {
 			charger_present = true;
@@ -73,6 +74,7 @@ static void ab8500_power_off(void)
 			       pss[i]);
 			machine_restart("charging");
 		}
+		power_supply_put(psy);
 	}
 
 shutdown:
-- 
1.9.1

