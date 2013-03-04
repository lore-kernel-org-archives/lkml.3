Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3CDIFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:05:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14459 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab3CDIFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:05:35 -0500
X-AuditID: cbfee690-b7f6b6d000004563-b9-513455ce1ca7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 20/24] rtc: rtc-sh: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:05:34 +0900
Message-id: <014d01ce18af$0c473620$24d5a260$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAARlVA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA91zoSaBBhNW6VssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0TF5MmvBJfaKSxstGxiPs3UxcnJICJhI/F/+kQnCFpO4cG89UJyLQ0hgGaPEjf23
	gRwOsKLWeXUQ8emMEkv2/GaHcH4xSmyZ/Y0ZpJtNQE3iy5fD7CANIgL6Em0tGiA1zAK9jBJn
	enezg9QICdhKfHn4AGwbp4CdxP1zq1hBbGEBN4lvp8+DxVkEVCXOHGoAu44XqH7+0f/MELag
	xI/J91hAbGYBLYn1O48zQdjyEpvXvGWGOFRd4tFfXZCwiICRxKt5y9kgSkQk9r14xwhyj4TA
	PXaJK339rBC7BCS+TT7EAtErK7HpADMkICQlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y0StOzC0uzUvXS87P3cQIidMJOxjvHbA+xJgMtH4is5Rocj4wzvNK4g2NjU3M
	TExNzC1NzU1JE1YS55W/JBMoJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVEju56x3XGWacM1
	tcpzZ9MunDU5aPzM5ej8t88XF9TOcb/7NC/8bIvQh4L/uS/UYsTj7Fg2n5r048iH6xqXHu3d
	IZJjLW/65XFt23Sm74eXZ58/tpy/387Jc2Oz2/TttZ4rHizZ4h3AeLy5r8mg9v9vrsO/Zkg/
	eL7pj4HxKnWu+Lw6w80/1TKUWIozEg21mIuKEwHKTGSV6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1zoSaBBg092hZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZnRMnsxacIm94tJGywbG42xdjBwcEgImEq3z
	6roYOYFMMYkL99YDhbk4hASmM0os2fObHcL5xSixZfY3ZpAqNgE1iS9fDrODNIsI6Eu0tWiA
	1DAL9DJKnOndzQ5SIyRgK/Hl4QMmEJtTwE7i/rlVrCC2sICbxLfT58HiLAKqEmcONbCB2LxA
	9fOP/meGsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPE0eoSj/7qgoRFBIwkXs1bzgZRIiKx
	78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4CTyT
	3sG4qsHiEKMAB6MSD6/AJ+NAIdbEsuLK3EOMEhzMSiK8ZRImgUK8KYmVValF+fFFpTmpxYcY
	k4EencgsJZqcD0xQeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5YkpqdmlqQWgSzhYmD
	U6qB0S9366Msb9f8nz/1AnasY5qebiNfzbUp9lbjhq9/T6++5eEoKFDAuuaUJGOf9ZaNH/jm
	fbgmbb+cseK06uHyDcyFraVrsxiOzflVNN9UvaadUze0a8oplhXNKw+ovV2e0laVtfOb6iQn
	16cih1Y8uPjUvvAfw8qpR6d2z4xb8XYOm9h0+efl55VYijMSDbWYi4oTAenvRJ9GAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sh.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index e55a763..5f47085 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -820,18 +820,7 @@ static struct platform_driver sh_rtc_platform_driver = {
 	.remove		= __exit_p(sh_rtc_remove),
 };
 
-static int __init sh_rtc_init(void)
-{
-	return platform_driver_probe(&sh_rtc_platform_driver, sh_rtc_probe);
-}
-
-static void __exit sh_rtc_exit(void)
-{
-	platform_driver_unregister(&sh_rtc_platform_driver);
-}
-
-module_init(sh_rtc_init);
-module_exit(sh_rtc_exit);
+module_platform_driver_probe(sh_rtc_platform_driver, sh_rtc_probe);
 
 MODULE_DESCRIPTION("SuperH on-chip RTC driver");
 MODULE_VERSION(DRV_VERSION);
-- 
1.7.2.5


