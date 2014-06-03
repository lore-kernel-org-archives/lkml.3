Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaFCMWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:22:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43252 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbaFCLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:14 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 014/138] drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi
Date: Tue,  3 Jun 2014 12:37:40 +0100
Message-Id: <1401795584-22664-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit a3d0b1218d351c6e6f3cea36abe22236a08cb246 upstream.

There appear to be a crop of new hardware where the vbios is not
available from PROM/PRAMIN, but there is a valid _ROM method in ACPI.
The data read from PCIROM almost invariably contains invalid
instructions (still has the x86 opcodes), which makes this a low-risk
way to try to obtain a valid vbios image.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76475
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index d97f20069d3e..5cec3a0c6c85 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -372,9 +372,6 @@ bool nouveau_acpi_rom_supported(struct pci_dev *pdev)
 	acpi_status status;
 	acpi_handle dhandle, rom_handle;
 
-	if (!nouveau_dsm_priv.dsm_detected && !nouveau_dsm_priv.optimus_detected)
-		return false;
-
 	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
-- 
1.9.1

