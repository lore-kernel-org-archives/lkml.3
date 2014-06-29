Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaF2Gqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 02:46:34 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:49632 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaF2Gqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 02:46:32 -0400
Date: Sun, 29 Jun 2014 09:46:27 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
Message-ID: <20140629064626.GD18167@minantech.com>
References: <20140625153227.GA13845@pd.tnic>
 <20140625202650.GC13845@pd.tnic>
 <20140627101831.GB23153@pd.tnic>
 <53AD586A.40900@redhat.com>
 <20140627115545.GC23153@pd.tnic>
 <53AD5D27.2090505@redhat.com>
 <20140627121053.GD23153@pd.tnic>
 <20140628114431.GB4373@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140628114431.GB4373@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 01:44:31PM +0200, Borislav Petkov wrote:
>  qemu-system-x86-20240 [006] ...1  9406.484134: kvm_page_fault: address 7fffb62ba318 error_code 2
>  qemu-system-x86-20240 [006] ...1  9406.484136: kvm_inj_exception: #PF (0x2)a
> 
> kvm injects the #PF into the guest.
> 
>  qemu-system-x86-20240 [006] d..2  9406.484136: kvm_entry: vcpu 1
>  qemu-system-x86-20240 [006] d..2  9406.484137: kvm_exit: reason PF excp rip 0xffffffff8161130f info 2 7fffb62ba318
>  qemu-system-x86-20240 [006] ...1  9406.484138: kvm_page_fault: address 7fffb62ba318 error_code 2
>  qemu-system-x86-20240 [006] ...1  9406.484141: kvm_inj_exception: #DF (0x0)
> 
> Second #PF at the same address and kvm injects the #DF.
> 
> BUT(!), why?
> 
> I probably am missing something but WTH are we pagefaulting at a
> user address in context_switch() while doing a lockdep call, i.e.
> spin_release? We're not touching any userspace gunk there AFAICT.
> 
> Is this an async pagefault or so which kvm is doing so that the guest
> rip is actually pointing at the wrong place?
> 
There is nothing in the trace that point to async pagefault as far as I see.

> Or something else I'm missing, most probably...
> 
Strange indeed. Can you also enable kvmmmu tracing? You can also instrument
kvm_multiple_exception() to see which two exception are combined into #DF.

--
			Gleb.
