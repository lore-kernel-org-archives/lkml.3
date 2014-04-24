Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaDXIzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:55:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46884 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaDXIzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: comes@naic.edu, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 129/182] Skip intel_crt_init for Dell XPS 8700
Date: Thu, 24 Apr 2014 09:50:54 +0100
Message-Id: <1398329507-5911-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giacomo Comes <comes@naic.edu>

commit 10b6ee4a87811a110cb01eaca01eb04da6801baf upstream.

The Dell XPS 8700 has a onboard Display port and HDMI port and no VGA port.
The call intel_crt_init freeze the machine, so skip such call.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=73559
Signed-off-by: Giacomo Comes <comes at naic.edu>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_crt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index 6aa6ebd..f88398f 100644
--- a/drivers/gpu/drm/i915/intel_crt.c
+++ b/drivers/gpu/drm/i915/intel_crt.c
@@ -764,6 +764,14 @@ static const struct dmi_system_id intel_no_crt[] = {
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
1.9.1

