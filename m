Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966494AbaCUAjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:39:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37085 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965870AbaCUAIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Wang Weidong <wangweidong1@huawei.com>
Subject: [PATCH 3.10 28/85] ARM: 7811/1: locks: use early clobber in arch_spin_trylock
Date: Thu, 20 Mar 2014 17:09:31 -0700
Message-Id: <20140321000602.636108124@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit afa31d8eb86fc2f25083e675d57ac8173a98f999 upstream.

The res variable is written before we've finished with the input
operands (namely the lock address), so ensure that we mark it as `early
clobber' to avoid unintended register sharing.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Wang Weidong <wangweidong1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/spinlock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/include/asm/spinlock.h
+++ b/arch/arm/include/asm/spinlock.h
@@ -107,7 +107,7 @@ static inline int arch_spin_trylock(arch
 		"	subs	%1, %0, %0, ror #16\n"
 		"	addeq	%0, %0, %4\n"
 		"	strexeq	%2, %0, [%3]"
-		: "=&r" (slock), "=&r" (contended), "=r" (res)
+		: "=&r" (slock), "=&r" (contended), "=&r" (res)
 		: "r" (&lock->slock), "I" (1 << TICKET_SHIFT)
 		: "cc");
 	} while (res);


