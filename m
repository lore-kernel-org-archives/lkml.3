Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3CRQZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:25:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49290
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab3CRQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:53 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/54] perf tools: Correct Makefile.include
Date: Mon, 18 Mar 2013 13:24:49 -0300
Message-Id: <1363623939-10748-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

It looks at O= and adjusts the $(OUTPUT) variable based on what the
output directory will be. However, when O is defined but empty, it
wrongly becomes the user's $HOME dir which is not what we want. So check
it is not empty before working with it further.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-4-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/scripts/Makefile.include |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 00a05f4..f03e681 100644
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
1.7.1

