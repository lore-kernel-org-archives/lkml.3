Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3CORFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 13:05:36 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:45628 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3CORFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 13:05:34 -0400
Date: Fri, 15 Mar 2013 18:05:21 +0100
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
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
Subject: Re: [PATCH v2] mm/hugetlb: add more arch-defined huge_pte functions
Message-ID: <20130315180521.618460c5@vbox-ubuntu>
In-Reply-To: <20130315160241.GD28311@dhcp22.suse.cz>
References: <1363283463-50880-1-git-send-email-gerald.schaefer@de.ibm.com>
	<20130315160241.GD28311@dhcp22.suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031517-8372-0000-0000-00000572717F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 17:02:41 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 14-03-13 18:51:03, Gerald Schaefer wrote:
> > Commit abf09bed3c "s390/mm: implement software dirty bits"
> > introduced another difference in the pte layout vs. the pmd layout
> > on s390, thoroughly breaking the s390 support for hugetlbfs. This
> > requires replacing some more pte_xxx functions in mm/hugetlbfs.c
> > with a huge_pte_xxx version.
> > 
> > This patch introduces those huge_pte_xxx functions and their
> > generic implementation in asm-generic/hugetlb.h, which will now be
> > included on all architectures supporting hugetlbfs apart from s390.
> > This change will be a no-op for those architectures.
> > 
> > Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> 
> yes this looks much better. I cannot talk about s390 part because I am
> not familiar with it but the rest looks good to me.
> 
> Maybe one nit, though. pte_page and pte_same do not have their
> huge_Foo counterparts.

Yes, a few pte_xxx calls remain. I left those because they still
work on s390 (and all other archs apparently). I am thinking about
a more complete cleanup, maybe eliminating the ambiguous use of pte_t
for hugetlb completely. Not sure if I can get to it before Martin
introduces the next s390 pte changes :)

Thanks,
Gerald

