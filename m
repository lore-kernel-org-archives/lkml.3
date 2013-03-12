Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392Ab3CLT23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:28:29 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:40458 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3CLT21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:28:27 -0400
Date: Tue, 12 Mar 2013 20:28:16 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/1] mm/hugetlb: add more arch-defined huge_pte_xxx
 functions
Message-ID: <20130312202816.0890348c@thinkpad>
In-Reply-To: <20130312190011.GC20355@linux-sh.org>
References: <1363114106-30251-1-git-send-email-gerald.schaefer@de.ibm.com>
	<20130312190011.GC20355@linux-sh.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031219-0342-0000-0000-00000470774D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 04:00:12 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Tue, Mar 12, 2013 at 07:48:25PM +0100, Gerald Schaefer wrote:
> > This patch introduces those huge_pte_xxx functions and their
> > implementation on all architectures supporting hugetlbfs. This change
> > will be a no-op for all architectures other than s390.
> > 
> ..
> 
> >  arch/ia64/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
> >  arch/mips/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
> >  arch/powerpc/include/asm/hugetlb.h | 36 ++++++++++++++++++++++++
> >  arch/s390/include/asm/hugetlb.h    | 56 +++++++++++++++++++++++++++++++++++++-
> >  arch/s390/include/asm/pgtable.h    | 20 --------------
> >  arch/s390/mm/hugetlbpage.c         |  2 +-
> >  arch/sh/include/asm/hugetlb.h      | 36 ++++++++++++++++++++++++
> >  arch/sparc/include/asm/hugetlb.h   | 36 ++++++++++++++++++++++++
> >  arch/tile/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
> >  arch/x86/include/asm/hugetlb.h     | 36 ++++++++++++++++++++++++
> >  mm/hugetlb.c                       | 23 ++++++++--------
> >  11 files changed, 320 insertions(+), 33 deletions(-)
> > 
> None of these wrappers are doing anything profound for most platforms, so
> this would be a good candidate for an asm-generic/hugetlb.h (after which
> s390 can continue to be special and no one else has to care).

Yes, that was also my first idea, but I vaguely remembered some discussion
with Andrew when I sent the original s390 hugetlb support patch (which also
went for the asm-generic approach). So I tried to dig out that thread, and
it turned out that the ugliness of ARCH_HAS_xxx actually resulted in my
original patch to be changed into removing lots of those and therefore
creating the individual arch header files, for the sake of readability and
maintainability. So I guess it would be straightforward to extend those
header files now, instead of re-introducing some of the ugliness.

See also here http://marc.info/?l=linux-kernel&m=120536577402075&w=2 and
here http://marc.info/?l=linux-kernel&m=120732788201196&w=2.

Thanks,
Gerald

