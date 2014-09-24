Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaIXTVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:21:55 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:62359 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbaIXTVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:21:53 -0400
Message-ID: <1411586511.19525.38.camel@x220>
Subject: [PATCH] Hexagon: Remove useless select of NO_IOPORT_MAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2014 21:21:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Sep 2014 19:21:52.0271 (UTC) FILETIME=[CB94A1F0:01CFD82C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hexagon's primary Kconfig entry has a select for NO_IOPORT_MAP. But
because hexagon never defines a Kconfig symbol NO_IOPORT_MAP this select
is a nop. It can be removed.

Perhaps hexagon should add its own Kconfig entry for NO_IOPORT_MAP and
have it default to 'y'. But since no one apparently had any problems
with HAS_IOPORT_MAP defaulting to 'y' on hexagon, as it currently does,
that is unlikely.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested by playing with arch/hexagon/configs/comet_defconfig. After "make
oldconfig" the .config contains CONFIG_HAS_IOPORT_MAP=y both before and
after this patch, as is expected.

Actually, the only difference I found in the .config file was that after
this patch the .config file contained
    CONFIG_HEXAGON=y

I have no idea why. Did I botch my test?

 arch/hexagon/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 4dc89d1f9c48..f1817eae107a 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -19,7 +19,6 @@ config HEXAGON
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
-	select NO_IOPORT_MAP
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select STACKTRACE_SUPPORT
-- 
1.9.3

