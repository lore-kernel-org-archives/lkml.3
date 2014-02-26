Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaBZBV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:21:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41469 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaBZBVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:21:03 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-ee-530d417d1546
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
In-reply-to: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
Subject: [PATCH 2/3] regulator: dbx500: use seq_puts() instead of seq_printf()
Date: Wed, 26 Feb 2014 10:21:01 +0900
Message-id: <002f01cf3291$02c7f7e0$0857e7a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Ac8ykMzEt0AEx/NVROGPrQsXYu79GwAABOiQ
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfd1aR95ggxsrdC3WPzjGZDH14RM2
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyebRt2UVo8f3pWvYPT5vkgtgjeKySUnNySxL
	LdK3S+DKaH3bxF4wj7ui7e1ntgbGBZxdjJwcEgImEku3XGOEsMUkLtxbz9bFyMUhJLCMUeLc
	uefMMEVbP79khEhMZ5Q4fvAUE4Tzm1Hiy4p+FpAqNgE1iS9fDrN3MXJwiAioSvx/5Q5Swyyw
	kFFiypIHYJOEBGwlpp47ClbDKWAnMeWzAkhYWMBP4s2/32BjWIBaT984DVbOC1S+6c5FNghb
	UOLH5HtgNcwCWhLrdx5ngrDlJTavecsMMlJCQF3i0V9diLCIxL4X78AeExEwkpgz8zQbxC+P
	2CUmnRCEWCUg8W3yIRaIVlmJTQeg3pWUOLjiBssERolZSBbPQrJ4FpLFs5BsW8DIsopRNLUg
	uaA4Kb3IVK84Mbe4NC9dLzk/dxMjJE4n7mC8f8D6EGMy0PqJzFKiyfnAOM8riTc0NjOyMDUx
	NTYytzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZ1Z9zfKb4VuTP1af0r
	lnv/dx4XrRbrOc2ss7FUrGqZjK3fFAb9r8febM54kKfy+AqvRtu7awwRZf/EjZ+9+btEYPn8
	srsdnf2vZuhv2LZwl/WsmYUyJTu/7bl6zKHWvb3J4brnmi9Zu8WY3fIftj9kPDVPQffnT5k/
	nVcdlu7hvR08ZU33bMkkJZbijERDLeai4kQA12DwSukCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1aR95gg4mnNC3WPzjGZDH14RM2
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyebRt2UVo8f3pWvYPT5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzGh928ReMI+7ou3tZ7YGxgWcXYycHBICJhJb
	P79khLDFJC7cW8/WxcjFISQwnVHi+MFTTBDOb0aJLyv6WUCq2ATUJL58OczexcjBISKgKvH/
	lTtIDbPAQkaJKUseMIPUCAnYSkw9dxSshlPATmLKZwWQsLCAn8Sbf7/BxrAAtZ6+cRqsnBeo
	fNOdi2wQtqDEj8n3wGqYBbQk1u88zgRhy0tsXvOWGWSkhIC6xKO/uhBhEYl9L96B3S8iYCQx
	Z+ZptgmMQrOQTJqFZNIsJJNmIWlfwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4DTyT
	2sG4ssHiEKMAB6MSD28AC2+wEGtiWXFl7iFGCQ5mJRFei288wUK8KYmVValF+fFFpTmpxYcY
	k4EencgsJZqcD0xReSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXA6Pmklbubs/H4gu+WK+y6ln5+0LL8Y/K+1h85lo+c/v69te+87o9TMkFs8/Y5rQo5K39m
	RVmG7mZH8ciMbWK3uJumSn3+Gnji6H+L9Pq3v3QX5sdcW1Unc3/ZsllXSmOVEreuveR4+ihP
	NsPf/cmPdmi9enkof4ta/bIvtb1HnqsnlShf1rkQWq7EUpyRaKjFXFScCAALNzQBRwMAAA==
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
 drivers/regulator/dbx500-prcmu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index f111dfb..3dd1096 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -97,10 +97,10 @@ static int ux500_regulator_power_state_cnt_print(struct seq_file *s, void *p)
 	int err;
 
 	/* print power state count */
-	err = seq_printf(s, "ux500-regulator power state count: %i\n",
-		power_state_active_get());
+	err = seq_puts(s, "ux500-regulator power state count: %i\n",
+			power_state_active_get());
 	if (err < 0)
-		dev_err(dev, "seq_printf overflow\n");
+		dev_err(dev, "seq_puts overflow\n");
 
 	return 0;
 }
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


