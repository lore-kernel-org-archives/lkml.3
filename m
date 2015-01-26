Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbbAZKcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:32:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbbAZKcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:32:05 -0500
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] DocBook: Do not exceed argument list limit
Date: Mon, 26 Jan 2015 11:31:17 +0100
Message-Id: <1422268277-5333-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use find + xargs to compress the generated manpages. Without this patch,
the build can fail with

    gzip -f Documentation/DocBook/man/*.9
    /bin/bash: /usr/bin/gzip: Argument list too long

This happened with qemu user mode emulation on aarch64.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Documentation/DocBook/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 9c7d92d..b6a6a2e 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -56,7 +56,7 @@ htmldocs: $(HTML)
 
 MAN := $(patsubst %.xml, %.9, $(BOOKS))
 mandocs: $(MAN)
-	$(if $(wildcard $(obj)/man/*.9),gzip -f $(obj)/man/*.9)
+	find $(obj)/man -name '*.9' | xargs gzip -f
 
 installmandocs: mandocs
 	mkdir -p /usr/local/man/man9/
-- 
2.1.2

