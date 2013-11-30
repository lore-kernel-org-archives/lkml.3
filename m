Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3K3Oz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 09:55:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab3K3Oz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 09:55:57 -0500
Date: Sat, 30 Nov 2013 15:56:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131130145642.GB15790@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <5298F66A.2010600@zytor.com> <20131129203550.GA14723@redhat.com> <529905F9.30703@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529905F9.30703@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, H. Peter Anvin wrote:
>
> On 11/29/2013 12:35 PM, Oleg Nesterov wrote:
> > On 11/29, H. Peter Anvin wrote:
> >>
> >> On 11/29/2013 12:05 PM, Oleg Nesterov wrote:
> >>>
> >>> Can't we invalidate pte (so that any user will stuck in page fault),
> >>> update the page(s), restore the pte and drop the locks?
> >>
> >> That would require a global TLB shootdown
> >
> > Well, it is not really global, it is for mm_cpumask() and for good
> > reason?
> >
> > And is it really worse than on_each_cpu(do_sync_core) and the usage
> > of text_mutex?
> >
>
> Probably not, but one would have to consider the total amount of
> synchronization needed.

Yes, agreed, this should be justified.

> >> (and wouldn't help
> >> shared-memory code segments, if we care about that at all.)
> >
> > Well, I think this should only support the private mappings.
> >
>
> Well, what do you do if someone tries this on a MAP_SHARED mapping?
> Error out?

Imho yes. But this needs more discussion, and afaics this is a bit
offtopic.

Please note that this patch relies on bp_target_mm, this can't help
in VM_SHARED case too.

Oleg.

