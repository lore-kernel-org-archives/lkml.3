Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800Ab3CLWlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:41:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3CLWd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [ 078/100] x86/kvm: Fix pvclock vsyscall fixmap
Date: Tue, 12 Mar 2013 15:32:03 -0700
Message-Id: <20130312223131.322574387@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit 3d2a80a230250c2534ce5b17503670adaf1d7fff upstream.

The physical memory fixmapped for the pvclock clock_gettime vsyscall
was allocated, and thus is not a kernel symbol. __pa() is the proper
method to use in this case.

Fixes the crash below when booting a next-20130204+ smp guest on a
3.8-rc5+ KVM host.

[    0.666410] udevd[97]: starting version 175
[    0.674043] udevd[97]: udevd:[97]: segfault at ffffffffff5fd020
     ip 00007fff069e277f sp 00007fff068c9ef8 error d

Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/pvclock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -185,7 +185,7 @@ int __init pvclock_init_vsyscall(struct
 
 	for (idx = 0; idx <= (PVCLOCK_FIXMAP_END-PVCLOCK_FIXMAP_BEGIN); idx++) {
 		__set_fixmap(PVCLOCK_FIXMAP_BEGIN + idx,
-			     __pa_symbol(i) + (idx*PAGE_SIZE),
+			     __pa(i) + (idx*PAGE_SIZE),
 			     PAGE_KERNEL_VVAR);
 	}
 


