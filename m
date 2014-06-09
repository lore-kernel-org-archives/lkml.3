Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaFITVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 15:21:42 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:45558 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699AbaFITVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 15:21:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQNAELxlVNbslom/2dsb2JhbABZgw2sEgUBmRCBEhd1hGAjgRo3iEYBy3EXhV2IK2QdhCsEmiGLKIgdgXyBQjuBMA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH 1/1] drivers/edac/edac_module.c: remove unnecessary test on unsigned value
Date: Mon,  9 Jun 2014 21:20:18 +0200
Message-Id: <1402341618-10674-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned long value is never < 0

Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/edac/edac_module.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/edac_module.c b/drivers/edac/edac_module.c
index a66941f..e6d1691 100644
--- a/drivers/edac/edac_module.c
+++ b/drivers/edac/edac_module.c
@@ -28,7 +28,7 @@ static int edac_set_debug_level(const char *buf, struct kernel_param *kp)
 	if (ret)
 		return ret;
 
-	if (val < 0 || val > 4)
+	if (val > 4)
 		return -EINVAL;
 
 	return param_set_int(buf, kp);
-- 
1.8.4.5

