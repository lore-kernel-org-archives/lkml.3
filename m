Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaJPHnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:43:25 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58612 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaJPHmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:42:24 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-86-543f76dbc0cd
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
Subject: [PATCH v2 4/7] x86/olpc/xo15/sci: Use newly added power_supply_put API
Date: Thu, 16 Oct 2014 09:42:04 +0200
Message-id: <1413445327-24862-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
References: <1413445327-24862-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t/xa7q3y+xDDBbN07M4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoErY9X0t2wFD9gqWj/c
	ZG5gvMjaxcjJISFgInFuyWFmCFtM4sK99WxdjFwcQgJLGSX+zp3PCOH0MUmsn/WdDaSKTcBY
	YvPyJWBVIgKbWCW2rVjABOIwC1xnlFh99TY7SJWwgL/EyW/3WUBsFgFViY6VN8BsXgF3iXXf
	vzNC7JOTOHlsMtgdnAIeEv975zKB2EJANXfftLNOYORdwMiwilE0tTS5oDgpPddIrzgxt7g0
	L10vOT93EyMkqr7uYFx6zOoQowAHoxIPr0awfYgQa2JZcWXuIUYJDmYlEd7mQqAQb0piZVVq
	UX58UWlOavEhRiYOTqkGxgm1h/xm/XLeGr9D8geb7KE3X/fnzlgpZX5B8dA1pYCaKau+hxY8
	nmDlfiT6iozmw2nmt7bv3OYQzDYnYlOpdrrcAufNsdfbf/a8aFJU3v7shYZkdiuzH3vzu6mF
	rXnPy722+brvSnBc9C2apdH0iFvZHE3JuKciVxKeNDPdOpjB/ULV9Gb0UyWW4oxEQy3mouJE
	AD0DQqCIAgAA
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

