Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaE2EfC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:35:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211AbaE2Eey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 3.14 021/140] parisc: fix epoll_pwait syscall on compat kernel
Date: Wed, 28 May 2014 21:32:40 -0700
Message-Id: <20140529043052.083680394@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit ab3e55b119c9653b19ea4edffb86f04db867ac98 upstream.

This bug was detected with the libio-epoll-perl debian package where the
test case IO-Ppoll-compat.t failed.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/syscall_table.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/syscall_table.S
+++ b/arch/parisc/kernel/syscall_table.S
@@ -392,7 +392,7 @@
 	ENTRY_COMP(vmsplice)
 	ENTRY_COMP(move_pages)		/* 295 */
 	ENTRY_SAME(getcpu)
-	ENTRY_SAME(epoll_pwait)
+	ENTRY_COMP(epoll_pwait)
 	ENTRY_COMP(statfs64)
 	ENTRY_COMP(fstatfs64)
 	ENTRY_COMP(kexec_load)		/* 300 */


