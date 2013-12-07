Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab3LGAZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:25:47 -0500
Received: from a10-51.smtp-out.amazonses.com ([54.240.10.51]:51935 "EHLO
	a10-51.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334Ab3LGAZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:25:46 -0500
Date: Sat, 7 Dec 2013 00:25:44 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Rik van Riel <riel@redhat.com>
cc: Mel Gorman <mgorman@suse.de>, Alex Thorlton <athorlton@sgi.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/15] mm: fix TLB flush race between migration, and
 change_protection_range
In-Reply-To: <52A23FD1.3040102@redhat.com>
Message-ID: <00000142ca7218fe-a5566a24-0ef5-4545-8a98-d33116b7d703-000000@email.amazonses.com>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de> <1386060721-3794-15-git-send-email-mgorman@suse.de> <529E641A.7040804@redhat.com> <20131203234637.GS11295@suse.de> <529F3D51.1090203@redhat.com> <20131204160741.GC11295@suse.de>
 <20131206141331.10880d2b@annuminas.surriel.com> <00000142c99cf5b0-69cc9987-aa36-4889-af6a-1a45032d0d13-000000@email.amazonses.com> <52A23FD1.3040102@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.07-54.240.10.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Dec 2013, Rik van Riel wrote:

> > When you start migrating a page a special page migration entry is
> > created that will trap all accesses to the page. You can safely flush when
> > the migration entry is there. Only allow a new PTE/PMD to be put there
> > *after* the tlb flush.
>
> A PROT_NONE or NUMA pte is just as effective as a migration pte.
> The only problem is, the TLB flush was not always done...

Ok then what are you trying to fix?

> > Dont do that. We have migration entries for a reason.
>
> We do not have migration entries for hugepages, do we?

Dunno.

> >
> > Should cause a page fault which should put the process to sleep. Process
> > will safely read the page after the migration entry is removed.
> >
> >> flush TLB
> >
> > Establish the new PTE/PMD after the flush removing the migration pte
> > entry and thereby avoiding the race.
>
> That is what this patch does.

If that is the case then this patch would not be needed and the tracking
of state in the mm_struct would not be necessary.
