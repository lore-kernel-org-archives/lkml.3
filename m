Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3IEM6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:58:13 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64320 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3IEM6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:58:12 -0400
Date: Thu, 5 Sep 2013 14:58:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf changes for v3.12
Message-ID: <20130905125807.GC20519@somewhere>
References: <20130903132933.GA24955@gmail.com>
 <CA+55aFyyJpCC0EFfPpGYi+6goWbA+LZbrkFcLNW3x8xYHfKvdQ@mail.gmail.com>
 <20130905105639.GB21407@gmail.com>
 <20130905124242.GB20519@somewhere>
 <20130905125101.GA23591@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905125101.GA23591@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 02:51:01PM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > > Btw., a side note, append_chain() is a rather confusing function in 
> > > itself, with logic-inversion gems like:
> > > 
> > >                 if (!found)
> > >                         found = true;
> > 
> > The check is pointless yeah, I'll remove that.
> 
> Are you sure it can be removed as-is? It inverts the 'found' condition, 
> which then can be used later on AFAICS. (I haven't looked very deeply 
> though.)

Yeah in fact found is initialized to false. So the if (!found) is always true there.
May be it's a leftover from past version that relied on gotos or so.
