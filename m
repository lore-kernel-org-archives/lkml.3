Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbbAEQvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 11:51:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbbAEQvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 11:51:22 -0500
Date: Mon, 5 Jan 2015 11:50:57 -0500
From: Don Zickus <dzickus@redhat.com>
To: Cyril Bur <cyrilbur@gmail.com>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, drjones@redhat.com,
        akpm@linux-foundation.org, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org, mtosatti@redhat.com
Subject: Re: [PATCH 0/2] Quieten softlockup detector on virtualised kernels
Message-ID: <20150105165057.GU116159@redhat.com>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing Marcelo

On Mon, Dec 22, 2014 at 04:06:02PM +1100, Cyril Bur wrote:
> When the hypervisor pauses a virtualised kernel the kernel will observe a jump
> in timebase, this can cause spurious messages from the softlockup detector.
> 
> Whilst these messages are harmless, they are accompanied with a stack trace
> which causes undue concern and more problematically the stack trace in the
> guest has nothing to do with the observed problem and can only be misleading.
> 
> Futhermore, on POWER8 this is completely avoidable with the introduction of
> the Virtual Time Base (VTB) register.

Hi Cyril,

Your solution seems simple and doesn't disturb the softlockup code as much
as the x86 solution does.  The only small issue I had was the use of
sched_clock instead of local_clock.  I keep forgetting the difference
(unstable clock is the biggest reason I think).

Other than that, I am not the biggest fan of putting multiple virtual
guest solutions for the same problem into the watchdog code.  I would
prefer a common solution/framework to leverage.

I have the x86 folks focusing on the steal_time stuff.  It started with
KVM and I believe VMWare is working on utilizing it too (and maybe Xen).

Not sure if that is useful or could be incoporated into the power8 code.
Though to be honest I am curious if the steal_time code could be ported to
your solution as it seems the watchdog code could remove all the
steal_time warts.

I have cc'd Marcelo into this discussion as he was the last person I
remember talking with about this problem.

Cheers,
Don
