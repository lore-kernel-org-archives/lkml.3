Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbaGOWRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:17:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54239 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622AbaGOVeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:34:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 082/198] vgaswitcheroo: switch the mux to the igp on power down when runpm is enabled
Date: Tue, 15 Jul 2014 14:29:12 -0700
Message-Id: <1405459868-15089-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f2bc561610962693be61425cf913778586d8f9c1 upstream.

Avoids blank screens on muxed systems when runpm is active.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75917

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/vga/vga_switcheroo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index ec0ae2d..6866448 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -623,7 +623,8 @@ static int vga_switcheroo_runtime_suspend(struct device *dev)
 	ret = dev->bus->pm->runtime_suspend(dev);
 	if (ret)
 		return ret;
-
+	if (vgasr_priv.handler->switchto)
+		vgasr_priv.handler->switchto(VGA_SWITCHEROO_IGD);
 	vga_switcheroo_power_switch(pdev, VGA_SWITCHEROO_OFF);
 	return 0;
 }
-- 
1.9.1

