Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3BKKGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab3BKKGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:06:04 -0500
Date: Mon, 11 Feb 2013 12:05:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Shuah Khan <shuah.khan@hp.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, avi@redhat.com, mtosatti@redhat.com, mst@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH linux-next] x86/kvm: Fix compile warning in
 kvm_register_steal_time()
Message-ID: <20130211100556.GX7837@redhat.com>
References: <1360119442.8356.8.camel@lorien2>
 <20130211090626.GV7837@redhat.com>
 <20130211100439.GH23932@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211100439.GH23932@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:04:39AM +0100, Ingo Molnar wrote:
> 
> * Gleb Natapov <gleb@redhat.com> wrote:
> 
> > On Tue, Feb 05, 2013 at 07:57:22PM -0700, Shuah Khan wrote:
> > > Fix the following compile warning in kvm_register_steal_time():
> > >   CC      arch/x86/kernel/kvm.o
> > > arch/x86/kernel/kvm.c: In function ?kvm_register_steal_time?:
> > > arch/x86/kernel/kvm.c:302:3: warning: format ?%lx? expects argument of type ?long unsigned int?, but argument 3 has type ?phys_addr_t? [-Wformat]
> > > 
> > Ingo, the warning is from the tip tree. Can you take the fix?
> 
> Yeah, it came via these x86 improvements to __pa():
> 
> 5dfd486c4750 x86, kvm: Fix kvm's use of __pa() on percpu areas
> d76565344512 x86, mm: Create slow_virt_to_phys()
> f3c4fbb68e93 x86, mm: Use new pagetable helpers in try_preserve_large_page()
> 4cbeb51b860c x86, mm: Pagetable level size/shift/mask helpers
> a25b9316841c x86, mm: Make DEBUG_VIRTUAL work earlier in boot
> 
> So up the fix - I added an Acked-by from you as well, is that 
> fine with you?
> 
Yes, of course. Thank you.

--
			Gleb.
