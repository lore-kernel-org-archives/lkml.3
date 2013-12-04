Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3LDN0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:26:01 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:52280 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3LDNZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:25:59 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r7Vwc9HJaQ=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] Tools: hv: remove inclusion of linux/types.h
Date: Wed,  4 Dec 2013 14:25:55 +0100
Message-Id: <1386163555-20935-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With very old libc headers the inclusion of sys/types.h causes conflicts
with linux/types.h. Since the latter is not required anyway, remove it
from the source files. If any of the headers really needs linux/types.h
it has to include it itself.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_kvp_daemon.c | 1 -
 tools/hv/hv_vss_daemon.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index b8d6d54..4088b81 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -26,7 +26,6 @@
 #include <sys/socket.h>
 #include <sys/poll.h>
 #include <sys/utsname.h>
-#include <linux/types.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 8bcb040..520de3304 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -22,7 +22,6 @@
 #include <sys/socket.h>
 #include <sys/poll.h>
 #include <sys/ioctl.h>
-#include <linux/types.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <mntent.h>
