Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaBZSI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:08:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaBZSI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:08:56 -0500
Date: Wed, 26 Feb 2014 19:08:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        schwidefsky@de.ibm.com, rientjes@google.com, riel@redhat.com,
        pbonzini@redhat.com, mingo@kernel.org, mgorman@suse.de,
        kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com,
        hannes@cmpxchg.org, gerald.schaefer@de.ibm.com, ebiederm@xmission.com,
        aarcange@redhat.com, athorlton@sgi.com
Subject: Re: +
	mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch added
	to -mm tree
Message-ID: <20140226180807.GB25644@redhat.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com> <20140226145025.GA12571@redhat.com> <530E0306.7020601@de.ibm.com> <20140226153144.GA15527@redhat.com> <20140226165759.GB22802@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226165759.GB22802@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Peter Zijlstra wrote:
>
> On Wed, Feb 26, 2014 at 04:31:44PM +0100, Oleg Nesterov wrote:
> >  		/*
> > @@ -1977,8 +1975,12 @@ int hugepage_madvise(struct vm_area_stru
> >  		 */
> >  		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
> >  			return -EINVAL;
> > -		if (mm->def_flags & VM_NOHUGEPAGE)
> > +
> > +#ifdef CONFIG_S390
>
> Do we want a comment here, explaining why s390 is special again?

Yes, yes, sure. Especially because this is (hopefully) the temporary
hack.

Oleg.

