Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934194AbaEKTe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:34:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911AbaEKT0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.10 42/48] Skip intel_crt_init for Dell XPS 8700
Date: Sun, 11 May 2014 21:20:16 +0200
Message-Id: <20140511191953.762160746@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giacomo Comes <comes@naic.edu>

commit 10b6ee4a87811a110cb01eaca01eb04da6801baf upstream.

The Dell XPS 8700 has a onboard Display port and HDMI port and no VGA port.
The call intel_crt_init freeze the machine, so skip such call.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=73559
Signed-off-by: Giacomo Comes <comes at naic.edu>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_crt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -717,6 +717,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
 		},
 	},
+	{
+		.callback = intel_no_crt_dmi_callback,
+		.ident = "DELL XPS 8700",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS 8700"),
+		},
+	},
 	{ }
 };
 


