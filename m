Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223Ab3CAQus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:50:48 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:60978 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3CAQur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:50:47 -0500
Date: Fri, 1 Mar 2013 08:50:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Greg KH <gregkh@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Laura Abbott <lauraa@codeaurora.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [-rc7 regression] Buggy commit: "mm: use aligned zone start for
 pfn_to_bitidx calculation"
Message-ID: <20130301165043.GB5435@kroah.com>
References: <20130213111007.GA11367@gmail.com>
 <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos>
 <20130214144510.GC25282@gmail.com>
 <20130214145424.GA26071@gmail.com>
 <20130214150810.GA26095@gmail.com>
 <CAE9FiQXc=7+TMwbfd20YiHNfOHX_kUOzYcVm8-uaP2R_C_1RRg@mail.gmail.com>
 <20130215114425.GD26955@gmail.com>
 <20130215220615.GA1696@kroah.com>
 <20130216082954.GA18953@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130216082954.GA18953@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 09:29:54AM +0100, Ingo Molnar wrote:
> 
> * Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Feb 15, 2013 at 12:44:26PM +0100, Ingo Molnar wrote:
> > > 
> > > [ Greg: -stable was Cc:-ed for this potentially buggy commit. ]
> > > 
> > > * Yinghai Lu <yinghai@kernel.org> wrote:
> > > 
> > > > On Thu, Feb 14, 2013 at 7:08 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > > > > these three:
> > > > >
> > > > > 10d73e655cef mm: bootmem: fix free_all_bootmem_core() with odd bitmap alignment
> > > > > c060f943d092 mm: use aligned zone start for pfn_to_bitidx calculation
> > > > > c0232ae861df mm: memblock: fix wrong memmove size in memblock_merge_regions()
> > > > >
> > > > > might have highmem=512m boot parameter sensitivity.
> > > > 
> > > > 10d73e655cef should not be related, as we are using nobootmem wrapper
> > > > of memblock.
> > > > c0232ae861df is copying less while using the blank slot in memblock
> > > > memory or reserved array
> > > > so it should be ok too.
> > > > 
> > > > c060f943d092 may be related as you config does not have
> > > > CONFIG_SPARSEMEM defined.
> > > 
> > > Right, that's the commit causing the x86 regression:
> > > 
> > >  c060f943d0929f3e429c5d9522290584f6281d6e is the first bad commit
> > >  commit c060f943d0929f3e429c5d9522290584f6281d6e
> > >  Date:   Fri Jan 11 14:31:51 2013 -0800
> > > 
> > >      mm: use aligned zone start for pfn_to_bitidx calculation
> > > 
> > > I've given 6d92d4f (its parent commit) quite a bit of testing so 
> > > I'm 99% sure in the validity of this bisection result.
> > > 
> > > Involved parties Cc:-ed.
> > > 
> > > Revert attached below - it reverts cleanly and I'll test this 
> > > today, to see whether this solves the sporadic lockups.
> > > 
> > > Thanks,
> > > 
> > > 	Ingo
> > > 
> > > ------------------->
> > > >From 6f3d5a8f38eb23f792b408d9bc8fee53a7d158f9 Mon Sep 17 00:00:00 2001
> > > From: Ingo Molnar <mingo@kernel.org>
> > > Date: Fri, 15 Feb 2013 12:43:22 +0100
> > > Subject: [PATCH] Revert "mm: use aligned zone start for pfn_to_bitidx
> > >  calculation"
> > > 
> > > This reverts commit c060f943d0929f3e429c5d9522290584f6281d6e.
> > 
> > Let me know if I should be reverting this from the -stable releases.
> 
> It appears so - it definitely locks up here with the config I 
> sent. It appears to be a rare bug but a bug.
> 
> Would be nice to hear from the authors/ackers/pushers of the 
> patch though.

What ever happened with this?  Did something go into Linus's tree to
resolve this issue that I need to pull into a stable release?

thanks,

greg k-h
