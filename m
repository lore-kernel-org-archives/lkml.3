Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390AbaKUOUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:20:05 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:59979 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaKUOUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:20:01 -0500
Date: Fri, 21 Nov 2014 15:13:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121141332.GA8808@lerouge>
References: <alpine.DEB.2.11.1411192251120.3909@nanos>
 <20141119225615.GA11386@lerouge>
 <alpine.DEB.2.11.1411200002330.3909@nanos>
 <20141119235033.GE11386@lerouge>
 <20141120122339.GA14877@htj.dyndns.org>
 <alpine.DEB.2.11.1411202204030.3950@nanos>
 <20141120221122.GA25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411202315230.3950@nanos>
 <20141120230514.GB25393@htj.dyndns.org>
 <alpine.DEB.2.11.1411210109460.6439@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411210109460.6439@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:54:00AM +0100, Thomas Gleixner wrote:
> On Thu, 20 Nov 2014, Tejun Heo wrote:
> > Sure, this could have been better but I missed it at the beginning
> > and this is the first time I hear about this issue.
> 
> So the issues Frederic talked about in that very thread about
> recursive faults and the need that perf had to emulate percpu stuff in
> order to work around them have never been communicated to you?
> 
> I that's the case then that's not your problem, but a serious problem
> in our overall process.

So when the issue arised 4 years ago, it was a problem only for NMIs.
Like Linus says: "what happens in NMI stays in NMI". Ok no that's not quite
what he says :-)  But NMIs happen to be a corner case for about everything
and it's sometimes better to fix things from NMI itself, or have an NMI
special case rather than grow the whole infrastructure in complexity to
support this very corner case.

Not saying that's the only valid approach to take wrt. NMIs but those vmalloc faults
seemed to be well established and generally known (except perhaps for percpu)
and NMI was the only corner case, and we are used to that, so fixing the issue
for NMIs only felt like the right direction when we fixed the callchain thing
with other perf developers.

I certainly should have talked to Tejun about that but it took a bit of time
for me to realize that randomly faultable memory is a dangerous behaviour.

Add to that a bit of the "take the infrastrusture as granted" problem when
you're not well experienced enough...

Anyway, I really hope we fix that, that's a bomb waiting to explode.
