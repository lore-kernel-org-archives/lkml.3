Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaL0PVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:21:42 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:50773 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750748AbaL0PVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:21:38 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4PAL7NnlRbsnvc/2dsb2JhbABcgwaBKrQbBQEBAQEBAQUBd5c2gQgXAQEBAQF9hGkjgRo3iDABuWqPISyGA4kQZB2EEwWXCJFQIoFFgio9MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1 linux-next] drm/nouveau/disp: replace 0x0000 by NULL for pointer
Date: Sat, 27 Dec 2014 16:21:32 +0100
Message-Id: <1419693692-32161-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:
drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c:
815:32: warning: Using plain integer as NULL pointer

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c b/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
index 181a2d5..e5ba510 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/nvd0.c
@@ -812,7 +812,7 @@ exec_lookup(struct nv50_disp_priv *priv, int head, int or, u32 ctrl,
 		case 0x00000900: type = DCB_OUTPUT_DP; mask = 2; break;
 		default:
 			nv_error(priv, "unknown SOR mc 0x%08x\n", ctrl);
-			return 0x0000;
+			return NULL;
 		}
 	}
 
-- 
2.1.0

