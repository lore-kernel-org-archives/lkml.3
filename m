Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201Ab3K0Boz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:44:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab3K0A5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfgang Denk <wd@denx.de>, Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 3.10 65/80] powerpc/52xx: fix build breakage for MPC5200 LPBFIFO module
Date: Tue, 26 Nov 2013 16:57:34 -0800
Message-Id: <20131127005645.449969540@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit 2bf75084f6d9f9a91ba6e30a501ff070d8a1acf6 upstream.

The MPC5200 LPBFIFO driver requires the bestcomm module to be
enabled, otherwise building will fail. Fix it.

Reported-by: Wolfgang Denk <wd@denx.de>
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/52xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/52xx/Kconfig
+++ b/arch/powerpc/platforms/52xx/Kconfig
@@ -57,5 +57,5 @@ config PPC_MPC5200_BUGFIX
 
 config PPC_MPC5200_LPBFIFO
 	tristate "MPC5200 LocalPlus bus FIFO driver"
-	depends on PPC_MPC52xx
+	depends on PPC_MPC52xx && PPC_BESTCOMM
 	select PPC_BESTCOMM_GEN_BD


