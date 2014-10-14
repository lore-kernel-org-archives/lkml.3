Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316AbaJNMhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:37:07 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12274 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbaJNMhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:37:00 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-4b-543d18eae9f3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Pavel Machek <pavel@ucw.cz>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 3/7] x86/olpc/xo1/sci: Use newly added power_supply_put API
Date: Tue, 14 Oct 2014 14:35:13 +0200
Message-id: <1413290117-13082-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
References: <1413290117-13082-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xK7qvJGxDDD485rQ4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr4/D1DqaCLWwVjy/O
	YG5gXMXaxcjJISFgIvFp80MmCFtM4sK99WxdjFwcQgJLGSV2THrBBpIQEuhjktj2BKyITcBY
	YvPyJWBFIgKbWCW2rVjABOIwC1xnlFh99TY7SJWwgLfE6QMNYN0sAqoSb84eBevmFXCX+Lr8
	H9Q6OYmTxyYDncHBwSngITFxlxqIKQRUMuuZ7ARG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS
	9ZLzczcxQuLp6w7GpcesDjEKcDAq8fAWRNqECLEmlhVX5h5ilOBgVhLhVeCwDRHiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAeExoNsfap0v3yc1w95uk2ujT/UfBlX/yi+kNi/fqVnmcjDskMYf3
	w5V7orzMNe3enZ/XBta/+rr/4unpdrt5czcJfsuPSNS78Ob7bbUTd9czN+ZMPLzCer+Vr9b+
	zvsfJP0Lpmb9mH82lPvEpUreJ/fFS2xS5eu3nGcJXzM1KMpI7NDCbaoRLEosxRmJhlrMRcWJ
	AAzoU86FAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct usage of put_device() with new API: power_supply_put().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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

