Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964932Ab3DHVBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:01:47 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:65061 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935536Ab3DHVBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:01:45 -0400
Message-ID: <1365454902.1830.138.camel@x61.thuisdomein>
Subject: [PATCH] arch/ia64/xen: remove "config NO_IDLE_HZ"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 23:01:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 21:01:42.0318 (UTC) FILETIME=[4556C4E0:01CE349C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol NO_IDLE_HZ, and its last users, were removed in
v2.6.27. It popped up again, for some reason, in the Kconfig file for
Xen on ia64 in v2.6.28. Remove it from that file now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/ia64/xen/Kconfig | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/ia64/xen/Kconfig b/arch/ia64/xen/Kconfig
index 5d8a06b..592999e 100644
--- a/arch/ia64/xen/Kconfig
+++ b/arch/ia64/xen/Kconfig
@@ -7,7 +7,6 @@ config XEN
 	default y
 	depends on PARAVIRT && MCKINLEY && IA64_PAGE_SIZE_16KB
 	select XEN_XENCOMM
-	select NO_IDLE_HZ
 	# followings are required to save/restore.
 	select ARCH_SUSPEND_POSSIBLE
 	select SUSPEND
@@ -19,7 +18,3 @@ config XEN
 config XEN_XENCOMM
 	depends on XEN
 	bool
-
-config NO_IDLE_HZ
-	depends on XEN
-	bool
-- 
1.7.11.7

