Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab3L0W0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:26:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3L0W0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:26:06 -0500
Date: Fri, 27 Dec 2013 14:26:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: dump page when hitting a VM_BUG_ON using
 VM_BUG_ON_PAGE
Message-Id: <20131227142605.5830bf0e4b9bb007c2916dfc@linux-foundation.org>
In-Reply-To: <52BDFD00.7020909@oracle.com>
References: <1388114452-30769-1-git-send-email-sasha.levin@oracle.com>
	<20131227103847.GA19453@node.dhcp.inet.fi>
	<52BDFD00.7020909@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Dec 2013 17:19:44 -0500 Sasha Levin <sasha.levin@oracle.com> wrote:

> On 12/27/2013 05:38 AM, Kirill A. Shutemov wrote:
> > On Thu, Dec 26, 2013 at 10:20:52PM -0500, Sasha Levin wrote:
> >> Most of the VM_BUG_ON assertions are performed on a page. Usually, when
> >> one of these assertions fails we'll get a BUG_ON with a call stack and
> >> the registers.
> >>
> >> I've recently noticed based on the requests to add a small piece of code
> >> that dumps the page to various VM_BUG_ON sites that the page dump is quite
> >> useful to people debugging issues in mm.
> >>
> >> This patch adds a VM_BUG_ON_PAGE(cond, page) which beyond doing what
> >> VM_BUG_ON() does, also dumps the page before executing the actual BUG_ON.
> >>
> >> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> >
> > I like the idea. One thing I've noticed you have a lot of page flag based
> > asserts, like:
> >
> > 	VM_BUG_ON_PAGE(PageLRU(page), page);
> > 	VM_BUG_ON_PAGE(!PageLocked(page), page);
> >
> > What about adding per-page-flag assert macros, like:
> >
> > 	PageNotLRU_assert(page);
> > 	PageLocked_assert(page);
> >
> > ? This way we will always dump right page on bug.
> >
> 
> Sure, sounds good.
> 
> I'll send another patch on top of this one.

I think I prefer the patch as-is.  To do what Kirill suggests we'd have
to add a heck of a lot more macros and they add little value.  And the
suggested names of those macros aren't very good - there's nothing in
"PageNotLRU_assert" which tells the reader that this code is
conditional on CONFIG_DEBUG_VM, which is a somewhat important thing.
