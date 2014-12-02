Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaLBJWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:22:21 -0500
Received: from hofr.at ([212.69.189.236]:53605 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaLBJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:22:18 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 04:22:17 EST
Date: Tue, 2 Dec 2014 10:16:21 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Michal Marek <mmarek@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] limit _shipped to c h and S files
Message-ID: <20141202091621.GE13909@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


limit _shipped to c h and S files

_shipped targets are intended for generated source files which should
not permit .o binary blobs which is currently the case. This patch
simply restricts _shipped targets to .c, .h and .S files.

A special case for .inc_shipped is added to prevent breaking
drivers/net/wan/wanxlfw.inc_shipped which is a historic "firmware"
and can not be reasonably moved to a loadable firmware.

This patch is against linux 3.18.0-rc6

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 scripts/Makefile.lib |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 5117552..dd02bb9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -216,7 +216,17 @@ endif
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
+	$(call cmd,shipped)
+
+$(obj)/%.inc: $(src)/%.inc_shipped
+	@echo '  INFO: use of .inc_shipped files is deprecated'
 	$(call cmd,shipped)
 
 # Commands useful for building a boot image
-- 
1.7.10.4

