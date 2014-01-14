Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaANPsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:48:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaANPsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:48:00 -0500
Date: Tue, 14 Jan 2014 15:47:56 +0000
From: Mel Gorman <mgorman@suse.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Alex Thorlton <athorlton@sgi.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: thp: Add per-mm_struct flag to control THP
Message-ID: <20140114154756.GE4963@suse.de>
References: <1389383718-46031-1-git-send-email-athorlton@sgi.com>
 <20140110202310.GB1421@node.dhcp.inet.fi>
 <20140110220155.GD3066@sgi.com>
 <20140110222315.GA7931@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140110222315.GA7931@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 11, 2014 at 12:23:15AM +0200, Kirill A. Shutemov wrote:
> On Fri, Jan 10, 2014 at 04:01:55PM -0600, Alex Thorlton wrote:
> > On Fri, Jan 10, 2014 at 10:23:10PM +0200, Kirill A. Shutemov wrote:
> > > Do you know what cause the difference? I prefer to fix THP instead of
> > > adding new knob to disable it.
> > 
> > The issue is that when you touch 1 byte of an untouched, contiguous 2MB
> > chunk, a THP will be handed out, and the THP will be stuck on whatever
> > node the chunk was originally referenced from.  If many remote nodes
> > need to do work on that same chunk, they'll be making remote accesses.
> > With THP disabled, 4K pages can be handed out to separate nodes as
> > they're needed, greatly reducing the amount of remote accesses to
> > memory.
> 
> I think this problem *potentially* could be fixed by NUMA balancer.
> (Although, I don't really know how balancer works...)
> 
> If we see NUMA hint faults for addresses in different 4k pages inside huge
> page from more then one node, we could split the huge page.
> 
> Mel, is it possible? Do we collect enough info to make the decision?
> 

Potentially the hinting faults can be used to decide whether to split or
not but currently there is only limited information.  You can detect if
the last faulting process was on the same node but not if the faults were
in different parts of the THP that would justify a split.

-- 
Mel Gorman
SUSE Labs
