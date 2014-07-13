Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaGMSoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 14:44:01 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:60634 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaGMSn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 14:43:27 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/6] samples: refactor Makefile
Date: Sun, 13 Jul 2014 20:42:50 +0200
Message-Id: <1405276974-17323-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
References: <20140713183636.GA17241@ravnborg.org>
 <1405276974-17323-1-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one line per module/program in Makefile.
This style is easier to read/extend.

Introduce inverse xmas style sorting.
This may prevent some merge conflicts in the future

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 samples/Makefile | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 1a60c62..7c08028 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -1,4 +1,15 @@
 # Makefile for Linux samples code
+# Sort entries using inverse xmas style
+#
+# kernel modules
+obj-$(CONFIG_SAMPLES) += hw_breakpoint/
+obj-$(CONFIG_SAMPLES) += trace_events/
+obj-$(CONFIG_SAMPLES) += kprobes/
+obj-$(CONFIG_SAMPLES) += kobject/
+obj-$(CONFIG_SAMPLES) += kfifo/
+obj-$(CONFIG_SAMPLES) += rpmsg/
+obj-$(CONFIG_SAMPLES) += kdb/
 
-obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ \
-			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/
+# user space programs
+obj-$(CONFIG_SAMPLES) += seccomp/
+obj-$(CONFIG_SAMPLES) += hidraw/
-- 
1.9.3

