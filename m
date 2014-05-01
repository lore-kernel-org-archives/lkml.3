Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaEALLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:11:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48963 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006AbaEALLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:11:41 -0400
Date: Thu, 1 May 2014 12:10:43 +0100
From: Will Deacon <will.deacon@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140501111042.GD30166@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <20140417140036.GK11096@twins.programming.kicks-ass.net>
 <1397770618.32730.81.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397770618.32730.81.camel@pasglop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, Apr 17, 2014 at 10:36:58PM +0100, Benjamin Herrenschmidt wrote:
> On Thu, 2014-04-17 at 16:00 +0200, Peter Zijlstra wrote:
> 
> > So the non-relaxed ops already imply the expensive I/O barrier (mmiowb?)
> > and therefore, PPC can drop it from spin_unlock()?
> 
> We play a trick. We set a per-cpu flag in writeX and test it in unlock
> before doing the barrier. Still better than having the barrier in every
> MMIO at this stage for us.
> 
> Whether we want to change that with then new scheme ... we'll see.
> 
> > Also, I read mmiowb() as MMIO-write-barrier(), what do we have to
> > order/contain mmio-reads?
> > 
> > I have _0_ experience with MMIO, so I've no idea if ordering/containing
> > reads is silly or not. 
> 
> I will review the rest when I'm back from vacation (or maybe this
> week-end).

Did you get a chance to look at this? I've got a handful of Acks from other
architectures, and there's a bug to fix in the x86 patch but it seems daft
to send a v2 without talking about the fundamental rules of the accessors.

Cheers,

Will
