Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934880Ab3GWW15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934848Ab3GWW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 085/103] drm/radeon: add backlight quirk for hybrid mac
Date: Tue, 23 Jul 2013 15:26:36 -0700
Message-Id: <20130723220430.128040523@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 80101790670385a85aca35ecae4b89e3f2fceecc upstream.

Mac laptops with multiple GPUs apparently use the gmux
driver for backlight control.  Don't register a radeon
backlight interface.  We may need to add other pci ids
for other hybrid mac laptops.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=65377

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_encoders.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -186,6 +186,13 @@ void radeon_atom_backlight_init(struct r
 	u8 backlight_level;
 	char bl_name[16];
 
+	/* Mac laptops with multiple GPUs use the gmux driver for backlight
+	 * so don't register a backlight device
+	 */
+	if ((rdev->pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE) &&
+	    (rdev->pdev->device == 0x6741))
+		return;
+
 	if (!radeon_encoder->enc_priv)
 		return;
 


