Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab3CHLlF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 06:41:05 -0500
Received: from eumx.net ([91.82.101.43]:54937 "EHLO eumx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3CHLlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 06:41:03 -0500
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Mar 2013 06:41:03 EST
From: Jack Mitchell <ml@communistcode.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jack Mitchell <jack.mitchell@dbbroadcast.co.uk>
Subject: [PATCH] libtraceevent: remove hard coded include to /usr/local/include in Makefile
Date: Fri,  8 Mar 2013 11:21:52 +0000
Message-Id: <1362741712-21308-1-git-send-email-ml@communistcode.co.uk>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Mitchell <jack.mitchell@dbbroadcast.co.uk>

having /usr/local/include hardcoded into the makefile is not necessary as this
is automatically included by GCC. It also infects cross-compile builds with the
host systems includes.

Signed-off-by: Jack Mitchell <jack.mitchell@dbbroadcast.co.uk>
---
 tools/lib/traceevent/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index a20e320..0b0a907 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -122,7 +122,7 @@ export Q VERBOSE
 
 EVENT_PARSE_VERSION = $(EP_VERSION).$(EP_PATCHLEVEL).$(EP_EXTRAVERSION)
 
-INCLUDES = -I. -I/usr/local/include $(CONFIG_INCLUDES)
+INCLUDES = -I. $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -Wall
-- 
1.8.1.5

