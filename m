Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaAUJAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 04:00:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:46505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaAUJAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 04:00:41 -0500
Date: Tue, 21 Jan 2014 10:00:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140121090003.GO31570@twins.programming.kicks-ass.net>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
 <CA+55aFyxisSNKstMuanfrkhu5=2bxcu2cxZxMg38Zw0HAoXppg@mail.gmail.com>
 <CA+55aFyaf2B4Fo-dCJUJ=03aPVdLF7r4uMYNduYPMFwJQYngcA@mail.gmail.com>
 <52DDAD9D.9030504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DDAD9D.9030504@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 03:13:33PM -0800, H. Peter Anvin wrote:
> On 01/20/2014 03:12 PM, Linus Torvalds wrote:
> > On Mon, Jan 20, 2014 at 2:54 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >> So I pulled this, but one question:
> > 
> > .. oh, and since I decided to test it, and was looking for problems:
> > enabling kaslr breaks "perf". The *profile* looks fine, but the
> > disassembly doesn't work.
> > 
> > I'm not entirely surprised. I decided I wanted to test it for a
> > reason, after all. So it's not unexpected, but perhaps people hadn't
> > thought about it, and clearly hadn't tested it.
> > 
> > Kernel modules disassemble fine, so clearly perf knows about code that
> > moves around, but apparently it gets surprised when the core vmlinux
> > file disassembly doesn't match addresses.
> > 
> 
> So this is presumably something that needs to be fixed in perf?

Where do we learn about the offset from userspace?
