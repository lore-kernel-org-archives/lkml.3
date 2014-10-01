Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaJANhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:37:01 -0400
Received: from hofr.at ([212.69.189.236]:47537 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaJANhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:37:00 -0400
Date: Wed, 1 Oct 2014 15:36:59 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] limit _shipped to c,h and S files
Message-ID: <20141001133659.GC5560@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


limit _shipped to c,h and S files

_shipped targets are intended for generated source files which should
not permit .o binary blobs which is currently the case. This patch
simply restricts _shipped targets to .c, .h and .S files.

Note that this patch breaks the handline of drivers/net/wan/wanxlfw.inc_shipped
which probably really should be moved to a loadable firmware and use
request_firmware - a short term fix could be to move it to a .h file.

This patch is against linux 3.17.0-rc6

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 scripts/Makefile.lib |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 260bf8a..adc4acb 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -207,7 +207,13 @@ endif
 quiet_cmd_shipped = SHIPPED $@
 cmd_shipped = cat $< > $@
 
-$(obj)/%: $(src)/%_shipped
+$(obj)/%.c: $(src)/%.c_shipped
+	$(call cmd,shipped)
+
+$(obj)/%.h: $(src)/%.h_shipped
+	$(call cmd,shipped)
+
+$(obj)/%.S: $(src)/%.S_shipped
 	$(call cmd,shipped)
 
 # Commands useful for building a boot image
-- 
1.7.10.4

