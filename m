Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbaFMJkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:40:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaFMJkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:40:16 -0400
From: Michal Marek <mmarek@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: Do not run modules_install and install in paralel
Date: Fri, 13 Jun 2014 11:39:55 +0200
Message-Id: <1402652395-28779-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <CALCETrWSX1nVqyfe0Ee2rUvpHosTRyW8GSJfr52UCpT566-eWA@mail.gmail.com>
References: <CALCETrWSX1nVqyfe0Ee2rUvpHosTRyW8GSJfr52UCpT566-eWA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on a x86-only patch by Andy Lutomirski <luto@amacapital.net>

With modular kernels, 'make install' is going to need the installed
modules at some point to generate the initramfs.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Makefile b/Makefile
index 7680d7c..7e5e483 100644
--- a/Makefile
+++ b/Makefile
@@ -503,6 +503,12 @@ ifeq ($(KBUILD_EXTMOD),)
                 endif
         endif
 endif
+# install and module_install need also be processed one by one
+ifneq ($(filter install,$(MAKECMDGOALS)),)
+        ifneq ($(filter modules_install,$(MAKECMDGOALS)),)
+	        mixed-targets := 1
+        endif
+endif
 
 ifeq ($(mixed-targets),1)
 # ===========================================================================
-- 
1.9.2

