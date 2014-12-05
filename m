Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaLEWvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:51:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbaLEWvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:51:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 108/122] drm/radeon: disable native backlight control on pre-r6xx asics (v2)
Date: Fri,  5 Dec 2014 14:44:42 -0800
Message-Id: <20141205223322.368751510@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit b7bc596ebbe0cddc97d76ef9309f64471bbf13eb upstream.

Just use the acpi interface.  That's what windows uses on this
generation and it's the only thing that seems to work reliably
on these generation parts.

You can still force the native backlight interface by setting
radeon.backlight=1

Bug:
https://bugzilla.kernel.org/show_bug.cgi?id=88501

v2: merge into above if/else block

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_encoders.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -179,6 +179,9 @@ static void radeon_encoder_add_backlight
 		    (rdev->pdev->subsystem_vendor == 0x1734) &&
 		    (rdev->pdev->subsystem_device == 0x1107))
 			use_bl = false;
+		/* disable native backlight control on older asics */
+		else if (rdev->family < CHIP_R600)
+			use_bl = false;
 		else
 			use_bl = true;
 	}


