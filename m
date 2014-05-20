Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaETPgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:36:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:9244 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbaETPgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:36:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 20 May 2014 08:30:45 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH 1/3] kernel: add calibration_delay_done()
Date: Tue, 20 May 2014 18:36:09 +0300
Message-ID: <1400600176-435-2-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1400600176-435-1-git-send-email-pdeschrijver@nvidia.com>
References: <1400600176-435-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add calibration_delay_done() call and dummy implementation. This allows
architectures to stop accepting registrations for new timer based delay
functions.

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 init/calibrate.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/init/calibrate.c b/init/calibrate.c
index 520702d..31cae76 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -262,6 +262,16 @@ unsigned long __attribute__((weak)) calibrate_delay_is_known(void)
 	return 0;
 }
 
+/*
+ * Indicate the cpu delay calibration is done. This can be used by
+ * architectures to stop accepting delay timer registrations after this point.
+ */
+
+void __attribute__((weak)) calibration_delay_done(void)
+{
+	return;
+}
+
 void calibrate_delay(void)
 {
 	unsigned long lpj;
@@ -301,4 +311,6 @@ void calibrate_delay(void)
 
 	loops_per_jiffy = lpj;
 	printed = true;
+
+	calibration_delay_done();
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

