Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaLPT2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 14:28:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:49310 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLPT2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 14:28:17 -0500
Date: Tue, 16 Dec 2014 20:28:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Dave Jones <davej@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141216192803.GC3337@twins.programming.kicks-ass.net>
References: <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
 <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
 <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
 <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <alpine.DEB.2.11.1411212049220.6439@nanos>
 <CA+55aFzvgxAMpP7kr9qrxyo82vSucQ5G+VByOgsgoyq6y5ExOA@mail.gmail.com>
 <alpine.DEB.2.11.1411212110320.6439@nanos>
 <CA+55aFyt6q7Ed-SS9GeN8jeUZu6yNM14EGyH_8rn8AF2Vv37hg@mail.gmail.com>
 <alpine.DEB.2.11.1411212207150.6439@nanos>
 <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyzg=vJqRwh2CsK8WD-E5nRPjdiasMaTBx6qygQhDrGLA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 02:55:27PM -0800, Linus Torvalds wrote:
> On Fri, Nov 21, 2014 at 1:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > I'm fine with that. I just think it's not horrid enough, but that can
> > be fixed easily :)
> 
> Oh, I think it's plenty horrid.
> 
> Anyway, here's an actual patch. As usual, it has seen absolutely no
> actual testing, but I did try to make sure it compiles and seems to do
> the right thing on:
>  - x86-32 no-PAE
>  - x86-32 no-PAE with PARAVIRT
>  - x86-32 PAE
>  - x86-64
> 
> also, I just removed the noise that is "vmalloc_sync_all()", since
> it's just all garbage and nothing actually uses it. Yeah, it's used by
> "register_die_notifier()", which makes no sense what-so-ever.
> Whatever. It's gone.
> 
> Can somebody actually *test* this? In particular, in any kind of real
> paravirt environment? Or, any comments even without testing?
> 
> I *really* am not proud of the mess wrt the whole
> 
>   #ifdef CONFIG_PARAVIRT
>   #ifdef CONFIG_X86_32
>     ...
> 
> but I think that from a long-term perspective, we're actually better
> off with this kind of really ugly - but very explcit - hack that very
> clearly shows what is going on.
> 
> The old code that actually "walked" the page tables was more
> "portable", but was somewhat misleading about what was actually going
> on.
> 
> Comments?

While going through this thread I wondered whatever became of this
patch. It seems a shame to forget about it entirely. Maybe just queued
for later while hunting wabbits?
