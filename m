Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaK1JVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 04:21:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53654 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaK1JVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 04:21:13 -0500
X-AuditID: cbfee61a-f79c06d000004e71-8a-54783e87edeb
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: [PATCH/RFC v8 14/14] DT: Add documentation for the Skyworks AAT1290
Date: Fri, 28 Nov 2014 10:18:06 +0100
Message-id: <1417166286-27685-15-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd12u4oQg/6pchYbZ6xntTi6cyKT
	xfwj51gt+t8sZLU492olo0Xv1eeMFmeb3rBbXN41h81i65t1jBY9G7ayWiy9fpHJ4u6po2wW
	E6avZbFo3XuE3WL3rqesFofftLNanNm/ks1B0GPNvDWMHpf7epk8ds66y+6xcvkXNo/DXxey
	eGxa1cnmsWf+D1aPvi2rGD1WrP7O7vF5k1wAVxSXTUpqTmZZapG+XQJXxvdjjWwF77grGs/t
	YW1gbOHqYuTkkBAwkXi4YRo7hC0mceHeerYuRi4OIYHpjBLzZr1mA0kICbQzSSyc7w9iswkY
	Svx88Zqpi5GDQ0QgWuLSsXqQemaB5cwSL74cYQKpERbwkTi4sBPMZhFQlVjfM40FpJ5XwFNi
	4URGEFNCQEFiziQbkApOoOjcz2vBKoQEPCQWvUqZwMi7gJFhFaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwkD+T2sG4ssHiEKMAB6MSD++Pf+UhQqyJZcWVuYcYJTiYlUR4T30FCvGmJFZW
	pRblxxeV5qQWH2KU5mBREue9cTM3REggPbEkNTs1tSC1CCbLxMEp1cDYEOI9pzHtsanntH/r
	HRblx7KbT+wI0Tim8KjB+epZtscmahskBWJ6VbYVNKrzR16yXV1zN3t5fPZiN+5moZO7nkf0
	X3Au/PLQ92fE/9rJD7TD5WzSeb+dXndCp/Ti1dR/nTssvp/lOe682tJo2asN9iUf/beF/ug7
	mGd4uc5cL0jE3ugwm7USS3FGoqEWc1FxIgDXltGgbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree binding documentation for
1.5A Step-Up Current Regulator for Flash LEDs.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: <devicetree@vger.kernel.org>
---
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt

diff --git a/Documentation/devicetree/bindings/leds/leds-aat1290.txt b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
new file mode 100644
index 0000000..8f001dd
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/leds-aat1290.txt
@@ -0,0 +1,17 @@
+* Skyworks Solutions, Inc. AAT1290 Current Regulator for Flash LEDs
+
+Required properties:
+
+- compatible : should be "skyworks,aat1290"
+- gpios : two gpio pins in order FLEN, EN/SET
+- flash-timeout-microsec : maximum flash timeout in microseconds -
+			   it can be calculated using following formula:
+			   T = 8.82 * 10^9 * Ct
+
+Example:
+
+flash_led: flash-led {
+	compatible = "skyworks,aat1290";
+	gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+	flash-timeout-microsec = <1940000>;
+}
-- 
1.7.9.5

