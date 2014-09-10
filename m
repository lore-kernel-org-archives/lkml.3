Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaIJOer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbaIJOeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:34:44 -0400
Date: Wed, 10 Sep 2014 10:33:52 -0400
From: Dave Jones <davej@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: Trinity and mbind flags (WAS: Re: mm: BUG in unmap_page_range)
Message-ID: <20140910143352.GB10785@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sasha Levin <sasha.levin@oracle.com>, Mel Gorman <mgorman@suse.de>,
	Hugh Dickins <hughd@google.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>
References: <20140827152622.GC12424@suse.de>
 <540127AC.4040804@oracle.com>
 <54082B25.9090600@oracle.com>
 <20140908171853.GN17501@suse.de>
 <540DEDE7.4020300@oracle.com>
 <20140909213309.GQ17501@suse.de>
 <540F7D42.1020402@oracle.com>
 <alpine.LSU.2.11.1409091903390.10989@eggly.anvils>
 <20140910124732.GT17501@suse.de>
 <54105F28.1000506@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54105F28.1000506@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:24:40AM -0400, Sasha Levin wrote:
 > On 09/10/2014 08:47 AM, Mel Gorman wrote:
 > > That site should have checked PROT_NONE but it can't be the same bug
 > > that trinity is seeing. Minimally trinity is unaware of MPOL_MF_LAZY
 > > according to git grep of the trinity source.
 > 
 > Actually, if I'm reading it correctly I think that Trinity handles mbind()
 > calls wrong. It passes the wrong values for mode flags and actual flags.

Ugh, I think you're right.  I misinterpreted the man page that mentions
that flags like MPOL_F_STATIC_NODES/RELATIVE_NODES are OR'd with the
mode, and instead dumped those flags into .. the flags field.

So the 'flags' argument it generates is crap, because I didn't add
any of the actual correct values.

I'll fix it up, though if it's currently finding bugs, you might want
to keep the current syscalls/mbind.c for now.

	Dave

