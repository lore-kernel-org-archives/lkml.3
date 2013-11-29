Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab3K2UfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 15:35:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab3K2UfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 15:35:07 -0500
Date: Fri, 29 Nov 2013 21:35:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131129203550.GA14723@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org> <20131129183558.GA9803@redhat.com> <20131129195419.GB17656@two.firstfloor.org> <20131129200532.GA13561@redhat.com> <5298F66A.2010600@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5298F66A.2010600@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29, H. Peter Anvin wrote:
>
> On 11/29/2013 12:05 PM, Oleg Nesterov wrote:
> >
> > Can't we invalidate pte (so that any user will stuck in page fault),
> > update the page(s), restore the pte and drop the locks?
> >
>
> That would require a global TLB shootdown

Well, it is not really global, it is for mm_cpumask() and for good
reason?

And is it really worse than on_each_cpu(do_sync_core) and the usage
of text_mutex?

> (and wouldn't help
> shared-memory code segments, if we care about that at all.)

Well, I think this should only support the private mappings.

> It also
> means much bigger code ranges would be affected.

Yes, this is true.

Oleg.

