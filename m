Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaJ1AEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:04:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbaJ1AEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:04:46 -0400
From: Alexander Graf <agraf@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Peter Foley <pefoley2@pefoley.com>, afaerber@suse.de
Subject: [PATCH] Documentation: Restrict TSC test code to x86
Date: Tue, 28 Oct 2014 01:03:59 +0100
Message-Id: <1414454639-7491-1-git-send-email-agraf@suse.de>
X-Mailer: git-send-email 1.7.12.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prctl test code in Documentation/ tries to show how to
use a call that only makes sense on x86. Restrict it there
so that other platforms don't try to call asm("rdtsc").

Signed-off-by: Alexander Graf <agraf@suse.de>
---
 Documentation/prctl/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/prctl/Makefile b/Documentation/prctl/Makefile
index 3e3232d..2948b7b 100644
--- a/Documentation/prctl/Makefile
+++ b/Documentation/prctl/Makefile
@@ -1,5 +1,5 @@
 # List of programs to build
-hostprogs-y := disable-tsc-ctxt-sw-stress-test disable-tsc-on-off-stress-test disable-tsc-test
+hostprogs-$(CONFIG_X86) := disable-tsc-ctxt-sw-stress-test disable-tsc-on-off-stress-test disable-tsc-test
 # Tell kbuild to always build the programs
 always := $(hostprogs-y)
 
-- 
2.1.0

