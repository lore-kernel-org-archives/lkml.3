Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3HGGe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:34:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17737 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3HGGey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:34:54 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f5f6d00000105f-d5-5201ea8cb87e
Content-transfer-encoding: 8BIT
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] [TRIVIAL] ARM: msm: fix compilation error in gpiomux
Date: Wed, 07 Aug 2013 08:34:39 +0200
Message-id: <1375857279-18082-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFLMWRmVeSWpSXmKPExsVy+t/xa7o9rxiDDM43cFr8OzaFyeLx8n9s
	FlOXtbFavH5haLHp8TVWi4n7z7JbXN41h83i9mVeBw6PluYeNo/Lfb1MHqcn72fx2Lyk3qNv
	yypGj8+b5ALYorhsUlJzMstSi/TtErgyLq/pZy6YwV6xce1ZpgbGSWxdjBwcEgImEjf6S7sY
	OYFMMYkL99YDhbk4hASWMkpM7lrBBpLgFRCU+DH5HgtIPbOAvMSRS9kgYWYBdYlJ8xYxQ9T3
	MUmcb9oKVs8mYCyxefkSsEEiAs1MEp0Hv7BDdBhK/Hz3B8wWFnCV6Pq/H8xmEVCVuPXyMyvE
	MneJyfePMUMcpyAxZ5LNBEa+WUjOmIVwxiwkZyxgZF7FKJpamlxQnJSea6RXnJhbXJqXrpec
	n7uJERK+X3cwLj1mdYhRgINRiYe3QowxSIg1say4MvcQowQHs5IIr9YcoBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQbGnEMc628HVOWIXvRK280iGcn1Y+3RPxkcjm/Oleb3rFZxOFR727I/dcpR
	1cvS71Pko2Q1pomXSc8qPlNVNa+/V1FRPU3tvsD26SK3nPa4pp7bbrDL3SGEu2JRZGHUBgfW
	Y8Vehb1GVjsEX9szVs5aWjz3r15imPXrVyEKpoF3qmz+WzfxpiuxFGckGmoxFxUnAgDKKUOm
	PQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compilation error in gpiomux (CONFIG_MSM_GPIOMUX=y):
arch/arm/mach-msm/gpiomux.c:24:13: error: static declaration of
	‘__msm_gpiomux_write’ follows non-static declaration
arch/arm/mach-msm/gpiomux.h:85:6: note: previous declaration of
	‘__msm_gpiomux_write’ was here

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-msm/gpiomux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/gpiomux.c b/arch/arm/mach-msm/gpiomux.c
index 2b8e2d2..4110b82 100644
--- a/arch/arm/mach-msm/gpiomux.c
+++ b/arch/arm/mach-msm/gpiomux.c
@@ -21,7 +21,7 @@
 
 static DEFINE_SPINLOCK(gpiomux_lock);
 
-static void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
+void __msm_gpiomux_write(unsigned gpio, gpiomux_config_t val)
 {
 	unsigned tlmm_config  = (val & ~GPIOMUX_CTL_MASK) |
 				((gpio & 0x3ff) << 4);
-- 
1.7.9.5

