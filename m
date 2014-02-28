Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaB1Lvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:51:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:55802 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbaB1Lvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:51:39 -0500
Message-ID: <1393588254.22449.13.camel@pasglop>
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        anton@samba.org, Paul Mackerras <paulus@samba.org>
Date: Fri, 28 Feb 2014 22:50:54 +1100
In-Reply-To: <530FBD8F.7090304@linux.intel.com>
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
	 <1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
	 <530FB55F.2070106@linux.intel.com>
	 <CA+55aFzUYTHXcVnZL0vTGRPh3oQ8qYGO9+Va1Ch3P1yX+9knDg@mail.gmail.com>
	 <530FBD8F.7090304@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 14:34 -0800, Dave Hansen wrote:
> 
> The question is really whether or not we ever access the mapping that we
> faulted around, though.  If we never access it, then the cost (however
> small it was) is a loss.  That's the mechanism that I'd expect causes
> Kirill's numbers to go up after they hit their minimum at ~order-4.

On the other hand, the cost of our faults on ppc64 is higher. The two hash
lookups by the MMU (generally L2 misses) before it even decides to take the
fault, followed by a generally longer code path before we get to Linux
fault handler.

So there might be a bigger win for us, especially if the "around" pages
get pre-hashed (ie, via update_mmu_cache)

I don't have the bandwidth to play around with that myself at the moment
but I'll try to find somebody who can.

Cheers,
Ben.


