Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaEZWFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 18:05:35 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:38512 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaEZWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 18:05:34 -0400
Date: Mon, 26 May 2014 23:05:29 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: eric.y.miao@gmail.com, richard@nod.at
Subject: [PATCH 03/12] [arch/arm/mach-pxa] Remove obsolete strict_strto calls
Message-ID: <20140526220529.GE25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH 03/12] [arch/arm/mach-pxa] replace strict_strto call with kstrto

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

