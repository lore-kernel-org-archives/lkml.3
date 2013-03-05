Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3CEUnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:43:49 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:58525 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757538Ab3CEUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:43:48 -0500
Message-ID: <1362516222.16460.121.camel@x61.thuisdomein>
Subject: [PATCH] arm64: Do not select GENERIC_HARDIRQS_NO_DEPRECATED
From: Paul Bolle <pebolle@tiscali.nl>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 21:43:42 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 20:43:42.0856 (UTC) FILETIME=[1FE27080:01CE19E2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Config option GENERIC_HARDIRQS_NO_DEPRECATED was removed in commit
78c89825649a9a5ed526c507603196f467d781a5 ("genirq: Remove the now obsolete
config options and select statements"), but the select was accidentally
reintroduced in commit 8c2c3df31e3b87cb5348e48776c366ebd1dc5a7a ("arm64:
Build infrastructure").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Commit explanation inspired by commit
2c7d1644406748d7c5da7b9db3c5080296af55bf ("sparc: Do not select
GENERIC_HARDIRQS_NO_DEPRECATED").

 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index fd70a68..9b6d19f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -9,7 +9,6 @@ config ARM64
 	select CLONE_BACKWARDS
 	select COMMON_CLK
 	select GENERIC_CLOCKEVENTS
-	select GENERIC_HARDIRQS_NO_DEPRECATED
 	select GENERIC_IOMAP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
-- 
1.7.11.7

