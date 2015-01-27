Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbbA0Lbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 06:31:51 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34633 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbbA0Lak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 06:30:40 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f4-54c7764c5b5f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Artamonow <mad_soft@inbox.ru>, Marek Belisko <marek@goldelico.com>,
        Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
        Darren Hart <dvhart@infradead.org>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [RFT PATCH 3/4] power_supply: ipaq_micro_battery: Fix leaking workqueue
Date: Tue, 27 Jan 2015 12:30:20 +0100
Message-id: <1422358221-13199-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
References: <1422358221-13199-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xK7o+ZcdDDJ6t5LVYcqKbxWLSk/fM
	Fl0LDSwmrpzMbPH6haHF5V1z2Cw+9x5htNjedpTF4t/SLWwWq/e8YLY4vbvEYsHGR4wOPB47
	Z91l91jz/hSzx7Frd1g8Nq/Q8ti0qpPNo2/LKkaPz5vkAtijuGxSUnMyy1KL9O0SuDJal71j
	LzjEVnHz3Gz2BsZLrF2MnBwSAiYSnS19TBC2mMSFe+vZuhi5OIQEljJK/Jn3kgXC6WOSuLtn
	FTNIFZuAscTm5UvAqkQEWpgldi48xQKSYBbwlHj39yF7FyMHh7BAgMSGzU4gYRYBVYkZMxcw
	gti8Au4Sk2fOYYPYJidx8thksCs4BTwkfq3fCzZGCKjmyvTzLBMYeRcwMqxiFE0tTS4oTkrP
	NdIrTswtLs1L10vOz93ECAnKrzsYlx6zOsQowMGoxMObUHI8RIg1say4MvcQowQHs5IIr1cE
	UIg3JbGyKrUoP76oNCe1+BAjEwenVANjXkrMpD9cGUuu5R7POrzw8op5+QFlqqqP2SWnlLNZ
	zqz9u81/xqw6099v3BfFtbVw8G6+KvjYedJjNb0GX4et33df6zz4JKrHxXj1k01OTXk/Eg+a
	zzia0/w32OAT662vp0uVHu5J+uM4/Xxu0/sfOdtsFuRIrvL7n+XKuGR3Gcceb4udrNPllViK
	MxINtZiLihMBX2+GQygCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver allocates singlethread workqueue in probe but it is not destroyed
during removal.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 00a588f9d27f ("power: add driver for battery reading on iPaq h3xxx")
Cc: <stable@vger.kernel.org>
---
 drivers/power/ipaq_micro_battery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/ipaq_micro_battery.c b/drivers/power/ipaq_micro_battery.c
index 9d694605cdb7..698cf1636bb8 100644
--- a/drivers/power/ipaq_micro_battery.c
+++ b/drivers/power/ipaq_micro_battery.c
@@ -251,6 +251,7 @@ static int micro_batt_remove(struct platform_device *pdev)
 	power_supply_unregister(&micro_ac_power);
 	power_supply_unregister(&micro_batt_power);
 	cancel_delayed_work_sync(&mb->update);
+	destroy_workqueue(mb->wq);
 
 	return 0;
 }
-- 
1.9.1

