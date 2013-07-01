Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3GAWob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:44:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36311 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736Ab3GAWoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:44:30 -0400
Date: Tue, 2 Jul 2013 00:44:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130701224421.GL23515@pd.tnic>
References: <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
 <20130630220004.GA23124@pd.tnic>
 <20130701075046.GB1681@gmail.com>
 <20130701102306.GC23515@pd.tnic>
 <20130701111122.GA18772@gmail.com>
 <20130701122954.GD23515@pd.tnic>
 <20130701125045.GA24336@gmail.com>
 <20130701144851.GH23515@pd.tnic>
 <20130701222802.GK23515@pd.tnic>
 <CANeycqoq8LwLMoXEYdPE6m9eKVB7pRLw1hkSCjJ=jjDj9ej-Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANeycqoq8LwLMoXEYdPE6m9eKVB7pRLw1hkSCjJ=jjDj9ej-Cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 03:35:47PM -0700, Wedson Almeida Filho wrote:
> On Mon, Jul 1, 2013 at 3:28 PM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > perf stat --repeat 10 -a --sync --pre 'make -s clean; echo 1 > /proc/sys/vm/drop_caches' make -s -j64 bzImage
> 
> How many CPUs do you have in your system? Maybe -j64 vs -jNUM_CPUs
> affects your measurements as well.

8. But that shouldn't matter since I made the non-differing measurements two
mails back with -j64.

Also -j9, i.e. -j$(($NUM_CPUS+1)) gives "121.613217871 seconds time
elapsed" because with -j9 the probability of some core not executing a
make thread for whatever reason is higher than with -j64. But it is only
as high as an additional 1s with this workload.

I think with -j64 Ingo meant to saturate the scheduler to make sure
there always are runnable threads more than cores available so that we
can maximize the core utilization with threads running our workload.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
