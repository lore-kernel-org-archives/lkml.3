Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaAUOjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 09:39:45 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43394 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbaAUOjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 09:39:43 -0500
Date: Tue, 21 Jan 2014 15:39:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140121143939.GA4643@gmail.com>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
 <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
 <52DDAD9D.9030504@zytor.com>
 <20140121090003.GO31570@twins.programming.kicks-ass.net>
 <52DE8231.6080408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DE8231.6080408@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/21/2014 01:00 AM, Peter Zijlstra wrote:
> >>
> >> So this is presumably something that needs to be fixed in perf?
> > 
> > Where do we learn about the offset from userspace?
> > 
> 
> Now this is tricky... if this offset is too easy to get it 
> completely defeats kASLR.  On the other hand, I presume that if we 
> are exporting /proc/kcore we're not secure anyway.  Kees, I assume 
> that in "secure" mode perf annotations simply wouldn't work anyway?

So /proc/kcore is:

  aldebaran:~> ls -l /proc/kcore 
  -r-------- 1 root root 140737486266368 Jan 21 15:35 /proc/kcore

i.e. root only.

The thing is, one of my first remarks on this whole KASLR series was 
that tooling needs to work. I suggested that the kernel should only 
expose non-randomized addresses and that all facilities need to 
continue to 'just work' with those. That argument was ignored AFAICS 
and the problem still isn't solved.

I'd argue that solving it in the kernel instead of making all tooling 
variants aware of KASLR one by one is a far more intelligent and 
efficient solution ...

Thanks,

	Ingo
