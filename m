Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab3GVVBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:01:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45722 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298Ab3GVVBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:01:11 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: [PATCH] APEI/ERST: Fix error message formatting
Date: Mon, 22 Jul 2013 23:01:06 +0200
Message-Id: <1374526866-6813-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[    5.525861] ERST: Can not request iomem region <0x        c7eff000-0x        c7f00000> for ERST.

This needs to have leading zeroes. Make it so.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/apei/erst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 88d0b0f9f92b..1126afeb7e22 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -1168,7 +1168,7 @@ static int __init erst_init(void)
 	r = request_mem_region(erst_erange.base, erst_erange.size, "APEI ERST");
 	if (!r) {
 		pr_err(ERST_PFX
-		"Can not request iomem region <0x%16llx-0x%16llx> for ERST.\n",
+		"Can not request iomem region <0x%016llx-0x%016llx> for ERST.\n",
 		(unsigned long long)erst_erange.base,
 		(unsigned long long)erst_erange.base + erst_erange.size);
 		rc = -EIO;
-- 
1.8.3

