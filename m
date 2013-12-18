Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3LRPq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:46:58 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:64267 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3LRPq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:46:57 -0500
Date: Wed, 18 Dec 2013 19:46:53 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, khlebnikov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: kernel BUG at include/linux/swapops.h:131!
Message-ID: <20131218154653.GX8167@moon>
References: <52B1C143.8080301@oracle.com>
 <20131218154145.GW8167@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218154145.GW8167@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 07:41:45PM +0400, Cyrill Gorcunov wrote:
> On Wed, Dec 18, 2013 at 10:37:39AM -0500, Sasha Levin wrote:
> > Hi all,
> > 
> > While fuzzing with trinity inside a KVM tools guest running latest
> > -next kernel, I've stumbled on the following spew.
> > 
> > The code is in zap_pte_range():
> > 
> >                 if (!non_swap_entry(entry))
> >                         rss[MM_SWAPENTS]--;
> >                 else if (is_migration_entry(entry)) {
> >                         struct page *page;
> > 
> >                         page = migration_entry_to_page(entry);	<==== HERE
> > 
> >                         if (PageAnon(page))
> >                                 rss[MM_ANONPAGES]--;
> >                         else
> >                                 rss[MM_FILEPAGES]--;
> 
> This I think is my issue, I'll take a look, thanks Sasha!

Ah, no. I thought it somehow related to dirty tracking, but
it's not, different issue.
