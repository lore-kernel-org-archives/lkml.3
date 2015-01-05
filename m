Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbbAEPvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:51:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63802 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbbAEPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:27 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ca-54aab24874b4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 15/19] x86/olpc/xo15/sci: Use newly added
 power_supply_put API
Date: Mon, 05 Jan 2015 16:47:58 +0100
Message-id: <1420472882-10463-16-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xa7oem1aFGJy7oG8x6cl7ZouJKycz
	W7x+YWix8+FbNovl+/oZLTY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi9O7Sxy4PXbOusvu
	sXmFFtCcTjaPzUvqPbZcbWfx6NuyitFjxerv7B6fN8kFcERx2aSk5mSWpRbp2yVwZaya/pat
	4AFbReuHm8wNjBdZuxg5OSQETCTmL9/KAmGLSVy4t56ti5GLQ0hgKaPEw02rWCGcPiaJ+fN2
	MIFUsQkYS2xevgSsSkTgCZPE9NaTYO3MAoYSP9/9YQexhQXCJO5+a2MGsVkEVCWO7zoKto5X
	wEOiueMGG8Q6OYmTxyaDxTmB4k1/L4DNERJwl/jw7BfrBEbeBYwMqxhFU0uTC4qT0nMN9YoT
	c4tL89L1kvNzNzFCwvLLDsbFx6wOMQpwMCrx8HqcWBkixJpYVlyZe4hRgoNZSYT3VfqqECHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2MHmpT1m+Q+W/6p/CMu13qMhWn7O28GYdP345fVfmrUmJr
	WL7NZc6/rfM82W/2uci63ixaKvX+zhZeLoE1u2037fhyrH1bcM6DhlP3vT5obc27398UKNZh
	btzV/JBbNyJ9V+wLx2dFrSu8VQXa7Deuf/hIXvjfHcmJrq6nHq64b/PkKuvLZs0PSizFGYmG
	WsxFxYkA9OjimSkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct usage of put_device() with new API: power_supply_put().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/x86/platform/olpc/olpc-xo15-sci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index 08e350e757dc..55130846ac87 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -83,7 +83,7 @@ static void battery_status_changed(void)
 
 	if (psy) {
 		power_supply_changed(psy);
-		put_device(psy->dev);
+		power_supply_put(psy);
 	}
 }
 
@@ -93,7 +93,7 @@ static void ac_status_changed(void)
 
 	if (psy) {
 		power_supply_changed(psy);
-		put_device(psy->dev);
+		power_supply_put(psy);
 	}
 }
 
-- 
1.9.1

