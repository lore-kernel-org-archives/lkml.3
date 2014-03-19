Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbaCSA0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:26:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10738 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758625AbaCSA0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:26:18 -0400
X-AuditID: cbfee690-b7f266d00000287c-aa-5328e4299a50
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Fengguang Wu'" <fengguang.wu@intel.com>
References: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
 <002f01cf3291$02c7f7e0$0857e7a0$%han@samsung.com>
In-reply-to: <002f01cf3291$02c7f7e0$0857e7a0$%han@samsung.com>
Subject: [PATCH V2] regulator: dbx500: use seq_puts() instead of seq_printf()
Date: Wed, 19 Mar 2014 09:26:17 +0900
Message-id: <001401cf4309$d7fd92c0$87f8b840$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8ykMzEt0AEx/NVROGPrQsXYu79GwAABOiQBB42CXA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t8zI13NJxrBBnvXWFmsf3CMyWLqwyds
	Fu+fr2e2uLzwEqvFtysdTBaXd81hc2Dz2DnrLrvH4j0vmTw2repk8+jbsorR4/vSNewenzfJ
	BbBFcdmkpOZklqUW6dslcGU8uHSNreAJR8WF97/ZGhiXsHcxcnJICJhIzPj7lQnCFpO4cG89
	WxcjF4eQwDJGiVs7frPBFO3ZvYwJIrGIUWLRp7VQVb8ZJV7Peg5WxSagJvHly2GgsRwcIgKq
	Ev9fuYPUMAucYpSY/XQrK0iNkEChxMUF55hBbE4BO4mph36xgNjCAr4SjyafALNZgHpv/DrC
	CjKHV8BW4sstTZAwr4CgxI/J98BKmAW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12QsIiAlcS+
	rmtQJSIS+168YwQ5R0LgK7vEyWtroFYJSHybfIgFoldWYtMBZoh/JSUOrrjBMoFRYhaSzbOQ
	bJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiJ3gk7GO8dsD7EmAy0fiKz
	lGhyPjD680riDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmD
	U6qBkX3TxN9MhTP33z870/zcG/3HJ97Jvw17uiX/l3ePt+KxD98ndUdGdX6PO6gY4J5w5iOD
	8cEzS9clOz6Zbn7n4oOm65Myz+4Rnna8y3QNz8u3184FPH41PUhUzlE0rUZ41w8X7a9PbtX/
	qwpge7K22Gzxy4VJ+r1Z874sPLlQPv+o4D2h/dySNXOVWIozEg21mIuKEwGHzEmw9AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jAV3NJxrBBp/Pmlqsf3CMyWLqwyds
	Fu+fr2e2uLzwEqvFtysdTBaXd81hc2Dz2DnrLrvH4j0vmTw2repk8+jbsorR4/vSNewenzfJ
	BbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeHDpGlvBE46KC+9/szUw
	LmHvYuTkkBAwkdizexkThC0mceHeerYuRi4OIYFFjBKLPq2Fcn4zSrye9ZwNpIpNQE3iy5fD
	QN0cHCICqhL/X7mD1DALnGKUmP10KytIjZBAocTFBeeYQWxOATuJqYd+sYDYwgK+Eo8mnwCz
	WYB6b/w6wgoyh1fAVuLLLU2QMK+AoMSPyffASpgFtCTW7zzOBGHLS2xe85YZpFxCQF3i0V9d
	kLCIgJXEvq5rUCUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxglPDM6kdjCsbLA4xCnAwKvHwHojSCBZiTSwrrsw9xCjBwawkwit8FyjEm5JY
	WZValB9fVJqTWnyIMRnoz4nMUqLJ+cC0lVcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjNnRcXEPOV3e5qk0PCqN2Hs18Mhmnf/WN+LOa/F9mfvFJ2NjWE+p
	ScLTxCtL53Vsjuh8W/SFa8r6Y4/tpx+74M0iELz5Xcn6e9/OKEdpOx1bwfV/R/XJOU39mdLK
	NxIdGf9ePf95Dn+GczLDfNe59u+1zC4eU1R7elFtau+bFqW2iq78E6+fbFdiKc5INNRiLipO
	BADMV5DMUQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a constant format without additional arguments, use seq_puts()
instead of seq_printf(). Also, it fixes the following checkpatch
warning.

  WARNING: Prefer seq_puts to seq_printf

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Removed unnecessary seq_puts() in ux500_regulator_power_state_cnt_print()
  in order to prevent build error, per Fengguang Wu.

 drivers/regulator/dbx500-prcmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index ce89f78..ac2c1d6 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -127,9 +127,9 @@ static int ux500_regulator_status_print(struct seq_file *s, void *p)
 	int i;
 
 	/* print dump header */
-	err = seq_printf(s, "ux500-regulator status:\n");
+	err = seq_puts(s, "ux500-regulator status:\n");
 	if (err < 0)
-		dev_err(dev, "seq_printf overflow\n");
+		dev_err(dev, "seq_puts overflow\n");
 
 	err = seq_printf(s, "%31s : %8s : %8s\n", "current",
 		"before", "after");
-- 
1.7.10.4


