Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbaCUCbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:31:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59605 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355AbaCUCb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:31:29 -0400
X-AuditID: cbfee68e-b7f566d000002344-f5-532ba47fdcfa
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'open list'" <linux-kernel@vger.kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'Mark Brown'" <broonie@kernel.org>
Subject: [PATCH] regulator: core: Reduce busy-wait looping
Date: Fri, 21 Mar 2014 11:31:25 +0900
Message-id: <000001cf44ad$a8e2f1b0$faa8d510$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9EraW/LnSgkItWTkib83g2xRtXSg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t8zfd36JdrBBp875CymPnzCZvHtSgeT
	xeVdc9gcmD12zrrL7rFpVSebx+dNcgHMUVw2Kak5mWWpRfp2CVwZ73dKFazjrbh5fD5bA+NX
	zi5GDg4JAROJC3PVuxg5gUwxiQv31rOB2EICyxgl9s+KgYibSOyd95Kxi5ELKD6dUeJG40pW
	COcfo8T1k2fYQarYBHQljq3fwgoyVERAT+LkiXiQMLOAj8SejaeZQGxhASuJK3N6mUFsFgFV
	iY/njoC18grYSdxrPMsKYQtK/Jh8jwWiV0ti/c7jTBC2vMTmNW+ZIW5Wl3j0VxckDLLp3qLn
	UOUiEvtevAO7U0JgEbvE/jWH2CB2CUh8m3yIBaJXVmLTAWaIvyQlDq64wTKBUWwWks2zkGye
	hWTzLCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIiaW+HYw3D1gfYkwGWj+RWUo0
	OR8Yi3kl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gTE0cs+1OoYni0zrItPWTWed5+S2OI6BZ4OK+KJLpf83RJgbZ5ZK5xbzP3E+8qqteU1DhPdK
	1fydIttk921P281yoaLb7NqqmNTHZftd2Bo/P3dXDHMMn9bxPMEtJPb9v3eya5c+LPFP1Y1Z
	UMuSId+RsFNAtNFD8KeoyL/AQyrhAUatZsJWSizFGYmGWsxFxYkAIWwz17sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoG79Eu1gg6aFUhZTHz5hs/h2pYPJ
	4vKuOWwOzB47Z91l99i0qpPN4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjPc7pQrW8VbcPD6frYHxK2cXIyeHhICJxN55LxkhbDGJC/fWs3UxcnEICUxnlLjR
	uJIVwvnHKHH95Bl2kCo2AV2JY+u3ACU4OEQE9CROnogHCTML+Ejs2XiaCcQWFrCSuDKnlxnE
	ZhFQlfh47ghYK6+AncS9xrOsELagxI/J91ggerUk1u88zgRhy0tsXvOWGWS8hIC6xKO/uiBh
	kE33Fj2HKheR2PfiHeMERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeu
	l5yfu4kRHK3PpHcwrmqwOMQowMGoxMNbwakdLMSaWFZcmXuIUYKDWUmE93U3UIg3JbGyKrUo
	P76oNCe1+BBjMtCjE5mlRJPzgYkkryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6Yklqdmp
	qQWpRTBbmDg4pRoYZeapVtm9d2yezNu4VuWlfJJEDFec47aotGqZT+viPNVnedkb6N20ZF97
	Orlya2qRVP5iLwnLg/lcPCsYd0Qt01t1ZOP8P+eMzyXvyX/jLvlNMVDZgUMrMnBeb9O+u9Nm
	83/ylLZTrDX/6Nh1hYu5qVT/b2L/+8cypbPiuHeHTi3vrJ7DW6PEUpyRaKjFXFScCAAcfldP
	GgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5df529d440("regulator: core: Reduce busy-wait looping")
can also be used in regulator_do_set_voltage.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/regulator/core.c |   39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index afca1bc..c375bfb 100644
--- a/drivers/regulator/core.c
+++ b/d728099474rivers/regulator/core.c
@@ -2355,12 +2355,39 @@ static int _regulator_do_set_voltage(struct
regulator_dev *rdev,
 			delay = 0;
 		}
 
-		/* Insert any necessary delays */
-		if (delay >= 1000) {
-			mdelay(delay / 1000);
-			udelay(delay % 1000);
-		} else if (delay) {
-			udelay(delay);
+		/*
+		 * Delay for the requested amount of time as per the
guidelines in:
+		 *
+		 *     Documentation/timers/timers-howto.txt
+		 *
+		 * The assumption here is that regulators will never set the
voltage in
+		 * atomic context and therefore sleeping functions can be
used.
+		 */
+		if (delay) {
+			unsigned int ms = delay / 1000;
+			unsigned int us = delay % 1000;
+
+			if (ms > 0) {
+				/*
+				 * For small enough values, handle
super-millisecond
+				 * delays in the usleep_range() call below.
+				 */
+				if (ms < 20)
+					us += ms * 1000;
+				else
+					msleep(ms);
+			}
+
+			/*
+			 * Give the scheduler some room to coalesce with any
other
+			 * wakeup sources. For delays shorter than 10 us,
don't even
+			 * bother setting up high-resolution timers and just
busy-
+			 * loop.
+			 */
+			if (us >= 10)
+				usleep_range(us, us + 100);
+			else
+				udelay(us);
 		}
 	}
 
-- 
1.7.10.4

