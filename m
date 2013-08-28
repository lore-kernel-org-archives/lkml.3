Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab3H1Uuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:50:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab3H1Uuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:50:44 -0400
Date: Wed, 28 Aug 2013 13:50:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v3 1/4] idr: Percpu ida
Message-Id: <20130828135042.9e460b27699b52bb4eb53d9e@linux-foundation.org>
In-Reply-To: <20130828204454.GC1357@kmo-pixel>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
	<1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
	<20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
	<20130828195317.GE8032@kmo-pixel>
	<20130828132332.6d5263ee9622235ae0fcc615@linux-foundation.org>
	<20130828204454.GC1357@kmo-pixel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 13:44:54 -0700 Kent Overstreet <kmo@daterainc.com> wrote:

> > > > What guarantees that this wait will terminate?
> > > 
> > > It seems fairly clear to me from the break statement a couple lines up;
> > > if we were passed __GFP_WAIT we terminate iff we succesfully allocated a
> > > tag. If we weren't passed __GFP_WAIT we never actually sleep.
> > 
> > OK ;)  Let me rephrase.  What guarantees that a tag will become available?
> > 
> > If what we have here is an open-coded __GFP_NOFAIL then that is
> > potentially problematic.
> 
> It's the same semantics as a mempool, really - it'll succeed when a tag
> gets freed.

OK, that's reasonable if the code is being used to generate IO tags -
we expect the in-flight tags to eventually be returned.

But if a client of this code is using the allocator for something
totally different, there is no guarantee that the act of waiting will
result in any tags being returned.

(These are core design principles/constraints which should be
explicitly documented in a place where future readers will see them!)

