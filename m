Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaFPPjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbaFPPjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:39:17 -0400
Date: Mon, 16 Jun 2014 11:38:44 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, acme@kernel.org,
        mingo@redhat.com, paulus@samba.org, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org, matt@console-pimps.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
Message-ID: <20140616153843.GK177152@redhat.com>
References: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
 <20140611085448.GI3213@twins.programming.kicks-ass.net>
 <20140611115413.GE3588@twins.programming.kicks-ass.net>
 <20140612.160011.167980216.d.hatayama@jp.fujitsu.com>
 <20140612073716.GR6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612073716.GR6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 09:37:16AM +0200, Peter Zijlstra wrote:
> On Thu, Jun 12, 2014 at 04:00:11PM +0900, HATAYAMA Daisuke wrote:
> > Also, I checked cpuid on the system with Neharlem processor where I
> > have never seen CondChg bit is set.
> > 
> > [root@localhost ~]# ./cpuid -r
> > CPU 0:
> >    0x00000000 0x00: eax=0x0000000b ebx=0x756e6547 ecx=0x6c65746e edx=0x49656e69
> >    0x00000001 0x00: eax=0x000206e6 ebx=0x40200800 ecx=0x00bce3bd edx=0xbfebfbff
> > <snip>
> >    0x0000000a 0x00: eax=0x07300403 ebx=0x00000044 ecx=0x00000000 edx=0x00000603
> >                     ^^^^^^^^^^^^^^
> > So, cpuid tells that CondChg bit is supported on this processor, too.
> 
> Yeah, I can't remember ever seeing that bit on nhm/wsm either. Weird
> stuff that.

Just to add before I forget, this problem has been around for awhile as it
was explained to me.  The reason why it was never reported is because (in
our customer case), the nmi_watchdog clears the register after about 10
seconds after boot.  Most machines do not tend to send external NMIs the
first 10 seconds after booting.  Our customer saw it because he happened
to purposely press his external NMI button to trigger a panic with the
nmi_watchdog disabled and the watchdog happened to be disabled because we
were debugging a kdump problem.

Cheers,
Don



> 
> > > In any case, the proposed patch seems fine, just needs a better
> > > changelog.
> > > 
> > 
> > I see.
> > 
> > I'll write that the problem is that any NMI could be robbed by NMI
> > watchdog explicitly. Now only patch title says this explicitly. This
> > is your first comment.
> 
> Yeah, since that is the actual problem, its good to be clear on that.
> 
> > About CondChgd bit, I cannot write more than I see on actual
> > system. If it's necessary to describe more about CondChgd bit, it
> > would be appreciated if someone tell me more information about it.
> 
> I think we've found all 2 sentences the SDM has about that and unless
> someone from Intel is going to come and explain why they wasted precious
> silicon on this I suppose it will remain a mystery. No need to update on
> that.


