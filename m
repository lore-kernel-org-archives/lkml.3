Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaADAJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:09:37 -0500
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:56623 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754198AbaADAI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:08:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1543:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3868:3872:4250:4321:4605:4823:5007:6119:6261:7904:8603:8660:8957:9040:10004:10026:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12683:13148:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: corn00_13feff63d244d
X-Filterd-Recvd-Size: 4390
From: Joe Perches <joe@perches.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] efi: style neatening
Date: Fri,  3 Jan 2014 16:08:48 -0800
Message-Id: <e0a37bd26a7cd9cee5cd5bb2341e6617783ce069.1388793978.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1388793978.git.joe@perches.com>
References: <cover.1388793978.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coalesce formats and remove spaces before tabs.
Move __initdata after the variable declaration.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/platform/efi/efi.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ef7b7b4..69c6133 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -67,7 +67,7 @@ static efi_system_table_t efi_systab __initdata;
 
 unsigned long x86_efi_facility;
 
-static __initdata efi_config_table_type_t arch_tables[] = {
+static efi_config_table_type_t arch_tables[] __initdata = {
 #ifdef CONFIG_X86_UV
 	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
 #endif
@@ -83,7 +83,7 @@ int efi_enabled(int facility)
 }
 EXPORT_SYMBOL(efi_enabled);
 
-static bool __initdata disable_runtime = false;
+static bool disable_runtime __initdata = false;
 static int __init setup_noefi(char *arg)
 {
 	disable_runtime = true;
@@ -271,9 +271,9 @@ static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
 int efi_set_rtc_mmss(const struct timespec *now)
 {
 	unsigned long nowtime = now->tv_sec;
-	efi_status_t 	status;
-	efi_time_t 	eft;
-	efi_time_cap_t 	cap;
+	efi_status_t	status;
+	efi_time_t	eft;
+	efi_time_cap_t	cap;
 	struct rtc_time	tm;
 
 	status = efi.get_time(&eft, &cap);
@@ -291,9 +291,8 @@ int efi_set_rtc_mmss(const struct timespec *now)
 		eft.second = tm.tm_sec;
 		eft.nanosecond = 0;
 	} else {
-		printk(KERN_ERR
-		       "%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
-		       __FUNCTION__, nowtime);
+		pr_err("%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
+		       __func__, nowtime);
 		return -1;
 	}
 
@@ -409,8 +408,7 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
@@ -442,9 +440,8 @@ void __init efi_reserve_boot_services(void)
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
-			memblock_dbg("Could not reserve boot range "
-					"[0x%010llx-0x%010llx]\n",
-						start, start+size-1);
+			memblock_dbg("Could not reserve boot range [0x%010llx-0x%010llx]\n",
+				     start, start+size-1);
 		} else
 			memblock_reserve(start, size);
 	}
@@ -566,8 +563,7 @@ static int __init efi_systab_init(void *phys)
 		return -EINVAL;
 	}
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		pr_err("Warning: System table version "
-		       "%d.%02d, expected 1.00 or greater!\n",
+		pr_err("Warning: System table version %d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
@@ -857,8 +853,8 @@ void __init efi_enter_virtual_mode(void)
 		(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
-		pr_alert("Unable to switch EFI into virtual mode "
-			 "(status=%lx)!\n", status);
+		pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
+			 status);
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

