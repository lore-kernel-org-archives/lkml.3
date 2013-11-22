Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3KVB7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:59:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49189 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab3KVB5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:57:40 -0500
From: Joel Fernandes <joelf@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <benoit.cousson@linaro.org>, <santosh.shilimkar@ti.com>,
        <jgchunter@gmail.com>, <rnayak@ti.com>, <balbi@ti.com>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
Date: Thu, 21 Nov 2013 19:56:52 -0600
Message-ID: <1385085414-9034-7-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385085414-9034-1-git-send-email-joelf@ti.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timer's parent mux clocks require a parent clock alias, provide the same from
device tree.

Ultimately this will be provided from DT as clock node phandles but clk-mux
driver DT bindings series is still under going review. So to keep things
working during the timer migration, we add this property.  Originally this was
hardcoded in timer.c, now we do the same in DT and would be removing the
hardcoded names from timer.c

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 Documentation/devicetree/bindings/arm/omap/timer.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/omap/timer.txt b/Documentation/devicetree/bindings/arm/omap/timer.txt
index 6cf7a75..644bc61 100644
--- a/Documentation/devicetree/bindings/arm/omap/timer.txt
+++ b/Documentation/devicetree/bindings/arm/omap/timer.txt
@@ -24,6 +24,11 @@ Required properties:
 			where <X> is the instance number of the timer from the
 			HW spec.
 
+Required properties for system timers (clockevents/clocksource):
+- ti,timer-parent:	System timer's parent mux clock needs to be setup.
+			This is currently hardcoded in code, for DT boot we
+			move this to DT.
+
 Optional properties:
 - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.
 - ti,timer-dsp:		Indicates the timer can interrupt the on-chip DSP in
-- 
1.8.1.2

