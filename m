Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162412Ab3LFNOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:14:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162039Ab3LFNFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatolij Gustschin <agust@denx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 238/272] powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module
Date: Fri,  6 Dec 2013 12:58:47 +0000
Message-Id: <1386334761-25517-239-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit 2bf75084f6d9f9a91ba6e30a501ff070d8a1acf6 upstream.

The MPC5200 LPBFIFO driver requires the bestcomm module to be
enabled, otherwise building will fail. Fix it.

Reported-by: Wolfgang Denk <wd@denx.de>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/52xx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/52xx/Kconfig b/arch/powerpc/platforms/52xx/Kconfig
index 90f4496..af54174 100644
--- a/arch/powerpc/platforms/52xx/Kconfig
+++ b/arch/powerpc/platforms/52xx/Kconfig
@@ -57,5 +57,5 @@ config PPC_MPC5200_BUGFIX
 
 config PPC_MPC5200_LPBFIFO
 	tristate "MPC5200 LocalPlus bus FIFO driver"
-	depends on PPC_MPC52xx
+	depends on PPC_MPC52xx && PPC_BESTCOMM
 	select PPC_BESTCOMM_GEN_BD
-- 
1.8.3.2

