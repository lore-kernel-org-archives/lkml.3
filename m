Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaKBKpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 05:45:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36466 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKBKpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 05:45:18 -0500
Date: Sun, 2 Nov 2014 11:45:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] amd64_edac: Document why it is 64-bit only
Message-ID: <20141102104514.GC5229@pd.tnic>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141102103300.GB5229@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 11:33:00AM +0100, Borislav Petkov wrote:
> I guess I'll add a note about this in the Kconfig text because I keep
> getting patches about this once every couple of months :-)

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] amd64_edac: Document why it is 64-bit only

I keep getting requests for this so let's hold it down why it doesn't
make sense. Also, drop incorrect statement about K8 and F10h - this
driver supports all relevant AMD CPUs.

Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/Kconfig | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 7072c2892d63..4be205741221 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -105,11 +105,16 @@ config EDAC_GHES
 	  In doubt, say 'Y'.
 
 config EDAC_AMD64
-	tristate "AMD64 (Opteron, Athlon64) K8, F10h"
+	tristate "AMD64 (Opteron, Athlon64)"
 	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction of DRAM ECC errors on
-	  the AMD64 families of memory controllers (K8 and F10h)
+	  the AMD64 families of memory controllers, everything >= K8.
+
+	  Note: this driver is 64-bit only on purpose because having a big
+	  driver report errors for 1 or 2 DIMMs max on 32-bit, considering
+	  current DIMM sizes, does not make a lot of sense to be worth the
+	  effort and energy.
 
 config EDAC_AMD64_ERROR_INJECTION
 	bool "Sysfs HW Error injection facilities"
-- 
2.0.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
