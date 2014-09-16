Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaIPI5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:57:35 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:54239 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbaIPI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:57:32 -0400
Date: Tue, 16 Sep 2014 10:57:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCHv3 0/9] Mark literal strings in __init / __exit code
Message-ID: <20140916085727.GA4907@gmail.com>
References: <1408623792-7973-1-git-send-email-minipli@googlemail.com>
 <20140821125717.GA28987@gmail.com>
 <CA+rthh8XzSC-n+WaYEWiJQdF1XOSRiGSmxpJSFy9duXOOwXX_w@mail.gmail.com>
 <20140822082459.GA8771@gmail.com>
 <CA+rthh_tkpqYXJfnwCcAN5ULOHjiRp1EG7jceE1C2eLT-YJv8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rthh_tkpqYXJfnwCcAN5ULOHjiRp1EG7jceE1C2eLT-YJv8Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathias Krause <minipli@googlemail.com> wrote:

> > Regardless of how it's implemented on the tooling side, my 
> > point remains: this kind of optimization is done on the 
> > tooling side in a natural fashion, while it's an ongoing 
> > maintenance concern on the kernel side.
> 
> The costs of making the required changes to the code, i.e. 
> changing printk() / pr_*() to pi_*() / pe_*(), are a necessary 
> pain but are a one-time cost, as Joe already said. [...]

That argument is bogus - the costs form increased complexity are 
ongoing for all new code affected by such constructs, and they 
are an ongoing cost for all changes to the code as well.

> > So it should be done on the tooling side, especially as the 
> > benefits appear to be marginal.
> 
> But still, they are measurable. [...]

So is the cost of complexity measurable: we already got rid of 
__init annotation variants, and we want to keep it simple and 
maintainable, not litter the code with new variants again, only 
to be warned about in build time checks that few developers run.

And when it comes to weighing increased complexity against some 
marginal benefit, usually the simpler approach is preferred, 
especially since it could all be solved via tooling. Sure, you 
have to implement the tooling support for that, and have to wait 
for that to trickle through to actual build environments - but in 
turn that would benefit a lot more projects than the kernel 
alone. If you are impatient you could do tooling in the kernel as 
well, in tools/ for example.

Thanks,

	Ingo
