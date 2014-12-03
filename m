Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaLCQFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:05:45 -0500
Received: from relay1.sgi.com ([192.48.180.66]:47107 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaLCQFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:05:43 -0500
Date: Wed, 3 Dec 2014 10:05:46 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Alex Thorlton <athorlton@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Smart <james.smart@emulex.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [BUG] kzalloc overflow in lpfc driver on 6k core system
Message-ID: <20141203160546.GA4720@sgi.com>
References: <20141202215810.GT4720@sgi.com>
 <94D0CD8314A33A4D9D801C0FE68B4029593EFC9E@G4W3202.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593EFC9E@G4W3202.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 10:39:40PM +0000, Elliott, Robert (Server Storage) wrote:
> In similar code, mpt3sas and lockless hpsa just call get_cpu_mask()
> inside the loop:
>         cpu = cpumask_first(cpu_online_mask);
>         for (i = 0; i < h->msix_vector; i++) {
>                 rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
>                 cpu = cpumask_next(cpu, cpu_online_mask);
>         }
> 
> get_cpu_mask() uses the global cpu_bit_bitmap array, which is declared
> in kernel/cpu.c:
> extern const unsigned long
>         cpu_bit_bitmap[BITS_PER_LONG+1][BITS_TO_LONGS(NR_CPUS)];
> 
> That approach should work for lpfc.

Ok, good deal.  Thanks for the info, Robert.  Do you know who the
current maintainer is for this code?  Would that be you?  I included the
two authors that get_maintainer reported, but haven't heard from them.

I like this approach and don't mind implementing it myself, but I'd like
to confirm that whoever would be responsible for merging the code is ok
with the change before going forward.  Of course, if the code has been
orphaned, then I guess we just write away :)

Thanks again for the help!

- Alex
