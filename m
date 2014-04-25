Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaDYQpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:45:47 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:48276 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaDYQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:45:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+zf0bvbsHeRvVrcGbDXUUaOtngu7IPwGw=
X-DKIM: OpenDKIM Filter v2.0.1 titan CD44C563452
From: Jason Cooper <jason@lakedaemon.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Cooper <jason@lakedaemon.net>, Fengguang Wu <fengguang.wu@intel.com>,
        kbuild-all@01.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: crypto: skein: depend upon CRYPTO
Date: Fri, 25 Apr 2014 16:45:09 +0000
Message-Id: <1398444309-24672-1-git-send-email-jason@lakedaemon.net>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <20140425151554.GB31117@localhost>
References: <20140425151554.GB31117@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang's randconfig kernel build tester discovered the following
warnings:

warning: (CRYPTO_THREEFISH) selects CRYPTO_ALGAPI which has unmet direct dependencies (CRYPTO)
warning: (DM_VERITY && CRYPTO_SKEIN) selects CRYPTO_HASH which has unmet direct dependencies (CRYPTO)

Fix this in the Kconfig by depending on CRYPTO.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/staging/skein/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/skein/Kconfig b/drivers/staging/skein/Kconfig
index 8f5a72a90ced..b9172bfcdc1b 100644
--- a/drivers/staging/skein/Kconfig
+++ b/drivers/staging/skein/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_SKEIN
 	bool "Skein digest algorithm"
-	depends on (X86 || UML_X86) && 64BIT
+	depends on (X86 || UML_X86) && 64BIT && CRYPTO
 	select CRYPTO_THREEFISH
 	select CRYPTO_HASH
 	help
@@ -17,7 +17,7 @@ config CRYPTO_SKEIN
 
 config CRYPTO_THREEFISH
 	bool "Threefish tweakable block cipher"
-	depends on (X86 || UML_X86) && 64BIT
+	depends on (X86 || UML_X86) && 64BIT && CRYPTO
 	select CRYPTO_ALGAPI
 	help
 	  Threefish cipher algorithm is the tweakable block cipher underneath
-- 
1.9.2

