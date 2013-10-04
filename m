Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3JDMQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:16:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:56245 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab3JDMQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:16:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1032,1371106800"; 
   d="scan'208";a="411488623"
From: ville.syrjala@linux.intel.com
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: Add reboot quirk for Dell Latitude E5410
Date: Fri,  4 Oct 2013 15:16:04 +0300
Message-Id: <1380888964-14517-1-git-send-email-ville.syrjala@linux.intel.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

Dell Latitude E5410 needs reboot=pci to actually reboot.

Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
---
 arch/x86/kernel/reboot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index e643e74..7e920bf 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -326,6 +326,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Latitude E5410. */
+		.callback = set_pci_reboot,
+		.ident = "Dell Latitude E5410",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5410"),
+		},
+	},
 	{	/* Handle problems with rebooting on the Latitude E5420. */
 		.callback = set_pci_reboot,
 		.ident = "Dell Latitude E5420",
-- 
1.8.1.5

