Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaEBQYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:24:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43703 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaEBPjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 132/151] Skip intel_crt_init for Dell XPS 8700
Date: Fri,  2 May 2014 08:38:40 -0700
Message-Id: <1399045139-4531-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giacomo Comes <comes@naic.edu>

commit 10b6ee4a87811a110cb01eaca01eb04da6801baf upstream.

The Dell XPS 8700 has a onboard Display port and HDMI port and no VGA port.
The call intel_crt_init freeze the machine, so skip such call.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=73559
Signed-off-by: Giacomo Comes <comes at naic.edu>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_crt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_crt.c b/drivers/gpu/drm/i915/intel_crt.c
index b5b1b9b..c48e62d 100644
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

