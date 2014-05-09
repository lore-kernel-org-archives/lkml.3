Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbaEIMwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:52:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaEIMwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:52:39 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 2/5] firmware: Use $(quote) in the Makefile
Date: Fri,  9 May 2014 14:52:21 +0200
Message-Id: <1399639944-20551-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The literal " confuses syntax highlighting in vim.

Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
v1->v2: No changes

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
1.8.4.5

