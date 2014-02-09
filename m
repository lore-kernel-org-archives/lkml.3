Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaBIOpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 09:45:09 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:57744 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbaBIOpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 09:45:07 -0500
Message-ID: <1391957106.25424.12.camel@x220>
Subject: [PATCH] xtensa: no need to select USE_GENERIC_SMP_HELPERS
From: Paul Bolle <pebolle@tiscali.nl>
To: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 15:45:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 14:45:07.0097 (UTC) FILETIME=[865AE890:01CF25A5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f615136c06a7 ("xtensa: add SMP support") added "select
USE_GENERIC_SMP_HELPERS". But the Kconfig symbol USE_GENERIC_SMP_HELPERS
was already removed in v3.13, so that select is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

USE_GENERIC_SMP_HELPERS was removed in commit 0a06ff068f12 ("kernel:
remove CONFIG_USE_GENERIC_SMP_HELPER").

 arch/xtensa/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index ba56e11..c1d69ba 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -135,7 +135,6 @@ config HAVE_SMP
 config SMP
 	bool "Enable Symmetric multi-processing support"
 	depends on HAVE_SMP
-	select USE_GENERIC_SMP_HELPERS
 	select GENERIC_SMP_IDLE_THREAD
 	help
 	  Enabled SMP Software; allows more than one CPU/CORE
-- 
1.8.5.3

