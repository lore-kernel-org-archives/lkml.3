Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965740AbaGRNOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:14:01 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17716 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030743AbaGRNN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:13:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 078/170] vgaswitcheroo: switch the mux to the igp on power down when runpm is enabled
Date: Fri, 18 Jul 2014 14:11:23 +0200
Message-Id: <b7f5767932e6c8fc33f8b6961511fdafcf827e42.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f2bc561610962693be61425cf913778586d8f9c1 upstream.

Avoids blank screens on muxed systems when runpm is active.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=75917

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/vga/vga_switcheroo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index ec0ae2d1686a..6866448083b2 100644
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
2.0.0

