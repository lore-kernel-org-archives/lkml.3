Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab3LSVCe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:02:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab3LSVCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:02:32 -0500
Date: Thu, 19 Dec 2013 15:30:10 -0500
From: Dave Jones <davej@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: bad page state in 3.13-rc4
Message-ID: <20131219203010.GB14519@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mel Gorman <mgorman@suse.de>, Christoph Lameter <cl@linux.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sasha.levin@oracle.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Hugh Dickins <hughd@google.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>
References: <20131219040738.GA10316@redhat.com>
 <CA+55aFwweoGs3eGWXFULcqnbRbpDhpj2qrefXB5OpQOiWW8wYA@mail.gmail.com>
 <alpine.DEB.2.10.1312190930190.4238@nuc>
 <20131219201158.GT11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219201158.GT11295@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 08:11:58PM +0000, Mel Gorman wrote:
 
 > Dave, was this a NUMA machine?

It's a dual core i5-4670T with hyperthreading.

 > If yes, was CONFIG_NUMA_BALANCING set?

no.

 > Dave, when this this
 > bug start triggering? If it's due to a recent change in trinity, can you
 > check if 3.12 is also affected? If not, can you check if the bug started
 > happening somewhere around these commits?
 
Right now it can take hours for it to reproduce. Until I can narrow it down to
something repeatable, bisecting and trying old builds is going to be really time-consuming.

Given the other VM bugs that have Sasha and I have been finding since I added
the mmap reuse code to trinity, this is probably something else that has been
there for a while.

 > A few bad state bugs have shown up on linux-mm recently but my impression
 > was that they were related to rmap_walk changes currently in next. The
 > initial log indicated that this was 3.13-rc4 but is it really 3.13-rc4 or
 > are there any -next patches applied?

no, just rc4 (plus a handful of small patches to fix oopses etc that I've already
diagnosed).  I'm glad Sasha spends time running this stuff on -next, because 
there aren't enough hours in the day for me to look at the stuff I find
in Linus' tree without looking at what's coming next.

	Dave

