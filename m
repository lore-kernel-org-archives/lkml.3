Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbaDXWTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:19:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbaDXVqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:46:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Hugh Dickins <hughd@google.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 3.10 18/23] Revert "sparc64: Fix __copy_{to,from}_user_inatomic defines."
Date: Thu, 24 Apr 2014 14:48:48 -0700
Message-Id: <20140424214828.245822971@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140424214825.933835556@linuxfoundation.org>
References: <20140424214825.933835556@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Kleikamp <dave.kleikamp@oracle.com>

[ Upstream commit 16932237f2978a2265662f8de4af743b1f55a209 ]

This reverts commit 145e1c0023585e0e8f6df22316308ec61c5066b2.

This commit broke the behavior of __copy_from_user_inatomic when
it is only partially successful. Instead of returning the number
of bytes not copied, it now returns 1. This translates to the
wrong value being returned by iov_iter_copy_from_user_atomic.

xfstests generic/246 and LTP writev01 both fail on btrfs and nfs
because of this.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/uaccess_64.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -262,8 +262,8 @@ extern unsigned long __must_check __clea
 extern __must_check long strlen_user(const char __user *str);
 extern __must_check long strnlen_user(const char __user *str, long n);
 
-#define __copy_to_user_inatomic ___copy_to_user
-#define __copy_from_user_inatomic ___copy_from_user
+#define __copy_to_user_inatomic __copy_to_user
+#define __copy_from_user_inatomic __copy_from_user
 
 struct pt_regs;
 extern unsigned long compute_effective_address(struct pt_regs *,


