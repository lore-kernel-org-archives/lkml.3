Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3KLSYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:24:40 -0500
Received: from alt-proxy24.mail.unifiedlayer.com ([69.89.16.13]:36582 "HELO
	alt-proxy24.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751972Ab3KLSYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:24:36 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2013 13:24:36 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
Subject: [PATCH] x86/early quirk: use gen6 stolen detection for VLV
Date: Tue, 12 Nov 2013 10:17:39 -0800
Message-Id: <1384280259-800-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.8.4.2
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've always been able to use either method on VLV, but it appears more
recent BIOSes only support the gen6 method, so switch over to that.

References: https://bugs.freedesktop.org/show_bug.cgi?id=71370
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/kernel/early-quirks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 96f958d..bc4a088 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -330,8 +330,8 @@ static struct pci_device_id intel_stolen_ids[] __initdata = {
 	INTEL_I915GM_IDS(gen3_stolen_size),
 	INTEL_I945G_IDS(gen3_stolen_size),
 	INTEL_I945GM_IDS(gen3_stolen_size),
-	INTEL_VLV_M_IDS(gen3_stolen_size),
-	INTEL_VLV_D_IDS(gen3_stolen_size),
+	INTEL_VLV_M_IDS(gen6_stolen_size),
+	INTEL_VLV_D_IDS(gen6_stolen_size),
 	INTEL_PINEVIEW_IDS(gen3_stolen_size),
 	INTEL_I965G_IDS(gen3_stolen_size),
 	INTEL_G33_IDS(gen3_stolen_size),
-- 
1.8.4.2

