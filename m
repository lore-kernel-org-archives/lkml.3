Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaB0QqO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:46:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbaB0QqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:46:13 -0500
Date: Thu, 27 Feb 2014 17:45:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com,
        riel@redhat.com, pbonzini@redhat.com, mingo@kernel.org,
        mgorman@suse.de, kirill.shutemov@linux.intel.com,
        heiko.carstens@de.ibm.com, hannes@cmpxchg.org, ebiederm@xmission.com,
        aarcange@redhat.com
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
	added to -mm tree
Message-ID: <20140227164524.GB909@redhat.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com> <20140226145025.GA12571@redhat.com> <530E0306.7020601@de.ibm.com> <20140226153144.GA15527@redhat.com> <20140226165759.GB22802@laptop.programming.kicks-ass.net> <20140226172253.GQ3041@sgi.com> <20140226180603.GA25644@redhat.com> <20140226200535.5fdf4c25@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226200535.5fdf4c25@thinkpad>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Gerald Schaefer wrote:
>
> On Wed, 26 Feb 2014 19:06:03 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > It would be nice to also change thp_split_mm() to not not play with
> > mm->def_flags, but I am not sure if we can do this.
>
> Hmm, I'm also wondering about this. Basically, we only need VM_NOHUGEPAGE
> in vma->vm_flags, which is done for all existing vmas in thp_split_mm().
> But if there should be new vmas created afterwards, it would still be
> necessary to also have VM_NOHUGEPAGE in mm->def_flags, because the
> vm_flags for new vmas will be set via OR of mm->def_flags, e.g. in
> do_brk() and do_mmap_pgoff().

Yes, exactly, this was my concern.

And while I know nothing about s390, it seems to me that huge pages should
be forbidden for any vma if ->has_pgste was set.

> Anyway, this would then have to be a separate patch, to keep the
> "revertability" of this hack.

Agreed. Thanks!

Oleg.

