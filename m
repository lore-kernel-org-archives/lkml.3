Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaFBQwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:52:35 -0400
Received: from one.firstfloor.org ([193.170.194.197]:52288 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaFBQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:52:34 -0400
Date: Mon, 2 Jun 2014 18:52:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Gleb Natapov <gleb@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        peterz@infradead.org, pbonzini@redhat.com, eranian@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH 4/4] kvm: Implement PEBS virtualization
Message-ID: <20140602165231.GP25366@two.firstfloor.org>
References: <1401412327-14810-1-git-send-email-andi@firstfloor.org>
 <1401412327-14810-5-git-send-email-andi@firstfloor.org>
 <20140530082136.GA4715@minantech.com>
 <20140530162424.GC8876@tassilo.jf.intel.com>
 <20140602164534.GD4715@minantech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602164534.GD4715@minantech.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW I found some more problems in the v1 version.

> > > With EPT it is less likely to happen (but still possible IIRC depending on memory
> > > pressure and how much memory shadow paging code is allowed to use), without EPT
> > > it will happen for sure.
> > 
> > Don't care about the non EPT case, this is white listed only for EPT supporting 
> > CPUs.
> User may still disable EPT during module load, so pebs should be dropped
> from a guest's cpuid in this case.

Ok.

> 
> > 
> > > There is nothing, as far as I can see, that says what will happen if the
> > > condition is not met. I always interpreted it as undefined behaviour so
> > > anything can happen including CPU dies completely.  You are saying above
> > > on one hand that CPU cannot handle any kinds of faults during write to
> > > DS area, but on the other hand a guest could only crash itself. Is this
> > > architecturally guarantied?
> > 
> > You essentially would get random page faults, and the PEBS event will
> > be cancelled. No hangs.
> Is this a guest who will get those random page faults or a host?

The guest (on the white listed CPU models)

-Andi
