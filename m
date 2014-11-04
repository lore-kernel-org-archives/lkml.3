Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaKDPKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:10:55 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54472 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243AbaKDPKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:10:50 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-93-5458ec780392
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
Subject: [PATCH RESEND v2 3/7] x86/olpc/xo1/sci: Use newly added
 power_supply_put API
Date: Tue, 04 Nov 2014 16:10:32 +0100
Message-id: <1415113836-26098-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113836-26098-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t/xy7oVbyJCDL7+FrE4uFXTYuOM9awW
	S5oyLCY9ec9sMXHlZGaLaRvFLV6/MLRYtvgpo8XZpjfsFve/HmW0mPJnOZPFpsfXWC0u75rD
	ZvG59wijxcelG1gt1h65y25x6cACJou7p46yWTxe8Zbd4nQ3q8Xp3SUWmzdNZbb4seExq4O4
	x4T+T4weO2fdZfdYsKnUY/MKLY/Fe14yeWxa1cnmcefaHjaPd+fOsXvMOxnosXlJvcfHp7dY
	PN7vu8rm0bdlFaPHitXf2T0+b5LzONHyhTVAIIrLJiU1J7MstUjfLoEr49SPZ8wFt9kqfrzZ
	y9zAeIa1i5GTQ0LARKLrySs2CFtM4sK99WC2kMBSRom139W7GLmA7D4miXuXboA1sAkYS2xe
	voQNJCEi0MgqcW7rGyYQh1mgg0nidstOsCphgXCJYzNfsoDYLAKqEj92tYPZvALuEj0PH7JD
	rJOTOHlsMlg9p4CHxM6W/+wQq90l3mzczjqBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k
	/NxNjJCY+rKDcfExq0OMAhyMSjy8GeoRIUKsiWXFlbmHGCU4mJVEeNUfA4V4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUw6rzc8V703sUbkUsESt5Ma6yaflX526ZiaXdrq59cVcdX1ASa/o6xdW7O
	n31LiqF0T9+OFb+mR2YfXd9zNr5at09szXOjVUXM/v8eyefsaT9uFKmwU+19DOemQ1L9rrqb
	v2m/6AjnvrujLf733hvTQ7yi+xTyqpd4S3z579G80HnrrnVuW8yNlViKMxINtZiLihMB4FQ6
	aYcCAAA=
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

