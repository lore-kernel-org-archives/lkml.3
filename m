Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbbAFPCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:02:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbbAFPCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:02:19 -0500
Date: Tue, 6 Jan 2015 10:01:57 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyril Bur <cyrilbur@gmail.com>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, drjones@redhat.com,
        akpm@linux-foundation.org, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org, mtosatti@redhat.com
Subject: Re: [PATCH 0/2] Quieten softlockup detector on virtualised kernels
Message-ID: <20150106150157.GF116159@redhat.com>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
 <20150105165057.GU116159@redhat.com>
 <1420502015.2910.6.camel@cyril>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420502015.2910.6.camel@cyril>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:53:35AM +1100, Cyril Bur wrote:
> On Mon, 2015-01-05 at 11:50 -0500, Don Zickus wrote:
> > cc'ing Marcelo
> > 
> > On Mon, Dec 22, 2014 at 04:06:02PM +1100, Cyril Bur wrote:
> > > When the hypervisor pauses a virtualised kernel the kernel will observe a jump
> > > in timebase, this can cause spurious messages from the softlockup detector.
> > > 
> > > Whilst these messages are harmless, they are accompanied with a stack trace
> > > which causes undue concern and more problematically the stack trace in the
> > > guest has nothing to do with the observed problem and can only be misleading.
> > > 
> > > Futhermore, on POWER8 this is completely avoidable with the introduction of
> > > the Virtual Time Base (VTB) register.
> > 
> > Hi Cyril,
> > 
> > Your solution seems simple and doesn't disturb the softlockup code as much
> > as the x86 solution does.  The only small issue I had was the use of
> > sched_clock instead of local_clock.  I keep forgetting the difference
> > (unstable clock is the biggest reason I think).
> My apologies there it appears I stuffed up, local_clock was used
> initially in the softlockup code, I'll send a v2.

Thanks!

> 
> > Other than that, I am not the biggest fan of putting multiple virtual
> > guest solutions for the same problem into the watchdog code.  I would
> > prefer a common solution/framework to leverage.
> Agreed.
> 
> > I have the x86 folks focusing on the steal_time stuff.  It started with
> > KVM and I believe VMWare is working on utilizing it too (and maybe Xen).
> I'm not sure I've ever seen this, could you please point me towards
> something I can look at?

I am not too familar with it, but the kernel/watchdog.c code has calls to
kvm_check_and_clear_guest_paused(), which is probably a good place to
start.

Cheers,
Don

> 
> > Not sure if that is useful or could be incoporated into the power8 code.
> > Though to be honest I am curious if the steal_time code could be ported to
> > your solution as it seems the watchdog code could remove all the
> > steal_time warts.
> Happy to help sus out the situation here, again, if you could pass on
> what the x86 guys are working on, thanks.
> 
> 
> Thanks,
> 
> Cyril
> > I have cc'd Marcelo into this discussion as he was the last person I
> > remember talking with about this problem.
> > 
> > Cheers,
> > Don
> 
> 
