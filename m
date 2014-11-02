Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaKBKuC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 05:50:02 -0500
Received: from pepin.polanet.pl ([193.34.52.2]:40793 "EHLO pepin.polanet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKBKuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 05:50:00 -0500
X-Greylist: delayed 1664 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Nov 2014 05:49:59 EST
Date: Sun, 2 Nov 2014 11:22:12 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: Borislav Petkov <bp@alien8.de>, linux-edac@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141102102212.GA7034@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While both K8 and F10h are AMD64 CPUs, EDAC doesn't require them to run
in long mode; AMD_NB dependency is enough.

Fixes: 3d373290450b ("amd64_edac: do not enable module by default").

Signed-off-by: Tomasz Pala <gotar@polanet.pl>
---
 drivers/edac/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 7072c28..af9c9fa 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -106,7 +106,7 @@ config EDAC_GHES
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h"
-	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && EDAC_DECODE_MCE
+	depends on EDAC_MM_EDAC && AMD_NB && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction of DRAM ECC errors on
 	  the AMD64 families of memory controllers (K8 and F10h)
-- 
1.6.0.4



-- 
Tomasz Pala <gotar@pld-linux.org>
