Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaJ0Txu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:53:50 -0400
Received: from hofr.at ([212.69.189.236]:54344 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbaJ0Txt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:53:49 -0400
Date: Mon, 27 Oct 2014 20:53:47 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Randy Dunlap <rdunlap@infradead.org>, Michal Marek <mmarek@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4 v2] limit _shipped to c h and S files
Message-ID: <20141027195347.GE10079@opentech.at>
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
and can not be reasonably moved to to a loadable firmware. 

This patch is against linux 3.18.0-rc1

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 scripts/Makefile.lib |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 54be19a..d94c3a9 100644
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

