Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab3GNSaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 14:30:00 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:56721 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796Ab3GNS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 14:29:59 -0400
Message-ID: <1373826596.1370.59.camel@x61.thuisdomein>
Subject: [PATCH] cpufreq: s3c24xx: rename CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Jul 2013 20:29:56 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2013 18:29:57.0637 (UTC) FILETIME=[24987350:01CE80C0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol CPU_FREQ_S3C24XX_DEBUGFS was renamed to
ARM_S3C24XX_CPUFREQ_DEBUGFS in commit f023f8dd59 ("cpufreq: s3c24xx:
move cpufreq driver to drivers/cpufreq"). But that commit missed one
instance of its macro CONFIG_CPU_FREQ_S3C24XX_DEBUGFS. Rename it too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested. Needs compile testing. But please note that setting
ARM_S3C24XX_CPUFREQ_DEBUGFS should currently lead to compile errors.

 drivers/cpufreq/s3c24xx-cpufreq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 3513e74..87781eb 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -49,7 +49,7 @@ static struct clk *clk_hclk;
 static struct clk *clk_pclk;
 static struct clk *clk_arm;
 
-#ifdef CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
+#ifdef CONFIG_ARM_S3C24XX_CPUFREQ_DEBUGFS
 struct s3c_cpufreq_config *s3c_cpufreq_getconfig(void)
 {
 	return &cpu_cur;
@@ -59,7 +59,7 @@ struct s3c_iotimings *s3c_cpufreq_getiotimings(void)
 {
 	return &s3c24xx_iotiming;
 }
-#endif /* CONFIG_CPU_FREQ_S3C24XX_DEBUGFS */
+#endif /* CONFIG_ARM_S3C24XX_CPUFREQ_DEBUGFS */
 
 static void s3c_cpufreq_getcur(struct s3c_cpufreq_config *cfg)
 {
-- 
1.8.1.4

