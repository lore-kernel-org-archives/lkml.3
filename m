Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbaDIJpt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 05:45:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36519 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758330AbaDIJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 05:45:35 -0400
Date: Wed, 9 Apr 2014 11:45:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Michele Ballabio <barra_cuda@katamail.com>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: Bisected KVM hang on x86-32 between v3.12 and v3.13
Message-ID: <20140409094515.GR11096@twins.programming.kicks-ass.net>
References: <5341707F.5000406@katamail.com>
 <20140407150337.GO10526@twins.programming.kicks-ass.net>
 <20140407150705.GB13658@twins.programming.kicks-ass.net>
 <5342EB78.3060002@gmx.de>
 <20140407185658.GK11096@twins.programming.kicks-ass.net>
 <20140408122128.GC13658@twins.programming.kicks-ass.net>
 <53450F7E.7040904@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53450F7E.7040904@canonical.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:14:38AM +0200, Stefan Bader wrote:
> On 08.04.2014 14:21, Peter Zijlstra wrote:
> > On Mon, Apr 07, 2014 at 08:56:58PM +0200, Peter Zijlstra wrote:
> >> On Mon, Apr 07, 2014 at 08:16:24PM +0200, Toralf Förster wrote:
> >>
> >>> v3.14-10353-g2b3a8fd works fine AFAICS
> >>> (BTW the fix is stable material, right ?)
> >>
> >> I'm fairly sure its not; its a rather invasive series; see:
> >>
> >> 2432e1364bbe x86: Nuke the supervisor_stack field in i386 thread_info
> >> b807902a88c4 x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386
> >> 0788aa6a23cb x86: Prepare removal of previous_esp from i386 thread_info structure
> >> 198d208df437 x86: Keep thread_info on thread stack in x86_32
> >>
> >> Let me see if there's anything 'simpler' we can stuff in .13+
> > 
> > OK.. so could someone test the below patch to see if that makes things
> > work for .13 and .14?
> 
> Hi Peter,
> 
> sorry I only had time to try 3.13 but that looks good. I was able to get kvm up
> and running for a longer than usual (without the patch) amount of time without
> seeing any softlockups.

Great, I suppose I should go write a changelog and talk to Greg about
how to get this into .13 and .14 stable.
