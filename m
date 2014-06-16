Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaFPPWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:22:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaFPPW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:22:29 -0400
Date: Mon, 16 Jun 2014 11:21:47 -0400
From: Don Zickus <dzickus@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, acme@kernel.org,
        mingo@redhat.com, paulus@samba.org, hpa@zytor.com, tglx@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org, matt@console-pimps.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
Message-ID: <20140616152147.GI177152@redhat.com>
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

Just to add to the mix, we (Red Hat) has a customer with the same
problem.  I told them to fight it out with Intel to figure out why that
bit is non-zero at boot.  Partly because I didn't feel like send a patch
upstream and feel the wrath of Peter Z. descend upon me. :-)

So if this patch is acceptable, I would ack it as it fixes our customer's
problem too.

Cheers,
Don

