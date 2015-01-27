Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbbA0QYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:24:43 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:57206 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbA0QYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:24:39 -0500
Date: Tue, 27 Jan 2015 08:24:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: mmotm 2015-01-22-15-04: qemu failures due to 'mm: account pmd
 page tables to the process'
Message-ID: <20150127162428.GA21638@roeck-us.net>
References: <54c1822d.RtdGfWPekQVAw8Ly%akpm@linux-foundation.org>
 <20150123050445.GA22751@roeck-us.net>
 <20150123111304.GA5975@node.dhcp.inet.fi>
 <54C263CC.1060904@roeck-us.net>
 <20150123135519.9f1061caf875f41f89298d59@linux-foundation.org>
 <20150124055207.GA8926@roeck-us.net>
 <20150126122944.GE25833@node.dhcp.inet.fi>
 <54C6494D.80802@roeck-us.net>
 <20150127161657.GA7155@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150127161657.GA7155@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54C7BBC6.001E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 06:16:57PM +0200, Kirill A. Shutemov wrote:
> On Mon, Jan 26, 2015 at 06:03:57AM -0800, Guenter Roeck wrote:
> > On 01/26/2015 04:29 AM, Kirill A. Shutemov wrote:
> > >On Fri, Jan 23, 2015 at 09:52:07PM -0800, Guenter Roeck wrote:
> > >>On Fri, Jan 23, 2015 at 01:55:19PM -0800, Andrew Morton wrote:
> > >>>On Fri, 23 Jan 2015 07:07:56 -0800 Guenter Roeck <linux@roeck-us.net> wrote:
> > >>>
> > >>>>>>
> > >>>>>>qemu:microblaze generates warnings to the console.
> > >>>>>>
> > >>>>>>WARNING: CPU: 0 PID: 32 at mm/mmap.c:2858 exit_mmap+0x184/0x1a4()
> > >>>>>>
> > >>>>>>with various call stacks. See
> > >>>>>>http://server.roeck-us.net:8010/builders/qemu-microblaze-mmotm/builds/15/steps/qemubuildcommand/logs/stdio
> > >>>>>>for details.
> > >>>>>
> > >>>>>Could you try patch below? Completely untested.
> > >>>>>
> > >>>>>>From b584bb8d493794f67484c0b57c161d61c02599bc Mon Sep 17 00:00:00 2001
> > >>>>>From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > >>>>>Date: Fri, 23 Jan 2015 13:08:26 +0200
> > >>>>>Subject: [PATCH] microblaze: define __PAGETABLE_PMD_FOLDED
> > >>>>>
> > >>>>>Microblaze uses custom implementation of PMD folding, but doesn't define
> > >>>>>__PAGETABLE_PMD_FOLDED, which generic code expects to see. Let's fix it.
> > >>>>>
> > >>>>>Defining __PAGETABLE_PMD_FOLDED will drop out unused __pmd_alloc().
> > >>>>>It also fixes problems with recently-introduced pmd accounting.
> > >>>>>
> > >>>>>Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > >>>>>Reported-by: Guenter Roeck <linux@roeck-us.net>
> > >>>>
> > >>>>Tested working.
> > >>>>
> > >>>>Tested-by: Guenter Roeck <linux@roeck-us.net>
> > >>>>
> > >>>>Any idea how to fix the sh problem ?
> > >>>
> > >>>Can you tell us more about it?  All I'm seeing is "qemu:sh fails to
> > >>>shut down", which isn't very clear.
> > >>
> > >>Turns out that the include file defining __PAGETABLE_PMD_FOLDED
> > >>was not always included where used, resulting in a messed up mm_struct.
> > >
> > >What means "messed up" here? It should only affect size of mm_struct.
> > >
> > Plus the offset of all variables after the #ifndef.
> 
> Okay, I guess the problem is that different parts of the kernel see
> different mm_struct depending on include ordering.
> 
> Tried to look for options, but don't see anything better than patch below.
> Andrew, is it okay to you?
> 
> From 0f113e16a058d47f3bc63a3b6ced5296afb934a6 Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Tue, 27 Jan 2015 17:59:55 +0200
> Subject: [PATCH] mm: add nr_pmds into mm_struct unconditionally
> 
> __PAGETABLE_PMD_FOLDED is defined during <asm/pgtable.h> which is not
> included into <linux/mm_types.h>. And we cannot include it here since
> many of <asm/pgtables> needs <linux/mm_types.h> to define struct page.
> 
> I failed to come up with better solution rather than put nr_pmds into
> mm_struct unconditionally.
> 
> One possible solution would be to expose number of page table levels
> architecture has via Kconfig, but that's ugly and requires changes to
> all architectures.
> 
FWIW, I tried a number of approaches. Ultimately I gave up and concluded
that it has to be either this patch or, as you say here, we would have
to add something like PAGETABLE_PMD_FOLDED as a Kconfig option.

> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

Tested working with all builds and all my qemu tests.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
