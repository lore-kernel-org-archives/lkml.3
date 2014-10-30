Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbaJ3BJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 21:09:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43521 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbaJ3BJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 21:09:04 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-33-54518fad2fd4
Date: Thu, 30 Oct 2014 01:09:01 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] staging: octeon-ethernet: disable load balance for receiving
 packet when CONFIG_RPS is enabled.
To: "ralf@linux-mips.org" <ralf@linux-mips.org>, david.daney@cavium.com
Cc: gregkh@linuxfoundation.org, linux-mips@linux-mips.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20141030010643849@eunb.song
Msgkey: 20141030010643849@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141030010643849@eunb.song
X-ParentMTR: 
X-ArchiveUser: EV
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <141769840.281701414631339613.JavaMail.weblogic@epmlwas07d>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsVy+t8zHd21/YEhBtfb9Cwu75rD5sDo8XmT
	XABjVAOjTWJRckZmWapCal5yfkpmXrqtUmiIm66FkkJGfnGJrVK0kYGxnpGpiZ6RibmepUGs
	lZGpkkJeYm6qrVKFLlSvkkJRcgFQbW5lMdCAnFQ9qLhecWpeikNWfinIJXrFibnFpXnpesn5
	uUoKZYk5pUAjlPQTpjJmPLvRxF7wgLvi2LVetgbGLdxdjJwcQgIqEi3/vzOC2BICJhKH7k9k
	h7DFJC7cW8/WxcgFVLOMUaLr8xUmmKJnnY3sEIk5jBKPJ64D62YRUJV4/XsaG4jNJqAt8ePA
	VWYQW1igQGJl1y4wW0TAT+LY7f9gzcwCbYwS/9++Z4c4Q15i8unLYDavgKDEyZlPWCC2KUnc
	eNQCFVeWuDD3EDNEXEJi1vQLrBA2r8SM9qdQ9XIS076ugaqRljg/awMjzDuLvz+GivMDHbED
	6hsBialnDkLVqEts23KfDcLmk1iz8C3UTEGJ09e6mWF23d8ylwnmhq0tT8BuYBZQlJjS/ZAd
	wtaS+PJjHxu6X3gF3CXat/SCg1RCYCKHxJspRxknMCrNQlI3C8msWUhmIatZwMiyilE0tSC5
	oDgpvcgEOcI3MULS4YQdjPcOWB9iFOBgVOLhdUgLCBFiTSwrrsw9xJgMjKiJzFKiyfnApJtX
	Em9obGZkYWpiamxkbmmGIWxiamFhYoRDWEmc97XUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjCp+fj5Cc67vWf9998252wz0JJx2rSgyFelq+3dU+Mm+q+ryVkpmnVld+964nKzy3Xx+
	bUqT/Z+idzy/xLpU1zbc2ejlaRLoWdh+Zd3bWa8lp3JzTgw19Zu2IGqL2H+WFXfiWeYuYPBd
	O6lw/qX01BU8ORKpPXN3fzw+x9Te+Fhi/cVlHfN3sSuxFGckGmoxFxUnAgBw2ZlysAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t/tPt21/YEhBk/6tS0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xrMbTewFD7grjl3rZWtg3MLdxcjJISSgItHy/zsjiC0hYCLxrLORHcIWk7hwbz1bFyMXUM0c
	RonHE9eBFbEIqEq8/j2NDcRmE9CW+HHgKjOILSxQILGyaxeYLSLgJ3Hs9n92kGZmgTZGif9v
	37NDbJOXmHz6MpjNKyAocXLmExaIbUoSNx61QMWVJS7MPcQMEZeQmDX9AiuEzSsxo/0pVL2c
	xLSva6BqpCXOz9rACHP14u+PoeL8QEfsYIKwBSSmnjkIVaMusW3LfTYIm09izcK3UDMFJU5f
	62aG2XV/y1wmmBu2tjwBu4FZQFFiSvdDdghbS+LLj31s6H7hFXCXaN/SyzaBUXYWktQsJO2z
	kLQjq1nAyLKKUTS1ILmgOCm9wlivODG3uDQvXS85P3cTIzgdPVu8g/H/eetDjAIcjEo8vC+S
	A0KEWBPLiitzDzFKcDArifCKdASGCPGmJFZWpRblxxeV5qQWH2I0BUbbRGYp0eR8YKrMK4k3
	NDYwNjS0NDcwNTSyUBLnjb+VFCQkkJ5YkpqdmlqQWgTTx8TBKdXAOOm+3ZX2F5IlXH+XBtlk
	7t8/8X2Kzbn5uqaFm7d8M3sTxfmfufGfRx/zadPJuz3e3T6z6nXaKtk7+gsN3Yyiki3PC+x8
	eqFz9Vzn6ddthOVeJKq+sM84sVd6tfcLq1mVXaxFWzbNsDzpFqMapFgeyn7nFJOC934du+9m
	hk9q3iSmxkn+vmzyQImlOCPRUIu5qDgRABBHFG1dAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9U19Cik008107


It's better disable load balance for receiving packet when CONFIG_RPS is enabled.
If not, octeon-ethernet driver select CPU and then the rps select again CPU.
It can be ipi interrupts overhead and packet reordering could be possible.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 drivers/staging/octeon/ethernet-rx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index b2b6c3c..44e372f 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -286,6 +286,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			did_work_request = 1;
 		}
 
+#ifndef CONFIG_RPS
 		if (rx_count == 0) {
 			/*
 			 * First time through, see if there is enough
@@ -300,6 +301,7 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 			if (backlog > budget * cores_in_use && napi != NULL)
 				cvm_oct_enable_one_cpu();
 		}
+#endif
 		rx_count++;
 
 		skb_in_hw = USE_SKBUFFS_IN_HW && work->word2.s.bufs == 1;
-- 
1.7.0.1
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
