Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbaKGLZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:25:01 -0500
Received: from dotsec.net ([62.75.224.215]:56366 "EHLO styx.dotsec.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbaKGLY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:24:59 -0500
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 06:24:59 EST
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Alban Bedel <albeu@free.fr>
Subject: [PATCH 1/2] MIPS: FW: Fix parsing u-boot environment
Date: Fri,  7 Nov 2014 12:23:00 +0100
Message-Id: <1415359381-27257-1-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
X-SA-Score: -1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading u-boot's key=value pairs it should skip the '=' and not
use the next argument.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
 arch/mips/fw/lib/cmdline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/fw/lib/cmdline.c b/arch/mips/fw/lib/cmdline.c
index ffd0345..cc5d168 100644
--- a/arch/mips/fw/lib/cmdline.c
+++ b/arch/mips/fw/lib/cmdline.c
@@ -68,7 +68,7 @@ char *fw_getenv(char *envname)
 					result = fw_envp(index + 1);
 					break;
 				} else if (fw_envp(index)[i] == '=') {
-					result = (fw_envp(index + 1) + i);
+					result = (fw_envp(index) + i + 1);
 					break;
 				}
 			}
-- 
2.0.0

