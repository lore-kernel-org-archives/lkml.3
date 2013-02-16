Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab3BPJlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 04:41:31 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:37491 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab3BPJl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 04:41:29 -0500
Message-ID: <1361007679.2580.10.camel@ThinkPad-T5421.cn.ibm.com>
Subject: Re: [RFC PATCH 2/5] powerpc: Exception hooks for context tracking
 subsystem
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org, paulus@samba.org
Date: Sat, 16 Feb 2013 17:41:19 +0800
In-Reply-To: <CAFTL4hzfXfCGDjwjW=Frcs5+jS_i3U_JHytNOEhEF5X7_Fw6Sg@mail.gmail.com>
References: <1359714465-6297-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1359714465-6297-3-git-send-email-zhong@linux.vnet.ibm.com>
	 <CAFTL4hzfXfCGDjwjW=Frcs5+jS_i3U_JHytNOEhEF5X7_Fw6Sg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021609-1618-0000-0000-00000359487C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-10 at 15:10 +0100, Frederic Weisbecker wrote:
> 2013/2/1 Li Zhong <zhong@linux.vnet.ibm.com>:
> > This is the exception hooks for context tracking subsystem, including
> > data access, program check, single step, instruction breakpoint, machine check,
> > alignment, fp unavailable, altivec assist, unknown exception, whose handlers
> > might use RCU.
> >
> > This patch corresponds to
> > [PATCH] x86: Exception hooks for userspace RCU extended QS
> >   commit 6ba3c97a38803883c2eee489505796cb0a727122
> >
> > Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> 
> Looks good!
> 
> I guess we should move exception_enter/exit definition to the generic
> code. They should be the same for all archs after all. 

Indeed.

> Also we are
> relying on user_mode(regs) but this may be buggy with some corner
> cases. For example if an exception happen after a call to user_exit()

I guess you mean user_enter() here, or am I confused?

> (on syscall exit) but before we actually resume in userspace, the
> exception will exit in kernel mode from the context tracking POV.
> 
> So instead on relying on the regs, which are not sync with the context
> tracking state, we should use something like:
> 
> prev_state = exception_enter();
> ...
> exception_exit(prev_state);
> 
> Also preempt_schedule_irq() is concerned as well by this problem. So I
> should convert it to that scheme as well. I'm going to prepare some
> patches.
> 
> Feel free to merge this patch in the powerpc tree, I'll do the
> conversion along the way.

Or if your patches gets merged earlier than these, I can update my code
according to yours.

Thanks, Zhong

> 
> Thanks.
> 


