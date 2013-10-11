Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3JKVHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:07:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922Ab3JKTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:35:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>, David Miller <davem@davemloft.net>
Subject: [ 25/39] sparc64: Remove RWSEM export leftovers
Date: Fri, 11 Oct 2013 12:35:09 -0700
Message-Id: <20131011193213.623269499@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193210.843963685@linuxfoundation.org>
References: <20131011193210.843963685@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

[ Upstream commit 61d9b9355b0d427bd1e732bd54628ff9103e496f ]

The functions

			__down_read
			__down_read_trylock
			__down_write
			__down_write_trylock
			__up_read
			__up_write
			__downgrade_write

are implemented inline, so remove corresponding EXPORT_SYMBOLs
(They lead to compile errors on RT kernel).

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/lib/ksyms.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -131,15 +131,6 @@ EXPORT_SYMBOL(___copy_from_user);
 EXPORT_SYMBOL(___copy_in_user);
 EXPORT_SYMBOL(__clear_user);
 
-/* RW semaphores */
-EXPORT_SYMBOL(__down_read);
-EXPORT_SYMBOL(__down_read_trylock);
-EXPORT_SYMBOL(__down_write);
-EXPORT_SYMBOL(__down_write_trylock);
-EXPORT_SYMBOL(__up_read);
-EXPORT_SYMBOL(__up_write);
-EXPORT_SYMBOL(__downgrade_write);
-
 /* Atomic counter implementation. */
 EXPORT_SYMBOL(atomic_add);
 EXPORT_SYMBOL(atomic_add_ret);


