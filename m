Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935752Ab3BTPck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:32:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50993 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934219Ab3BTPci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:32:38 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 3/7] perf: Correct Makefile.include
Date: Wed, 20 Feb 2013 16:32:29 +0100
Message-Id: <1361374353-30385-4-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1361374353-30385-1-git-send-email-bp@alien8.de>
References: <1361374353-30385-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It looks at O= and adjusts the $(OUTPUT) variable based on what the
output directory will be. However, when O is defined but empty, it
wrongly becomes the user's $HOME dir which is not what we want. So check
it is not empty before working with it further.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/scripts/Makefile.include | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 00a05f45b39a..f03e681f8891 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -1,3 +1,4 @@
+ifneq ($(O),)
 ifeq ($(origin O), command line)
 	dummy := $(if $(shell test -d $(O) || echo $(O)),$(error O=$(O) does not exist),)
 	ABSOLUTE_O := $(shell cd $(O) ; pwd)
@@ -7,9 +8,10 @@ ifeq ($(objtree),)
 	objtree := $(O)
 endif
 endif
+endif
 
-ifneq ($(OUTPUT),)
 # check that the output directory actually exists
+ifneq ($(OUTPUT),)
 OUTDIR := $(shell cd $(OUTPUT) && /bin/pwd)
 $(if $(OUTDIR),, $(error output directory "$(OUTPUT)" does not exist))
 endif
-- 
1.8.1.3.535.ga923c31

