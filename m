Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3BKKEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:04:45 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53591 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3BKKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:04:44 -0500
Date: Mon, 11 Feb 2013 11:04:39 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Shuah Khan <shuah.khan@hp.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, avi@redhat.com, mtosatti@redhat.com, mst@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH linux-next] x86/kvm: Fix compile warning in
 kvm_register_steal_time()
Message-ID: <20130211100439.GH23932@gmail.com>
References: <1360119442.8356.8.camel@lorien2>
 <20130211090626.GV7837@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130211090626.GV7837@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gleb Natapov <gleb@redhat.com> wrote:

> On Tue, Feb 05, 2013 at 07:57:22PM -0700, Shuah Khan wrote:
> > Fix the following compile warning in kvm_register_steal_time():
> >   CC      arch/x86/kernel/kvm.o
> > arch/x86/kernel/kvm.c: In function ?kvm_register_steal_time?:
> > arch/x86/kernel/kvm.c:302:3: warning: format ?%lx? expects argument of type ?long unsigned int?, but argument 3 has type ?phys_addr_t? [-Wformat]
> > 
> Ingo, the warning is from the tip tree. Can you take the fix?

Yeah, it came via these x86 improvements to __pa():

5dfd486c4750 x86, kvm: Fix kvm's use of __pa() on percpu areas
d76565344512 x86, mm: Create slow_virt_to_phys()
f3c4fbb68e93 x86, mm: Use new pagetable helpers in try_preserve_large_page()
4cbeb51b860c x86, mm: Pagetable level size/shift/mask helpers
a25b9316841c x86, mm: Make DEBUG_VIRTUAL work earlier in boot

So up the fix - I added an Acked-by from you as well, is that 
fine with you?

Thanks,

	Ingo
