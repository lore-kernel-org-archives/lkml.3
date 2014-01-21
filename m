Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbaAUOwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:52:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36827 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaAUOwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:52:43 -0500
Message-ID: <52DE8989.1010208@zytor.com>
Date: Tue, 21 Jan 2014 06:51:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org> <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com> <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com> <52DDAD9D.9030504@zytor.com> <20140121090003.GO31570@twins.programming.kicks-ass.net> <52DE8231.6080408@zytor.com> <20140121143939.GA4643@gmail.com>
In-Reply-To: <20140121143939.GA4643@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2014 06:39 AM, Ingo Molnar wrote:
>>
>> Now this is tricky... if this offset is too easy to get it 
>> completely defeats kASLR.  On the other hand, I presume that if we 
>> are exporting /proc/kcore we're not secure anyway.  Kees, I assume 
>> that in "secure" mode perf annotations simply wouldn't work anyway?
> 
> So /proc/kcore is:
> 
>   aldebaran:~> ls -l /proc/kcore 
>   -r-------- 1 root root 140737486266368 Jan 21 15:35 /proc/kcore
> 
> i.e. root only.
> 

Yes, I mean if we want to be sealed against user space intrusion I'm
assuming /proc/kcore is unavailable, but that we don't

> The thing is, one of my first remarks on this whole KASLR series was 
> that tooling needs to work. I suggested that the kernel should only 
> expose non-randomized addresses and that all facilities need to 
> continue to 'just work' with those. That argument was ignored AFAICS 
> and the problem still isn't solved.
> 
> I'd argue that solving it in the kernel instead of making all tooling 
> variants aware of KASLR one by one is a far more intelligent and 
> efficient solution ...

Not ignored, but found not to really work all that well (we had that
discussion in the context of relocated kernels, too.)  The problem you
end up with is that as soon as you run into situations where you have to
deal with pointers during debugging, be it using kgdb, stack dumps or
whatever, all the work that you have done in the kernel to try to hide
relocation from the debug infrastructure all of a sudden becomes a huge
liability, and ends up backfiring in a horrific way.

	-hpa

