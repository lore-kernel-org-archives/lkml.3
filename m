Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964882AbaEQQ7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964774AbaEQQ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:59:32 -0400
Date: Sat, 17 May 2014 18:58:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: uprobes && shmem (Was: uprobes: Shift ->readpage check from
	__copy_insn() to uprobe_register())
Message-ID: <20140517165829.GA20772@redhat.com>
References: <20140516152919.GA30659@redhat.com> <20140516153058.GA30667@redhat.com> <alpine.LSU.2.11.1405161120410.3604@eggly.anvils> <alpine.LSU.2.11.1405161847040.5810@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1405161847040.5810@eggly.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Hugh Dickins wrote:
>
> On Fri, 16 May 2014, Hugh Dickins wrote:
> > On Fri, 16 May 2014, Oleg Nesterov wrote:
> > > shmem_getpage_gfp(). But, is there any way to figure out that this
> > > inode/mapping/aops/whatever is actually shmem?
> >
> > On 3.15 and later, you're in luck: Hannes added bool shmem_mapping(mapping)
> > in his 0cd6144aadd2 "mm + fs: prepare for non-page entries in page cache
> > radix trees"; and I just checked, it builds for "tiny" !CONFIG_SHMEM too.
> >
> > If you're backporting to an earlier kernel, it would probably be best
> > to add in a very small patch, extracting just shmem_mapping() and its
> > linux/mm.h declarations from 0cd6144aadd2.
>
> Looking into something else, I've just been reminded of
> mapping_cap_swap_backed(mapping): mm/madvise.c has been using that test
> for a year.  It also returns true on swapper_space, the imaginary mapping
> you get from a PageSwapCache page: so I suppose it would be wrong to make
> Hannes's shmem_mapping() a wrapper to that.  But for any backport of your
> change, it would better than extracting part of 0cd6144aadd2.

Yes, this should work, swap_address_space() can't be seen as ->i_mapping,

> (Sorry for going on about backporting, when you may have no such intention.)

No, no, thanks for additional info. Perhaps we will actually backport
this, at least in rhel. Although in the latter case perhaps it would
be better to extract shmem_mapping() from 0cd6144aadd2, it is simple
and straightforward.

Thanks,

Oleg.

