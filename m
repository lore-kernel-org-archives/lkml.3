Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaJALc6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:32:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:33178 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaJALcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:32:55 -0400
Date: Wed, 1 Oct 2014 13:32:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: bhelgaas@google.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, bp@suse.de, dan.carpenter@oracle.com,
        dougthompson@xmission.com, m.chehab@samsung.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] edac: Add DDR3 LRDIMM support, entries in
 edac_mem_types[]
Message-ID: <20141001113250.GE18271@pd.tnic>
References: <1411070218-10258-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1411070218-10258-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 02:56:58PM -0500, Aravind Gopalakrishnan wrote:
> F15hM60h adds support for DDR4 and DDR3 LRDIMMS. Adding them here.
> 
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  drivers/edac/edac_mc.c | 3 +++
>  include/linux/edac.h   | 2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
> index 9f134823..71fd9fb 100644
> --- a/drivers/edac/edac_mc.c
> +++ b/drivers/edac/edac_mc.c
> @@ -146,6 +146,9 @@ const char *edac_mem_types[] = {
>  	"Rambus XDR",
>  	"Unbuffered DDR3 RAM",
>  	"Registered DDR3 RAM",
> +	"Load-Reduce DDR3 RAM",

Renamed it to "Load-Reduced DDR3 RAM" while applying.

Also, applied the following cleanup ontop:

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] EDAC: Sync memory types and names

Make keeping the sync between the mem_types enum and the actual string
names simpler by using designated initializers.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/edac_mc.c | 43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 129ff9c36a78..1747906f10ce 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -125,30 +125,27 @@ static void edac_mc_dump_mci(struct mem_ctl_info *mci)
 
 #endif				/* CONFIG_EDAC_DEBUG */
 
-/*
- * keep those in sync with the enum mem_type
- */
 const char * const edac_mem_types[] = {
-	"Empty csrow",
-	"Reserved csrow type",
-	"Unknown csrow type",
-	"Fast page mode RAM",
-	"Extended data out RAM",
-	"Burst Extended data out RAM",
-	"Single data rate SDRAM",
-	"Registered single data rate SDRAM",
-	"Double data rate SDRAM",
-	"Registered Double data rate SDRAM",
-	"Rambus DRAM",
-	"Unbuffered DDR2 RAM",
-	"Fully buffered DDR2",
-	"Registered DDR2 RAM",
-	"Rambus XDR",
-	"Unbuffered DDR3 RAM",
-	"Registered DDR3 RAM",
-	"Load-Reduced DDR3 RAM",
-	"Unbuffered DDR4 RAM",
-	"Registered DDR4 RAM",
+	[MEM_EMPTY]	= "Empty csrow",
+	[MEM_RESERVED]	= "Reserved csrow type",
+	[MEM_UNKNOWN]	= "Unknown csrow type",
+	[MEM_FPM]	= "Fast page mode RAM",
+	[MEM_EDO]	= "Extended data out RAM",
+	[MEM_BEDO]	= "Burst Extended data out RAM",
+	[MEM_SDR]	= "Single data rate SDRAM",
+	[MEM_RDR]	= "Registered single data rate SDRAM",
+	[MEM_DDR]	= "Double data rate SDRAM",
+	[MEM_RDDR]	= "Registered Double data rate SDRAM",
+	[MEM_RMBS]	= "Rambus DRAM",
+	[MEM_DDR2]	= "Unbuffered DDR2 RAM",
+	[MEM_FB_DDR2]	= "Fully buffered DDR2",
+	[MEM_RDDR2]	= "Registered DDR2 RAM",
+	[MEM_XDR]	= "Rambus XDR",
+	[MEM_DDR3]	= "Unbuffered DDR3 RAM",
+	[MEM_RDDR3]	= "Registered DDR3 RAM",
+	[MEM_LRDDR3]	= "Load-Reduced DDR3 RAM",
+	[MEM_DDR4]	= "Unbuffered DDR4 RAM",
+	[MEM_RDDR4]	= "Registered DDR4 RAM",
 };
 EXPORT_SYMBOL_GPL(edac_mem_types);
 
-- 
2.0.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
