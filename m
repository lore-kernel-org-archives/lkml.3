Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbaDHRDR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:03:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbaDHRDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:03:15 -0400
Date: Tue, 8 Apr 2014 18:03:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
Message-ID: <20140408170310.GO7292@suse.de>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
 <53440A5D.6050301@zytor.com>
 <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
 <20140408164652.GL7292@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140408164652.GL7292@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 05:46:52PM +0100, Mel Gorman wrote:
> On Tue, Apr 08, 2014 at 08:22:15AM -0700, Linus Torvalds wrote:
> > On Tue, Apr 8, 2014 at 7:40 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> > >
> > > David, is your patchset going to be pushed in this merge window as expected?
> > 
> > Apparently aiming for 3.16 right now.
> > 
> 
> > > That being said, these bits are precious, and if this ends up being a
> > > case where "only Xen needs another bit" once again then Xen should
> > > expect to get kicked to the curb at a moment's notice.
> > 
> > Quite frankly, I don't think it's a Xen-only issue. The code was hard
> > to figure out even without the Xen issues. For example, nobody ever
> > explained to me why it
> > 
> >  (a) could be the same as PROTNONE on x86
> >  (b) could not be the same as PROTNONE in general
> 
> This series exists in response to your comment
> 
> 	I fundamentally think that it was a horrible horrible disaster to
> 	make _PAGE_NUMA alias onto _PAGE_PROTNONE.
> 
> As long as _PAGE_NUMA aliases to _PAGE_PROTNONE on x86 then the core has to
> play games to take that into account and the code will be "hard to figure
> out even without the Xen issues".

Is what you want for _PAGE_NUMA to disappear from arch/x86 and instead
use _PAGE_PROTNONE with comments explaining why and leave the core as it
is?

-- 
Mel Gorman
SUSE Labs
