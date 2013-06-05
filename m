Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab3FEVNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:13:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932631Ab3FEVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:13:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Pelikan <pelikan@storkhole.cz>,
        Richard Weinberger <richard@nod.at>, "H. Peter Anvin" <hpa@zytor.com>,
        "Bernhard M. Wiedemann" <bwiedemann@suse.de>
Subject: [ 42/44] x86, um: Correct syscall table type attributes breaking gcc 4.8
Date: Wed,  5 Jun 2013 14:12:40 -0700
Message-Id: <20130605211226.239834635@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Pelikan <pelikan@storkhole.cz>

commit 9271b0b4b2044c6db06051fe60bc58cdd4f17c7c upstream.

The latest GCC 4.8 does some more checking on type attributes that
break the build for ARCH=um -> fill them in.  Specifically, the
"asmlinkage" attributes is now tested for consistency.

Signed-off-by: Martin Pelikan <pelikan@storkhole.cz>
Link: http://lkml.kernel.org/r/1339269731-10772-1-git-send-email-pelikan@storkhole.cz
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Bernhard M. Wiedemann <bwiedemann@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/um/sys_call_table_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/um/sys_call_table_32.c
+++ b/arch/x86/um/sys_call_table_32.c
@@ -39,9 +39,9 @@
 #undef __SYSCALL_I386
 #define __SYSCALL_I386(nr, sym, compat) [ nr ] = sym,
 
-typedef void (*sys_call_ptr_t)(void);
+typedef asmlinkage void (*sys_call_ptr_t)(void);
 
-extern void sys_ni_syscall(void);
+extern asmlinkage void sys_ni_syscall(void);
 
 const sys_call_ptr_t sys_call_table[] __cacheline_aligned = {
 	/*


