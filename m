Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbaD2OI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:08:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbaD2OIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:08:25 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 2/5] firmware: Use $(quote) in the Makefile
Date: Tue, 29 Apr 2014 16:08:10 +0200
Message-Id: <1398780493-15391-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The literal " confuses syntax highlighting in vim.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 firmware/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/firmware/Makefile b/firmware/Makefile
index 6af62cf..5747417 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -4,10 +4,10 @@
 
 # Create $(fwabs) from $(CONFIG_EXTRA_FIRMWARE_DIR) -- if it doesn't have a
 # leading /, it's relative to $(srctree).
-fwdir := $(subst ",,$(CONFIG_EXTRA_FIRMWARE_DIR))
+fwdir := $(subst $(quote),,$(CONFIG_EXTRA_FIRMWARE_DIR))
 fwabs := $(addprefix $(srctree)/,$(filter-out /%,$(fwdir)))$(filter /%,$(fwdir))
 
-fw-external-y := $(subst ",,$(CONFIG_EXTRA_FIRMWARE))
+fw-external-y := $(subst $(quote),,$(CONFIG_EXTRA_FIRMWARE))
 
 # There are three cases to care about:
 # 1. Building kernel with CONFIG_FIRMWARE_IN_KERNEL=y -- $(fw-shipped-y) should
-- 
1.9.2

