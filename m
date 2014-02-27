Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaB0VUr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:20:47 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:40259 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaB0VUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:20:46 -0500
Date: Thu, 27 Feb 2014 23:20:34 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: akpm@linux-foundation.org, sasha.levin@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/pagewalk.c: fix end address calculation in
 walk_page_range()
Message-ID: <20140227212034.GA6106@node.dhcp.inet.fi>
References: <1393475977-3381-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1393475977-3381-2-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140227130323.0d4f0a27b4327100805bab02@linux-foundation.org>
 <530fabcf.05300f0a.7f7e.ffffc80dSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530fabcf.05300f0a.7f7e.ffffc80dSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 04:19:01PM -0500, Naoya Horiguchi wrote:
> On Thu, Feb 27, 2014 at 01:03:23PM -0800, Andrew Morton wrote:
> > On Wed, 26 Feb 2014 23:39:35 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> > 
> > > When we try to walk over inside a vma, walk_page_range() tries to walk
> > > until vma->vm_end even if a given end is before that point.
> > > So this patch takes the smaller one as an end address.
> > > 
> > > ...
> > >
> > > --- next-20140220.orig/mm/pagewalk.c
> > > +++ next-20140220/mm/pagewalk.c
> > > @@ -321,8 +321,9 @@ int walk_page_range(unsigned long start, unsigned long end,
> > >  			next = vma->vm_start;
> > >  		} else { /* inside the found vma */
> > >  			walk->vma = vma;
> > > -			next = vma->vm_end;
> > > -			err = walk_page_test(start, end, walk);
> > > +			next = min_t(unsigned long, end, vma->vm_end);
> > 
> > min_t is unneeded, isn't it?  Everything here has type unsigned long.
> 
> Yes, so simply (end < vma->vm_end ? end: vma->vm_end) is enough.
> # I just considered min_t as simple minimum getter without thinking type check.

We have non-typed min() for that.

-- 
 Kirill A. Shutemov
