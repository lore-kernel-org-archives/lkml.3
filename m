Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3GNLCS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 07:02:18 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:51455 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab3GNLCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 07:02:17 -0400
Message-ID: <1373799735.1370.5.camel@x61.thuisdomein>
Subject: [PATCH] powerpc/pseries: drop "select HOTPLUG"
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Sun, 14 Jul 2013 13:02:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2013 11:02:15.0750 (UTC) FILETIME=[99A9C660:01CE8081]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol HOTPLUG was removed with commit 40b313608a ("Finally
eradicate CONFIG_HOTPLUG"). But there's still one select statement for
that symbol. It seems that select statement was added after the patch to
remove CONFIG_HOTPLUG was submitted. Anyhow, it is useless and can be
dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Not tested.

 arch/powerpc/platforms/pseries/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index 1bd3399..62b4f80 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -19,7 +19,6 @@ config PPC_PSERIES
 	select ZLIB_DEFLATE
 	select PPC_DOORBELL
 	select HAVE_CONTEXT_TRACKING
-	select HOTPLUG if SMP
 	select HOTPLUG_CPU if SMP
 	default y
 
-- 
1.8.1.4

