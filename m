Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3A0Mtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:49:50 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:34189 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A0Mtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:49:46 -0500
Date: Sun, 27 Jan 2013 13:49:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jan Beulich <jbeulich@suse.com>, ling.ml@alipay.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/defconfig: Turn on
 CONFIG_CC_OPTIMIZE_FOR_SIZE= y in the 64-bit defconfig
Message-ID: <20130127124942.GB3933@gmail.com>
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
 <tip-d94ffd677469ef729e9d6e968191872577a6119e@git.kernel.org>
 <20130126125208.GC21395@pd.tnic>
 <8b0dfc4a-6f9c-498a-9844-4d99deb3052f@email.android.com>
 <CA+55aFyskO6NMhgkwRNv4wXB=D97VS54_oZw0k_o4nQFso6p-Q@mail.gmail.com>
 <1359234167.17639.3.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359234167.17639.3.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 2013-01-26 at 11:43 -0800, Linus Torvalds wrote:
> 
> > The problem, of course, is that most -O2 code generation is done
> > assuming hot loops that don't show much if any I$ issues. And the -Os
> > thing is done *purely* for size, not taking any performance into
> > account at all. There's no balanced middle ground, which is what _we_
> > would want.
> 
> Gcc needs to implement a -Olinus

What we really want is a sane default for 'library code' 
optimization:

 - cache-cold optimizations for run-through-once non-looping 
   code (-Os)

 - good loop optimizations for anything that arguably loops (-O2)

 - plus common-sense fixes to -Os like not throwing away 
   explicit branch hints we go to great pains to insert.

Possibly some time this decade.

Thanks,

	Ingo
