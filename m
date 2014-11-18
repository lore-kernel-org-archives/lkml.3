Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaKRROV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:14:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbaKRROS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:14:18 -0500
Date: Tue, 18 Nov 2014 17:14:14 +0000
From: Mel Gorman <mgorman@suse.de>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 0/7] Replace _PAGE_NUMA with PAGE_NONE protections
Message-ID: <20141118171413.GE2725@suse.de>
References: <1415971986-16143-1-git-send-email-mgorman@suse.de>
 <5466C8A5.3000402@oracle.com>
 <20141118154246.GB2725@suse.de>
 <546B74F5.10004@oracle.com>
 <87tx1w78hi.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87tx1w78hi.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 10:26:41PM +0530, Aneesh Kumar K.V wrote:
> Sasha Levin <sasha.levin@oracle.com> writes:
> 
> > On 11/18/2014 10:42 AM, Mel Gorman wrote:
> >> 1. I'm assuming this is a KVM setup but can you confirm?
> >
> > Yes.
> >
> >> 2. Are you using numa=fake=N?
> >
> > Yes. numa=fake=24, which is probably way more nodes on any physical machine
> > than the new code was tested on?
> >
> >> 3. If you are using fake NUMA, what happens if you boot without it as
> >>    that should make the patches a no-op?
> >
> > Nope, still seeing it without fake numa.
> >
> >> 4. Similarly, does the kernel boot properly without without patches?
> >
> > Yes, the kernel works fine without the patches both with and without fake
> > numa.
> 
> 
> Hmm that is interesting. I am not sure how writeback_fid can be
> related. We use writeback fid to enable client side caching with 9p
> (cache=loose). We use this fid to write back dirty pages later. Can you
> share the qemu command line used, 9p mount options and the test details ? 
> 

It would help if the test details included the kernel config. I got KVM
working again on an server with an older installation and while it
doesn't use 9p, I'm not seeing any other oddities either yet while
running trinity.

-- 
Mel Gorman
SUSE Labs
