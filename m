Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3GAHuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 03:50:51 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:36502 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3GAHuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 03:50:50 -0400
Date: Mon, 1 Jul 2013 09:50:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130701075046.GB1681@gmail.com>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
 <20130630220004.GA23124@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130630220004.GA23124@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Jun 29, 2013 at 04:56:30PM -0700, Wedson Almeida Filho wrote:
> > On Fri, Jun 28, 2013 at 7:09 AM, Borislav Petkov <bp@alien8.de> wrote:
> > 
> > > Btw, do we have any perf data showing any improvements from this patch?
> > 
> > I wrote a simple test the measures the time it takes to acquire and
> > release  an uncontended mutex (i.e., we always take the fast path)
> > 100k times. I ran it a few times, the original code averages
> > 2.743436ms, and the new code averages 2.101098ms, so it's about 23% improvement.
> 
> Microbenchmark results tend to be misleading in such situations. Rather, 
> it would be much closer to reality if you traced a real workload like a 
> simple kernel build, for example, with and without your patch.

Not sure - the main thing we want to know is whether it gets faster. The 
_amount_ will depend on things like precise usage patterns, caching, etc. 
- but rarely does a real workload turn a win like this into a loss.

> I.e., something like
> 
> perf stat --repeat 5 ./build-kernel.sh
> 
> and take a look at what the perfcouters are saying in both cases.

Hm, the noise of such a workload will very likely drown out improvements 
that are in the cycle scale.

Thanks,

	Ingo
