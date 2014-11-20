Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbaKTXj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 18:39:26 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:62422 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbaKTXjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 18:39:24 -0500
Date: Thu, 20 Nov 2014 18:39:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120233920.GC25393@htj.dyndns.org>
References: <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUu56pLObcDxrNXO5uN_KV5ffDW3EkpLgZL2mh4-aofSQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 03:08:03PM -0800, Andy Lutomirski wrote:
> > So, for now, all we need is adding nmi check in percpu accessors,
> > right?
> >
> 
> What's the issue with nmi?  Page faults are supposed to nest correctly
> inside nmi, right?

Thought they couldn't.  Looking at the trace that Frederic linked, it
looks like straight-out tracing function recursion due to an
unexpected fault while holding a lock.  I don't think this can be
annotated from percpu accessor side.  There's nothing special about
the context.  :(

Does this matter for anybody other than tracers?  Ultimately, the
solution would be removing the vmalloc area faulting as Thomas
suggested.

Thanks.

-- 
tejun
