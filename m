Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788AbaFII6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58555 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932172AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ilia Mirkin <imirkin@alum.mit.edu>,
        Ben Skeggs <bskeggs@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 078/146] drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi
Date: Mon,  9 Jun 2014 10:50:13 +0200
Message-Id: <00a54adad8dd6f044acf8e8e494650c1c6c8a93f.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ilia Mirkin <imirkin@alum.mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a3d0b1218d351c6e6f3cea36abe22236a08cb246 upstream.

There appear to be a crop of new hardware where the vbios is not
available from PROM/PRAMIN, but there is a valid _ROM method in ACPI.
The data read from PCIROM almost invariably contains invalid
instructions (still has the x86 opcodes), which makes this a low-risk
way to try to obtain a valid vbios image.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76475
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 200e8564c59d..efdb689024e3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -419,9 +419,6 @@ bool nouveau_acpi_rom_supported(struct pci_dev *pdev)
 	acpi_status status;
 	acpi_handle dhandle, rom_handle;
 
-	if (!nouveau_dsm_priv.dsm_detected && !nouveau_dsm_priv.optimus_detected)
-		return false;
-
 	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
-- 
1.9.3

