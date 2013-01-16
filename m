Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3APQ0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:26:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36698 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568Ab3APQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Myron Stowe <myron.stowe@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 172/222] PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI check)
Date: Wed, 16 Jan 2013 13:56:12 -0200
Message-Id: <1358351822-7675-173-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myron Stowe <myron.stowe@redhat.com>

commit 1278998f8ff6d66044ed00b581bbf14aacaba215 upstream.

Commit 284f5f9 was intended to disable the "only_one_child()" optimization
on Stratus ftServer systems, but its DMI check is wrong.  It looks for
DMI_SYS_VENDOR that contains "ftServer", when it should look for
DMI_SYS_VENDOR containing "Stratus" and DMI_PRODUCT_NAME containing
"ftServer".

Tested on Stratus ftServer 6400.

Reported-by: Fadeeva Marina <astarta@rat.ru>
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=51331
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/pci/common.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 0ad990a..dd3b583 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -433,7 +433,8 @@ static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
 		.callback = set_scan_all,
 		.ident = "Stratus/NEC ftServer",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ftServer"),
+			DMI_MATCH(DMI_SYS_VENDOR, "Stratus"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ftServer"),
 		},
 	},
 	{}
-- 
1.7.9.5

