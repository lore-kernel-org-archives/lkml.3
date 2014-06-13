Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaFMRBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:01:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34189 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaFMRBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:01:45 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: andrew.cooper3@citrix.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, eshelton@pobox.com, hpa@zytor.com,
        ian.campbell@citrix.com, jbeulich@suse.com, jeremy@goop.org,
        konrad.wilk@oracle.com, matt.fleming@intel.com, mingo@redhat.com,
        mjg59@srcf.ucam.org, stefano.stabellini@eu.citrix.com,
        tglx@linutronix.de
Subject: [PATCH v5 7/7] arch/x86: Comment out efi_set_rtc_mmss()
Date: Fri, 13 Jun 2014 19:00:23 +0200
Message-Id: <1402678823-24589-8-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

efi_set_rtc_mmss() is never used to set RTC due to bugs found
on many EFI platforms. It is set directly by mach_set_rtc_mmss().

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/platform/efi/efi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index deb4f05..bd3e080 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -244,6 +244,11 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
+#if 0
+/*
+ * efi_set_rtc_mmss() is never used to set RTC due to bugs found
+ * on many EFI platforms. It is set directly by mach_set_rtc_mmss().
+ */
 int efi_set_rtc_mmss(const struct timespec *now)
 {
 	unsigned long nowtime = now->tv_sec;
@@ -279,6 +284,7 @@ int efi_set_rtc_mmss(const struct timespec *now)
 	}
 	return 0;
 }
+#endif
 
 void efi_get_time(struct timespec *now)
 {
-- 
1.7.10.4

