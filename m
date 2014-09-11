Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbaIKNAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:00:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51533 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755386AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.392948276@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 108/131] sparc64: Fix argument sign extension for 
 compat_sys_futex().
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit aa3449ee9c87d9b7660dd1493248abcc57769e31 ]

Only the second argument, 'op', is signed.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/kernel/sys32.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/sys32.S b/arch/sparc/kernel/sys32.S
index d97f3eb..085c60f 100644
--- a/arch/sparc/kernel/sys32.S
+++ b/arch/sparc/kernel/sys32.S
@@ -87,7 +87,7 @@ SIGN1(sys32_io_submit, compat_sys_io_submit, %o1)
 SIGN1(sys32_mq_open, compat_sys_mq_open, %o1)
 SIGN1(sys32_select, compat_sys_select, %o0)
 SIGN1(sys32_mkdir, sys_mkdir, %o1)
-SIGN3(sys32_futex, compat_sys_futex, %o1, %o2, %o5)
+SIGN1(sys32_futex, compat_sys_futex, %o1)
 SIGN1(sys32_sysfs, compat_sys_sysfs, %o0)
 SIGN2(sys32_sendfile, compat_sys_sendfile, %o0, %o1)
 SIGN2(sys32_sendfile64, compat_sys_sendfile64, %o0, %o1)

