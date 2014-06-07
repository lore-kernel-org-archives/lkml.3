Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaFGBch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36111 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ilia Mirkin" <imirkin@alum.mit.edu>,
        "Ben Skeggs" <bskeggs@redhat.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.1700776@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 45/92] drm/nouveau/acpi: allow non-optimus setups to
 load vbios from acpi
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_acpi.c | 3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -332,9 +332,6 @@ bool nouveau_acpi_rom_supported(struct p
 	acpi_status status;
 	acpi_handle dhandle, rom_handle;
 
-	if (!nouveau_dsm_priv.dsm_detected && !nouveau_dsm_priv.optimus_detected)
-		return false;
-
 	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;

