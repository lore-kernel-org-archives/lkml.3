Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab3FQT1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:27:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53503 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FQT1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:27:46 -0400
Message-ID: <51BF6315.9020501@infradead.org>
Date: Mon, 17 Jun 2013 12:27:17 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH -next v3] thermal:  fix x86_pkg_temp_thermal.c build and Kconfig
References: <20130617185106.5950ffbf4b96acd9b2b2c834@canb.auug.org.au> <51BF4159.1000004@infradead.org> <51BF46C3.3090900@linux.intel.com> <51BF4DA2.40601@infradead.org> <51BF50E3.9000806@linux.intel.com> <51BF5174.805@infradead.org> <20130617181702.GA7217@pd.tnic>
In-Reply-To: <20130617181702.GA7217@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build error in x86_pkg_temp_thermal.c.  It requires that
X86_MCE & X86_THERMAL_VECTOR be enabled, so depend on the latter symbol,
since it depends on X86_MCE (indirectly).

Also, X86_PKG_TEMP_THERMAL is already inside an "if THERMAL" block,
so remove that duplicated dependency.

ERROR: "platform_thermal_package_rate_control" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!
ERROR: "platform_thermal_package_notify" [drivers/thermal/x86_pkg_temp_thermal.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/thermal/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-next-20130617.orig/drivers/thermal/Kconfig
+++ linux-next-20130617/drivers/thermal/Kconfig
@@ -171,8 +171,7 @@ config INTEL_POWERCLAMP
 
 config X86_PKG_TEMP_THERMAL
 	tristate "X86 package temperature thermal driver"
-	depends on THERMAL
-	depends on X86
+	depends on X86_THERMAL_VECTOR
 	select THERMAL_GOV_USER_SPACE
 	default m
 	help
