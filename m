Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaH2Thd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 15:37:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaH2Thc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 15:37:32 -0400
Date: Fri, 29 Aug 2014 12:37:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: kirill.shutemov@linux.intel.com, khlebnikov@openvz.org, riel@redhat.com,
        mgorman@suse.de, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz,
        hughd@google.com, vbabka@suse.cz, walken@google.com,
        minchan@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] Introduce dump_vma
Message-Id: <20140829123730.ac09a559320224f7ed84f1c7@linux-foundation.org>
In-Reply-To: <1409324059-28692-1-git-send-email-sasha.levin@oracle.com>
References: <1409324059-28692-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014 10:54:17 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> Introduce a helper to dump information about a VMA, this also
> makes dump_page_flags more generic and re-uses that so the
> output looks very similar to dump_page:
> 

That's another kilobyte which we don't actually use unless
CONFIG_DEBUG_VM, so how about we do

--- a/mm/page_alloc.c~introduce-dump_vma-fix
+++ a/mm/page_alloc.c
@@ -6683,6 +6683,8 @@ void dump_page(struct page *page, const
 }
 EXPORT_SYMBOL(dump_page);
 
+#ifdef CONFIG_DEBUG_VM
+
 static const struct trace_print_flags vmaflags_names[] = {
 	{VM_READ,			"read"		},
 	{VM_WRITE,			"write"		},
@@ -6740,3 +6742,5 @@ void dump_vma(const struct vm_area_struc
 	dump_flags(vma->vm_flags, vmaflags_names, ARRAY_SIZE(vmaflags_names));
 }
 EXPORT_SYMBOL(dump_vma);
+
+#endif		/* CONFIG_DEBUG_VM */

until someone needs it from non-debug code?
