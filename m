Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab3CNPBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:01:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847Ab3CNPBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:01:20 -0400
Date: Thu, 14 Mar 2013 16:01:12 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-mm@kvack.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 1/1] mm/hugetlb: add more arch-defined huge_pte_xxx
 functions
Message-ID: <20130314150112.GD11636@dhcp22.suse.cz>
References: <1363114106-30251-1-git-send-email-gerald.schaefer@de.ibm.com>
 <1363114106-30251-2-git-send-email-gerald.schaefer@de.ibm.com>
 <20130314131404.GH11631@dhcp22.suse.cz>
 <20130314151109.5b6927ce@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314151109.5b6927ce@thinkpad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-03-13 15:11:09, Gerald Schaefer wrote:
> On Thu, 14 Mar 2013 14:14:04 +0100
> Michal Hocko <mhocko@suse.cz> wrote:
> 
> > On Tue 12-03-13 19:48:26, Gerald Schaefer wrote:
> > > Commit abf09bed3c "s390/mm: implement software dirty bits" introduced
> > > another difference in the pte layout vs. the pmd layout on s390,
> > > thoroughly breaking the s390 support for hugetlbfs. This requires
> > > replacing some more pte_xxx functions in mm/hugetlbfs.c with a
> > > huge_pte_xxx version.
> > > 
> > > This patch introduces those huge_pte_xxx functions and their
> > > implementation on all architectures supporting hugetlbfs. This change
> > > will be a no-op for all architectures other than s390.
> > > 
> > > Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > > ---
> > >  arch/ia64/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
> > >  arch/mips/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
> > >  arch/powerpc/include/asm/hugetlb.h | 36 ++++++++++++++++++++++++
> > >  arch/s390/include/asm/hugetlb.h    | 56 +++++++++++++++++++++++++++++++++++++-
> > >  arch/s390/include/asm/pgtable.h    | 20 --------------
> > >  arch/s390/mm/hugetlbpage.c         |  2 +-
> > >  arch/sh/include/asm/hugetlb.h      | 36 ++++++++++++++++++++++++
> > >  arch/sparc/include/asm/hugetlb.h   | 36 ++++++++++++++++++++++++
> > >  arch/tile/include/asm/hugetlb.h    | 36 ++++++++++++++++++++++++
> > >  arch/x86/include/asm/hugetlb.h     | 36 ++++++++++++++++++++++++
> > >  mm/hugetlb.c                       | 23 ++++++++--------
> > >  11 files changed, 320 insertions(+), 33 deletions(-)
> > 
> > Ouch, this adds a lot of code that is almost same for all archs except
> > for some. Can we just make one common definition and define only those
> > that differ, please?
> > [...]
> 
> Ok, seems like I misinterpreted the ugliness of HAVE_ARCH_xxx vs. code
> duplication. Paul Mundt also suggested going for an asm-generic/hugetlb.h
> approach. I'll send a new patch soon.

Oh, I have missed that answer so sorry for duplication. Anyway, having
asm-generic and HAVE_ARCH_xxx sounds much better to me for this case as
the duplication is really big.

Thanks
-- 
Michal Hocko
SUSE Labs
