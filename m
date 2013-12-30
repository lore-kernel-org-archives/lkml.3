Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3L3KtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:49:04 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:60963 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab3L3KtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:49:01 -0500
Date: Mon, 30 Dec 2013 12:48:54 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: dump page when hitting a VM_BUG_ON using
 VM_BUG_ON_PAGE fix
Message-ID: <20131230104854.GA7647@node.dhcp.inet.fi>
References: <1388184018-11396-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1388184018-11396-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 05:40:18PM -0500, Sasha Levin wrote:
> I messed up and forgot to commit this fix before sending out the original
> patch.
> 
> It fixes build issues in various files using VM_BUG_ON_PAGE.

With the patch applied I see this:

  CC      kernel/bounds.s
In file included from /home/space/kas/git/public/linux-next/include/linux/page-flags.h:10:0,
                 from /home/space/kas/git/public/linux-next/kernel/bounds.c:9:
/home/space/kas/git/public/linux-next/include/linux/mmdebug.h:5:30: warning: ‘struct page’ declared inside parameter list [enabled by default]
 extern void dump_page(struct page *page);
                              ^
/home/space/kas/git/public/linux-next/include/linux/mmdebug.h:5:30: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

We need to declare struct page here as well.

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index 8bb64900da25..e8cec8bdda05 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -2,6 +2,7 @@
 #define LINUX_MM_DEBUG_H 1
 
 #ifdef CONFIG_DEBUG_VM
+struct page;
 extern void dump_page(struct page *page);
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #define VM_BUG_ON_PAGE(cond, page) \
-- 
 Kirill A. Shutemov
