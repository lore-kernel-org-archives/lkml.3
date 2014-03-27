Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417AbaC0L45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:56:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52649 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaC0L44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:56:56 -0400
X-AuditID: cbfee690-b7f266d00000287c-b4-53341206e296
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCH] charger-manager: Fix checking of wrong return type
Date: Thu, 27 Mar 2014 20:56:55 +0900
Message-id: <1395921415-17506-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWyRsSkQJdNyCTY4PUBHYvrX56zWkx68p7Z
	YuLKycwWZ5vesFtc3jWHzeJ24wo2BzaPnbPusntsXqHl0bdlFaPH501yASxRXDYpqTmZZalF
	+nYJXBkvrv5jLljPUXHlu34DYzN7FyMnh4SAicTL5vnMELaYxIV769m6GLk4hASWMko8enOB
	qYuRA6zoe6snRHwRo8SintWMIA1CAo1MEos+c4DYbAJaEvtf3GADsUUEdCVu9lwGW8AsUCux
	71oTK4gtLOAlMfPgJyYQm0VAVeJt+2mwel4BV4md7e/ZII6Qk/iw5xE7yDIJgc9sEqd+32SB
	aBCQ+Db5EAvEQbISmw5AHS0pcXDFDZYJjIILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+du
	YgQG5+l/zybsYLx3wPoQYzLQuInMUqLJ+cDgziuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGRu3Q4Jc10571iZ65vGkbw8kfD+/b3pZQmV+Ys8Jk
	vu+JC84f4mXV6oT3rutMcWbf94TrcOXM+Vcstx4KOv/Rd9kap+O5/0012xtnuv49P9V3+XSz
	vQVTW64X/zJ567rbsEVJ4Z17jNHDzTUcurW6JzWW901XV7N0OpL3PYZVZO1O7mquvwZ5RUos
	xRmJhlrMRcWJAIc05FFkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t9jAV02IZNgg7nvVSyuf3nOajHpyXtm
	i4krJzNbnG16w25xedccNovbjSvYHNg8ds66y+6xeYWWR9+WVYwenzfJBbBENTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmvLj6j7lgPUfFle/6DYzN7F2MHBwSAiYS31s9
	uxg5gUwxiQv31rN1MXJxCAksYpRY1LOaESQhJNDIJLHoMweIzSagJbH/xQ02EFtEQFfiZs9l
	dhCbWaBWYt+1JlYQW1jAS2LmwU9MIDaLgKrE2/bTYPW8Aq4SO9vfs0Esk5P4sOcR+wRG7gWM
	DKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgkP/mfQOxlUNFocYBTgYlXh4d9w3ChZiTSwr
	rsw9xCjBwawkwhvMZxIsxJuSWFmVWpQfX1Sak1p8iDEZaPtEZinR5HxgXOaVxBsam5gZWRqZ
	G1oYGZuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2PI7Cd+V9yuyVfK5XWmMNyZJHH0
	z0zbsBUVXUJWAUKzXXz2sP2ZqKxueG/e2U9HZyX0Hyw+XHLGvtW2t+2g1vm+kppG15XpSi+n
	iruvCzTgPv5xfWFsWPLHqu169+d03PyQEtgXeCqm4sDfPvXtBd5L10bZ3PfJeXn0loDsU4P2
	JMFFQm6T7ZRYijMSDbWYi4oTAU9PUHXBAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix minor issue about checking wrong return type.

The of_cm_parse_desc() return ERR_PTR(errnor number) when some error happen
in this function. But, charger_manager_probe() has only checked whether
desc is NULL or not. If of_cm_parse_desc() returns ERR_PTR(-ENOMEM), desc
isn't NULL but desc is (void *)(-ENOMEM). Althouhg some error happen for parsing
DT, charger_manager_probe() can't detect error of desc instance.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/power/charger-manager.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..a10fb57 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1677,7 +1677,7 @@ static int charger_manager_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (!desc) {
+	if (IS_ERR(desc)) {
 		dev_err(&pdev->dev, "No platform data (desc) found\n");
 		return -ENODEV;
 	}
-- 
1.8.0

