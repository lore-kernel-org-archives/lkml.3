Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaF3RjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 13:39:13 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:2402 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754569AbaF3RjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 13:39:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsJAEOgsVNbtAo1/2dsb2JhbABagw2sQQUBAQEBAQEFAW4BkgaHQIERF3WECwJTI4EJETeIRgHIP4VkiSMdhC0Fj3qHeoJqiz+IPoNEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Chris Wright <chrisw@sous-sol.org>,
        virtualization@lists.linux-foundation.org, linux-ia64@vger.kernel.org
Subject: [PATCH 1/1] ia64: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Mon, 30 Jun 2014 19:37:34 +0200
Message-Id: <1404149854-7382-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use macro definition

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: virtualization@lists.linux-foundation.org
Cc: linux-ia64@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 arch/ia64/kernel/paravirt.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/paravirt.c b/arch/ia64/kernel/paravirt.c
index 1b22f6d..17bb2d1 100644
--- a/arch/ia64/kernel/paravirt.c
+++ b/arch/ia64/kernel/paravirt.c
@@ -864,8 +864,7 @@ __initdata_or_module =
 unsigned long __init_or_module
 ia64_native_patch_bundle(void *sbundle, void *ebundle, unsigned long type)
 {
-	const unsigned long nelems = sizeof(ia64_native_patch_bundle_elems) /
-		sizeof(ia64_native_patch_bundle_elems[0]);
+	const unsigned long nelems = ARRAY_SIZE(ia64_native_patch_bundle_elems);
 
 	return __paravirt_patch_apply_bundle(sbundle, ebundle, type,
 					      ia64_native_patch_bundle_elems,
@@ -894,9 +893,8 @@ __initconst = {
 static void __init
 ia64_native_patch_branch(unsigned long tag, unsigned long type)
 {
-	const unsigned long nelem =
-		sizeof(ia64_native_branch_target) /
-		sizeof(ia64_native_branch_target[0]);
+	const unsigned long nelem = ARRAY_SIZE(ia64_native_branch_target);
+
 	__paravirt_patch_apply_branch(tag, type,
 				      ia64_native_branch_target, nelem);
 }
-- 
1.8.4.5

