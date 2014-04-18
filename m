Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaDRJXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:23:54 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45905 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Adam Jackson <ajax@redhat.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 21/72] fbdev: Make the switch from generic to native driver less alarming
Date: Fri, 18 Apr 2014 11:21:54 +0200
Message-Id: <aa66ee9749278e793e720037937c66c4d96c7517.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Jackson <ajax@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 13ba0ad4490c3dd08b15c430a7a01c6fb45d5bce upstream.

Calling this "conflicting" just makes people think there's a problem
when there's not.

Signed-off-by: Adam Jackson <ajax@redhat.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/fbmem.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 7309ac704e26..b6d5008f361f 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1596,8 +1596,7 @@ static int do_remove_conflicting_framebuffers(struct apertures_struct *a,
 			(primary && gen_aper && gen_aper->count &&
 			 gen_aper->ranges[0].base == VGA_FB_PHYS)) {
 
-			printk(KERN_INFO "fb: conflicting fb hw usage "
-			       "%s vs %s - removing generic driver\n",
+			printk(KERN_INFO "fb: switching to %s from %s\n",
 			       name, registered_fb[i]->fix.id);
 			ret = do_unregister_framebuffer(registered_fb[i]);
 			if (ret)
-- 
1.9.2

