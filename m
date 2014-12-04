Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaLDKRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:17:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:36726 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaLDKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:17:18 -0500
X-AuditID: cbfee691-f79b86d000004a5a-74-548034ab46b4
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: lgirdwood@gmail.com, broonie@kernel.org, linux-kernel@vger.kernel.org
Cc: sw0312.kim@samsung.com
Subject: [PATCH] regulator: core: Fix regualtor_ena_gpio_free not to access pin
 after freeing
Date: Thu, 04 Dec 2014 19:17:17 +0900
Message-id: <1417688237-16835-1-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWyRsSkUHeNSUOIwZ27TBZTHz5hs/h2pYPJ
	4vKuOWwWMya/ZHNg8dg56y67x6ZVnWwefVtWMXp83iQXwBLFZZOSmpNZllqkb5fAldG8bylj
	wTHWirN31jA1MO5m6WLk5JAQMJGY09nGCGGLSVy4t56ti5GLQ0hgKaPEi5vd7DBFvdvb2CES
	ixgluts72UASQgJtTBI33ruA2GwCOhL7l/xmBbFFBDwllq/7CNbMLCAlsW3perB6YYF4iVeP
	DoJtZhFQlfh6fSfYZl4BN4k7t59CXaQgseDeWzYI+z6bxMpVgRD1AhLfJh8CquEAistKbDrA
	DFEiKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIEBuPpf88m7mC8f8D6
	EKMAB6MSD2/h7voQIdbEsuLK3EOMpkAbJjJLiSbnA0M+ryTe0NjMyMLUxNTYyNzSTEmcV0f6
	Z7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpniLxpdfz9iSinRvrHo2q9/92XqT6q/+r6H
	W/9zvMf65xovQr6aNJ+UWODR/iyqzDJwykbVBz+2i697kxvF7J/Wco1HK0rh05Es4dD66I3V
	mWtMGk3Ws2XK/rglonJ9yY+zJUk1STu4P+o5sRsv7+G5EzB5un6fm+WJ2fG5PDfmZj8S7rgb
	pMRSnJFoqMVcVJwIAK/WTrZBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jAd3VJg0hBvPPWFhMffiEzeLblQ4m
	i8u75rBZzJj8ks2BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWNG876ljAXHWCvO3lnD1MC4m6WLkZNDQsBEond7GzuELSZx4d56
	ti5GLg4hgUWMEt3tnWwgCSGBNiaJG+9dQGw2AR2J/Ut+s4LYIgKeEsvXfQRrZhaQkti2dD1Y
	vbBAvMSrRwfBFrAIqEp8vb6TEcTmFXCTuHP7KdRiBYkF996yTWDkXsDIsIpRNLUguaA4KT3X
	UK84Mbe4NC9dLzk/dxMjONifSe1gXNlgcYhRgINRiYe3YHd9iBBrYllxZe4hRgkOZiURXsa/
	QCHelMTKqtSi/Pii0pzU4kOMpkDbJzJLiSbnAyMxryTe0NjEzMjSyNzQwsjYXEmc98bN3BAh
	gfTEktTs1NSC1CKYPiYOTqkGRibT42aNE1r5Louc3hikqGwYGf428wD/xglab9U/hOQ4lz0X
	VV1tsqJv0oufdlddHi8RbJfNDxSYeomvxXxyYJJmvU24K9PDqEvHXxWHr/r9Z1LBJZYF8j0v
	LTd4HXlUrBOveZwjKe/atJjzW8sT9s6RXOjyq+N6s8Xsj5w9ie9kF6XVBwsrKbEUZyQaajEX
	FScCAK3kNKqMAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After freeing pin from regulator_ena_gpio_free, loop can access
the pin. So this patch fixes not to access pin after freeing.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/regulator/core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd87c0c..479ef0b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1713,6 +1713,8 @@ static void regulator_ena_gpio_free(struct regulator_dev *rdev)
 				gpiod_put(pin->gpiod);
 				list_del(&pin->list);
 				kfree(pin);
+				rdev->ena_pin = NULL;
+				return;
 			} else {
 				pin->request_count--;
 			}
-- 
1.7.4.1

