Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbaFCPR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:17:59 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56262 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaFCPR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:17:58 -0400
Date: Tue, 3 Jun 2014 16:17:54 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, akpm@linux-foundation.org, eric.y.miao@gmail.com
Subject: [PATCH v2 02/11] [arch/arm/mach-pxa] replace strict_strto call with
 kstrto
Message-ID: <20140603151754.GD28580@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 02/11] [arch/arm/mach-pxa] replace strict_strto call with kstrto

Replace obsolete call to strict_strto with kstrto

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/arm/mach-pxa/balloon3.c | 2 +-
 arch/arm/mach-pxa/viper.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
index 43596e0..d897292 100644
--- a/arch/arm/mach-pxa/balloon3.c
+++ b/arch/arm/mach-pxa/balloon3.c
@@ -90,7 +90,7 @@ int __init parse_balloon3_features(char *arg)
 	if (!arg)
 		return 0;
 
-	return strict_strtoul(arg, 0, &balloon3_features_present);
+	return kstrtoul(arg, 0, &balloon3_features_present);
 }
 early_param("balloon3_features", parse_balloon3_features);
 
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 41f27f6..de3b080 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -769,7 +769,7 @@ static unsigned long viper_tpm;
 
 static int __init viper_tpm_setup(char *str)
 {
-	return strict_strtoul(str, 10, &viper_tpm) >= 0;
+	return kstrtoul(str, 10, &viper_tpm) >= 0;
 }
 
 __setup("tpm=", viper_tpm_setup);
-- 
1.9.3

