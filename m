Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932739Ab3JKTlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:41:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3JKTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>
Subject: [ 092/135] sparc32: Fix exit flag passed from traced sys_sigreturn
Date: Fri, 11 Oct 2013 12:39:33 -0700
Message-Id: <20131011193955.254943718@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit 7a3b0f89e3fea680f93932691ca41a68eee7ab5e ]

Pass 1 in %o1 to indicate that syscall_trace accounts exit.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc/kernel/entry.S
+++ b/arch/sparc/kernel/entry.S
@@ -839,7 +839,7 @@ sys_sigreturn:
 	 nop
 
 	call	syscall_trace
-	 nop
+	 mov	1, %o1
 
 1:
 	/* We don't want to muck with user registers like a


