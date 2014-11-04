Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaKDPLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:11:04 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16747 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaKDPKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:51 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-98-5458ec79f2ef
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 4/7] x86/olpc/xo15/sci: Use newly added
 power_supply_put API
Date: Tue, 04 Nov 2014 16:10:33 +0100
Message-id: <1415113836-26098-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xy7qVbyJCDKa957M4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoErY9X0t2wFD9gqWj/c
	ZG5gvMjaxcjJISFgIvHu7FF2CFtM4sK99WxdjFwcQgJLGSUWvPnDCOH0MUncWvmCDaSKTcBY
	YvPyJWBVIgKNrBLntr5hAnGYBTqYJG637ASay8EhLBAhce5BEUgDi4CqxN/eG0wgNq+Au8TH
	5qeMEOvkJE4emwx2BqeAh8TOlv9gZwgB1bzZuJ11AiPvAkaGVYyiqaXJBcVJ6bmGesWJucWl
	eel6yfm5mxghMfVlB+PiY1aHGAU4GJV4eDPUI0KEWBPLiitzDzFKcDArifCqPwYK8aYkVlal
	FuXHF5XmpBYfYmTi4JRqYNTZ0rOmedH8bfbLVpexpKlKb7QNMQoK5FrSKjKH+cuFNffTDTm8
	VigGhES2htmUMUwX5N3hdLjh9YyweNPFx8WPcai/5crm45MTPZXCUH1KQuBNjffE0o069cYn
	1+gfMVZZqf1HvPyCwc7+SRLie1+ptpt0V9pmrT7w1OzXAT2fPaf5/8qEKLEUZyQaajEXFScC
	AMNI3g6HAgAA
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

