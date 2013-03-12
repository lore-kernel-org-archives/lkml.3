Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3CLTsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:48:15 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:48468 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab3CLTsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:48:13 -0400
Date: Tue, 12 Mar 2013 20:48:03 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/1] mm/hugetlb: add more arch-defined huge_pte_xxx
 functions
Message-ID: <20130312204803.32234105@thinkpad>
In-Reply-To: <513F7B55.60805@tilera.com>
References: <1363114106-30251-1-git-send-email-gerald.schaefer@de.ibm.com>
	<1363114106-30251-2-git-send-email-gerald.schaefer@de.ibm.com>
	<513F7B55.60805@tilera.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031219-0542-0000-0000-000004A3D303
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Mar 2013 15:00:37 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> On 3/12/2013 2:48 PM, Gerald Schaefer wrote:
> > Commit abf09bed3c "s390/mm: implement software dirty bits" introduced
> > another difference in the pte layout vs. the pmd layout on s390,
> > thoroughly breaking the s390 support for hugetlbfs. This requires
> > replacing some more pte_xxx functions in mm/hugetlbfs.c with a
> > huge_pte_xxx version.
> >
> > This patch introduces those huge_pte_xxx functions and their
> > implementation on all architectures supporting hugetlbfs. This change
> > will be a no-op for all architectures other than s390.
> >
> > [...]
> >  
> > +static inline pte_t mk_huge_pte(struct page *page, pgprot_t pgprot)
> > +{
> > +	return mk_pte(page, pgprot);
> > +}
> 
> Does it make sense to merge this new per-arch function with the existing per-arch arch_make_huge_pte() function?  Certainly in the tile case, we could set up our "super" bit in the initial mk_huge_pte() call, and then set "young" and "huge" after that in the platform-independent caller (make_huge_pte).  This would allow your change to eliminate some code as well as just introducing code :-)
> 
Yes, I guess there is also some potential of optimizing/eliminating
existing code. Apart from the arch_make_huge_pte() that you mentioned,
there is also a pte_mkhuge() left over, which looks like it should be
merged into the new mk_huge_pte().

But that would probably require more modifications than I'd dare to
bring up on rc3+. So the main focus of this patch is to fix the bug
on s390 with sw dirty bits before that bug appears in 3.9, and therefore
I'd like to keep it as simple as possible and w/o functional changes
on any other architecture for now.

Thanks,
Gerald

