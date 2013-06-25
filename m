Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab3FYFD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:03:27 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52168 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3FYFDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:03:14 -0400
X-AuditID: cbfee68f-b7f436d000000f81-68-51c924916375
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: anton.vorontsov@linaro.org
Cc: linux-kernel@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/2] power: charger-manager: Fix a bug when it unregisters
 notifier block of extcon.
Date: Tue, 25 Jun 2013 14:02:49 +0900
Message-id: <1372136569-551-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWyRsSkRHeiyslAg2MtohYXW2+zWHSefcJs
	cXnXHDaL240r2BxYPO5c28Pm0bdlFaPH501yAcxRXDYpqTmZZalF+nYJXBlzZ35mKrjJVfH2
	8WLGBsZ/HF2MHBwSAiYSm9truhg5gUwxiQv31rN1MXJxCAksZZR4t6WVHSJhInFz13omiMQi
	Rom/nx+wQDgtTBJTfn1nBqliE9CR+L/vJliHiICcxOu1f5lAbGaBYonP1xazgtjCAmkSHxcd
	AouzCKhK/F2xCayeV8BNYtVMkNUgFylIzJlkAxLmFHCXuHH7PQuILQRU8nDqQqiDvrNJ7Nte
	ADFGQOLb5EMsEK2yEpsOMEOUSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5
	uZsYgQF7+t+z/h2Mdw9YH2JMBho3kVlKNDkfGPB5JfGGxmZGFqYmpsZG5pZmpAkrifOqtVgH
	CgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBkvTD/If8+58s73RyeSWx8Gua/N3fVZ/WUgn16
	Nds8b7hWyV6etEg9yW33rJ7kV3+4X+x7+bZ90cenb1a23A/z+2hwQnz2Tkm2Vttl3jerTtvL
	X5jZc45z61kDtc4r1fk1595uOTmtlIHd/swywa+G/73WZ3J3i8Z9US/5y31k652vKewvWEJf
	KbEUZyQaajEXFScCAC/gCfduAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd2JKicDDV5e4LO42HqbxaLz7BNm
	i8u75rBZ3G5cwebA4nHn2h42j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMmDvzM1PBTa6Kt48XMzYw/uPoYuTkkBAwkbi5az0ThC0mceHeerYuRi4O
	IYFFjBJ/Pz9ggXBamCSm/PrODFLFJqAj8X/fTXYQW0RATuL12r9g3cwCxRKfry1mBbGFBdIk
	Pi46BBZnEVCV+LtiE1g9r4CbxKqZIBs4gLYpSMyZZAMS5hRwl7hx+z0LiC0EVPJw6kL2CYy8
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx8Qz6R2MqxosDjEKcDAq8fB+iDsRKMSa
	WFZcmXuIUYKDWUmEN1QEKMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wHjNK4k3NDYxM7I0
	Mje0MDI2J01YSZz3YKt1oJBAemJJanZqakFqEcwWJg5OqQZGk2DD7rv1Z78fYjZo9+iwWeV1
	jWXHP2EWP44AE/nQkp8sDdNmy3eFtlzM2fgt+VXgFb/6Xuk7sxuDj868Oflo+A7r+zxeOw5t
	WX5p6xGvn/xrvqo3bn4vZbY7PuEVq+Od6+YM/y8pe6n+lQ/e+JT9U7D4Ks2vdYZbe95sros6
	NXOfy/S1n34kKbEUZyQaajEXFScCANsFhV/NAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents NULL pointer error cauesed by unregistering unregistered
exton notifier block. At the probing time of charger manager, it tries to
remove extcon notifier block when it fails to initialize them. It has to be
applied for only registered one. Otherwise, it'd make kernel panic. To make it
work right, it checks extcon_specific_cable_nb's extcon_dev node. If extcon
cable notifier block was registered successfully, it has proper extcon_dev
pointer if not so it has NULL pointer.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/charger-manager.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 7d1bcde..c55a7dc 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1666,7 +1666,9 @@ err_reg_extcon:
 		charger = &desc->charger_regulators[i];
 		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
-			extcon_unregister_interest(&cable->extcon_dev);
+			/* Remove notifier block if only edev exists */
+			if (cable->extcon_dev.edev)
+				extcon_unregister_interest(&cable->extcon_dev);
 		}
 
 		regulator_put(desc->charger_regulators[i].consumer);
-- 
1.7.9.5

