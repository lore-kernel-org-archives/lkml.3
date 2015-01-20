Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbbATDMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:12:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:55951 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbATDMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:12:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442529763"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part1 v7 31/38] x86/apb_timer: Remove unused function is_apbt_capable()
Date: Tue, 20 Jan 2015 11:08:34 +0800
Message-Id: <1421723321-8386-32-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Remove the function is_apbt_capable() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 7cfdc5467922..ede92c3364d3 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -135,14 +135,6 @@ static inline void apbt_clear_mapping(void)
 	apbt_virt_address = NULL;
 }
 
-/*
- * APBT timer interrupt enable / disable
- */
-static inline int is_apbt_capable(void)
-{
-	return apbt_virt_address ? 1 : 0;
-}
-
 static int __init apbt_clockevent_register(void)
 {
 	struct sfi_timer_table_entry *mtmr;
-- 
1.7.10.4

