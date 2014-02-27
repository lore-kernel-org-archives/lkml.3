Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaB0Qe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:34:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbaB0Qe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:34:56 -0500
Date: Thu, 27 Feb 2014 17:34:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, schwidefsky@de.ibm.com, rientjes@google.com,
        riel@redhat.com, mingo@kernel.org, mgorman@suse.de,
        kirill shutemov <kirill.shutemov@linux.intel.com>,
        heiko carstens <heiko.carstens@de.ibm.com>, hannes@cmpxchg.org,
        gerald schaefer <gerald.schaefer@de.ibm.com>, ebiederm@xmission.com,
        aarcange@redhat.com
Subject: Re: + mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
	added to -mm tree
Message-ID: <20140227163405.GA909@redhat.com>
References: <530d2ce9.eikv0ULecNwxF4I5%akpm@linux-foundation.org> <530D9F50.1080400@de.ibm.com> <20140226145025.GA12571@redhat.com> <530E0306.7020601@de.ibm.com> <20140226153144.GA15527@redhat.com> <20140226165759.GB22802@laptop.programming.kicks-ass.net> <20140226172253.GQ3041@sgi.com> <20140226180603.GA25644@redhat.com> <842178473.10219645.1393447292444.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <842178473.10219645.1393447292444.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Paolo Bonzini wrote:
>
> > +#ifdef CONFIG_S390
> > +		/*
> > +		 * MADV_HUGEPAGE is broken after s390_enable_sie(), qemu
> > +		 * blindly does madvise(MADV_HUGEPAGE) for for all kvm pages
> > +		 * and expects it must fail on s390. Avoid a possible SIGSEGV
> > +		 * until qemu is changed.
> > +		 */
> > +		if (mm_has_pgste(vma->vm_mm))
> > +			return -EINVAL;
> > +#endif
>
> The comment is not quite true.  QEMU doesn't expect that the madvise fails.

Yes, sorry. I didn't mean "it expects -EINVAL".

> It simply expects that the madvise doesn't cause SIGSEGVs or later
> malfunctioning, because (quoting tha man page) madvise "does not influence
> the semantics of the application".

Yes, I understand. But currently this means "MADV_HUGEPAGE should not
actually work", this is what I tried to say.

> There's nothing to fix in QEMU,

I was going to argue, but this is probably true too.

In short: I agree with any comment ;)

Oleg.

