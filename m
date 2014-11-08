Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaKHLkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 06:40:08 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:52817 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbaKHLkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 06:40:06 -0500
From: Alban Bedel <albeu@free.fr>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        Alban Bedel <albeu@free.fr>
Subject: [PATCH v2 1/2] MIPS: FW: Fix parsing u-boot environment
Date: Sat,  8 Nov 2014 12:39:38 +0100
Message-Id: <1415446779-11984-1-git-send-email-albeu@free.fr>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When reading u-boot's key=value pairs it should skip the '=' and not
use the next argument.

Signed-off-by: Alban Bedel <albeu@free.fr>
---
v2: * Removed the useless outer parenthesis
---
 arch/mips/fw/lib/cmdline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/fw/lib/cmdline.c b/arch/mips/fw/lib/cmdline.c
index ffd0345..a0c361e 100644
--- a/arch/mips/fw/lib/cmdline.c
+++ b/arch/mips/fw/lib/cmdline.c
@@ -68,7 +68,7 @@ char *fw_getenv(char *envname)
 					result = fw_envp(index + 1);
 					break;
 				} else if (fw_envp(index)[i] == '=') {
-					result = (fw_envp(index + 1) + i);
+					result = fw_envp(index) + i + 1;
 					break;
 				}
 			}
-- 
2.0.0

