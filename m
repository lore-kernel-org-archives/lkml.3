Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbbAEPtz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:49:55 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56286 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbbAEPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:48:29 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-c6-54aab248e9e4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCHv2 14/19] x86/olpc/xo1/sci: Use newly added power_supply_put
 API
Date: Mon, 05 Jan 2015 16:47:57 +0100
Message-id: <1420472882-10463-15-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t/xa7oem1aFGBzvFbSY9OQ9s8XElZOZ
	LV6/MLTY+fAtm8Xyff2MFpseX2O1uLxrDpvF594jjBZ3Tx1lszhz+hKrxendJQ7cHjtn3WX3
	2LxCC2hOJ5vH5iX1HluutrN49G1ZxeixYvV3do/Pm+QCOKK4bFJSczLLUov07RK4Mk79eMZc
	cJut4sebvcwNjGdYuxg5OSQETCRaLr1ihLDFJC7cW8/WxcjFISSwlFHi1dzlzBBOH5PE/Hk7
	mECq2ASMJTYvXwJWJSLwhElieutJFpAEs4ChxM93f9hBbGGBUIk1N76DxVkEVCXa+hcDNXBw
	8Ap4SKxusIfYJidx8thksCs4gcJNfy+AlQsJuEt8ePaLdQIj7wJGhlWMoqmlyQXFSem5hnrF
	ibnFpXnpesn5uZsYIUH5ZQfj4mNWhxgFOBiVeHg9TqwMEWJNLCuuzD3EKMHBrCTC+yp9VYgQ
	b0piZVVqUX58UWlOavEhRiYOTqkGRnPDG1xii5y3ezYcFww0e/fua6nzA+az+tV9BYYuoiIC
	m/+tTbCY31UzZa9Uo3DY7LCqi9dmFKVctj9j6SewcKXxW8Wei82i3VY6197FHHoYxCMtlGTF
	tDb0peQKVuaC3m3hW5/tOP1JILBn8b8yl8evQtZtEHO9wHbp/conHvZee0XXKq6oVGIpzkg0
	1GIuKk4EALrS6i4oAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct usage of put_device() with new API: power_supply_put().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/x86/platform/olpc/olpc-xo1-sci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 9a2e590dd202..7fa8b3b53bc0 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -61,7 +61,7 @@ static void battery_status_changed(void)
 
 	if (psy) {
 		power_supply_changed(psy);
-		put_device(psy->dev);
+		power_supply_put(psy);
 	}
 }
 
@@ -71,7 +71,7 @@ static void ac_status_changed(void)
 
 	if (psy) {
 		power_supply_changed(psy);
-		put_device(psy->dev);
+		power_supply_put(psy);
 	}
 }
 
-- 
1.9.1

