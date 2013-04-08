Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935793Ab3DHTeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 15:34:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935763Ab3DHTeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 15:34:36 -0400
Date: Mon, 8 Apr 2013 12:34:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        simon.jeons@gmail.com, ric.masonn@gmail.com
Subject: Re: [PATCH v8 1/3] mm: limit growth of 3% hardcoded other user
 reserve
Message-Id: <20130408123434.1a6dd5fb7341b0243e9dcdb3@linux-foundation.org>
In-Reply-To: <20130408190402.GA2321@localhost.localdomain>
References: <20130408190402.GA2321@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013 15:04:02 -0400 Andrew Shewmaker <agshew@gmail.com> wrote:

> v8:
>  * Rebased onto v3.9-rc4-mmotm-2013-03-26-15-09
> 
>  * Clarified reasoning between different calculations for
>    overcommit 'guess' and 'never modes in FAQ entry
>    "How do you calculate a minimum useful reserve?"
>    in response to Simon Jeons.
> 
>  * Added third patch in series to handle hot-added or hot-swapped
>    memory.

Well here's the v7-plus-my-fixes to v8 delta:

--- a/.gitignore~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v8
+++ a/.gitignore
@@ -30,6 +30,7 @@ modules.builtin
 *.lzma
 *.xz
 *.lzo
+*.out
 *.patch
 *.gcno
 
diff -puN include/linux/mm.h~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v8 include/linux/mm.h
--- a/include/linux/mm.h~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v8
+++ a/include/linux/mm.h
@@ -44,8 +44,6 @@ extern int sysctl_legacy_va_layout;
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 
-extern unsigned long sysctl_user_reserve_kbytes;
-
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
 /* to align the pointer to the (next) page boundary */
diff -puN kernel/sysctl.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v8 kernel/sysctl.c
--- a/kernel/sysctl.c~mm-limit-growth-of-3%-hardcoded-other-user-reserve-v8
+++ a/kernel/sysctl.c
@@ -97,6 +97,7 @@
 /* External variables not in a header file. */
 extern int sysctl_overcommit_memory;
 extern int sysctl_overcommit_ratio;
+extern unsigned long sysctl_user_reserve_kbytes;
 extern int max_threads;
 extern int suid_dumpable;
 #ifdef CONFIG_COREDUMP

ie, it reverts my cleanup of the extern declaration and adds a random
unchangelogged line to .gitignore.

I'll grab the new changelog then ignore this update ;)
