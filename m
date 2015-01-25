Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbbAYNah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:30:37 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57322 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbbAYNab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:30:31 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 2/2] tools/liblockdep: don't include host headers
Date: Sun, 25 Jan 2015 15:30:23 +0200
Message-Id: <8278d003356dba5a3e778c18e94ccef4176fc1ca.1422192349.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <d6ba76fc891265ddb1b4e0fec6c76aac8168ba01.1422192349.git.baruch@tkos.co.il>
References: <d6ba76fc891265ddb1b4e0fec6c76aac8168ba01.1422192349.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding host headers to include path may cause unexpected surprises when cross
compiling. Remove /usr/local/include from the default include path.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 tools/lib/lockdep/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index 52f9279c6c13..4b866c54f624 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -104,7 +104,7 @@ N		=
 
 export Q VERBOSE
 
-INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include -I../../include $(CONFIG_INCLUDES)
+INCLUDES = -I. -I./uinclude -I./include -I../../include $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
-- 
2.1.4

