Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760344AbaEMJaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:30:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33207 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759367AbaEMJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:29:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Giacomo Comes <comes@naic.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 170/182] Skip intel_crt_init for Dell XPS 8700
Date: Tue, 13 May 2014 11:28:42 +0200
Message-Id: <2bb309346ea9ff4387b8487d1a625e14014c0061.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giacomo Comes <comes@naic.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 10b6ee4a87811a110cb01eaca01eb04da6801baf upstream.

The Dell XPS 8700 has a onboard Display port and HDMI port and no VGA port.
The call intel_crt_init freeze the machine, so skip such call.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=73559
Signed-off-by: Giacomo Comes <comes at naic.edu>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/intel_crt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index 10d1de5bce6f..e8edbb751e9a 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -758,6 +758,14 @@ static const struct dmi_system_id intel_no_crt[] = {
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
 
-- 
1.9.3

