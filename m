Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaFEFAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:00:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbaFEEUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.4 060/214] drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi
Date: Wed,  4 Jun 2014 21:17:03 -0700
Message-Id: <20140605041647.553726774@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_acpi.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -375,9 +375,6 @@ bool nouveau_acpi_rom_supported(struct p
 	acpi_status status;
 	acpi_handle dhandle, rom_handle;
 
-	if (!nouveau_dsm_priv.dsm_detected && !nouveau_dsm_priv.optimus_detected)
-		return false;
-
 	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;


