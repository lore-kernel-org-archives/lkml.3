Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3KAORK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:17:10 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:64022 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab3KAORJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:17:09 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd] Makefile: Ensure _GNU_SOURCE really is always defined
Date: Fri,  1 Nov 2013 09:17:00 -0500
Message-Id: <1383315420-11690-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CLFAGS is set with a command argument a normal variable
assignment is not sufficient to ensure that _GNU_SOURCE will be
defined. Since this really is critical for building, use an
override directive when adding it to CFLAGS to ensure that it
really does get defined in all cases.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 1d613c4..a2ba385 100644
--- a/Makefile
+++ b/Makefile
@@ -223,7 +223,7 @@ CFLAGS ?= -g -Wall
 LDFLAGS ?=
 
 # Required CFLAGS
-CFLAGS += -D_GNU_SOURCE
+override CFLAGS += -D_GNU_SOURCE
 
 ifndef NO_PTRACE
 ifneq ($(call try-cc,$(SOURCE_PTRACE),),y)
-- 
1.8.3.2

