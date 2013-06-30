Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3F3WAO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 18:00:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35664 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab3F3WAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 18:00:12 -0400
Date: Mon, 1 Jul 2013 00:00:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130630220004.GA23124@pd.tnic>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 04:56:30PM -0700, Wedson Almeida Filho wrote:
> On Fri, Jun 28, 2013 at 7:09 AM, Borislav Petkov <bp@alien8.de> wrote:
> 
> > Btw, do we have any perf data showing any improvements from this patch?
> 
> I wrote a simple test the measures the time it takes to acquire and
> release  an uncontended mutex (i.e., we always take the fast path)
> 100k times. I ran it a few times, the original code averages
> 2.743436ms, and the new code averages 2.101098ms, so it's about 23% improvement.

Microbenchmark results tend to be misleading in such situations. Rather,
it would be much closer to reality if you traced a real workload like a
simple kernel build, for example, with and without your patch.

I.e., something like

perf stat --repeat 5 ./build-kernel.sh

and take a look at what the perfcouters are saying in both cases.

> I also think the code looks cleaner this way.

No doubt.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
