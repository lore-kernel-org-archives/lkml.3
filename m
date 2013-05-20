Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3ETFIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 01:08:42 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45859 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab3ETFIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 01:08:41 -0400
Date: Mon, 20 May 2013 07:08:37 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tommy Apel Hansen <tommyapeldk@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: kernel 3.10-rc1 p-state/cpuidle panic
Message-ID: <20130520050837.GA12848@pd.tnic>
References: <1368962741.30275.17.camel@workstation-home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1368962741.30275.17.camel@workstation-home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm,

divide by 0, it seems.

+ Dirk Brandewie.

On Sun, May 19, 2013 at 01:25:41PM +0200, Tommy Apel Hansen wrote:
> Hello guys, I'm getting this with the current 3.10-rc1, I've enabled the new full-NOHZ
> I'm not sure though if that has something to do with this or if something is changed in the
> p-state code.
> 
> System :
> vendor_id : GenuineIntel
> cpu family  : 6
> model   : 45
> model name  : Intel(R) Xeon(R) CPU E5-2609 0 @ 2.40GHz
> stepping  : 7
> microcode : 0x70b
> cpu MHz   : 1176.000
> cache size  : 10240 KB
> physical id : 1
> siblings  : 4
> core id   : 3
> cpu cores : 4
> apicid    : 38
> initial apicid : 38
> fpu   : yes
> fpu_exception : yes
> cpuid level : 13
> wp    : yes
> flags   : [lots of stuff]
> bogomips  : 4800.56
> clflush size  : 64
> cache_alignment : 64
> address sizes : 46 bits physical, 48 bits virtual
> power management:
> 
> crash bt:
> PID: 0      TASK: ffff88085c585950  CPU: 5   COMMAND: "swapper/5"
>  #0 [ffff88107fc83b80] machine_kexec at ffffffff8102aad6
>  #1 [ffff88107fc83bc0] crash_kexec at ffffffff810e57d0
>  #2 [ffff88107fc83c90] oops_end at ffffffff810073b8
>  #3 [ffff88107fc83cb0] do_divide_error at ffffffff810040c2
>  #4 [ffff88107fc83d50] divide_error at ffffffff81637348
>     [exception RIP: intel_pstate_timer_func+1071]
>     RIP: ffffffff814f501f  RSP: ffff88107fc83e08  RFLAGS: 00010246
>     RAX: 0000000000000000  RBX: ffff8808555b9e00  RCX: ffff8808555b9e40
>     RDX: 0000000000000000  RSI: 0000000000000064  RDI: 0000000000000001
>     RBP: 0000025debb95955   R8: ffff8808555b9f70   R9: 00000000000003e0
>     R10: dead000000200200  R11: 0000000000000000  R12: 0000001877f8d1d3
>     R13: 000000009a45ae19  R14: 0000001d27d3d1d8  R15: 0000000000000040
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #5 [ffff88107fc83e00] intel_pstate_timer_func at ffffffff814f4fa2
>  #6 [ffff88107fc83e60] call_timer_fn at ffffffff8109edc3
>  #7 [ffff88107fc83e90] run_timer_softirq at ffffffff810a097e
>  #8 [ffff88107fc83f10] __do_softirq at ffffffff810990f1
>  #9 [ffff88107fc83f80] irq_exit at ffffffff810993ce
> #10 [ffff88107fc83f90] smp_apic_timer_interrupt at ffffffff81026448
> #11 [ffff88107fc83fb0] apic_timer_interrupt at ffffffff81636eca
> --- <IRQ stack> ---
> #12 [ffff88085c587db8] apic_timer_interrupt at ffffffff81636eca
>     [exception RIP: cpuidle_enter_state+72]
>     RIP: ffffffff814f5978  RSP: ffff88085c587e68  RFLAGS: 00000216
>     RAX: 000000000001c61d  RBX: ffffffff810a11e8  RCX: 0000000000000018
>     RDX: 0000000225c17d03  RSI: ffff88085c587fd8  RDI: ffffffff81a12500
>     RBP: 0000000000000002   R8: 0000000000000030   R9: 0000000000000001
>     R10: 0000000000000000  R11: 0000000000000000  R12: ffffffff810c48dd
>     R13: ffff88085c173950  R14: 0000000000000086  R15: 0000000000000000
>     ORIG_RAX: ffffffffffffff10  CS: 0010  SS: 0018
> #13 [ffff88085c587eb0] cpuidle_idle_call at ffffffff814f5aca
> #14 [ffff88085c587ef0] arch_cpu_idle at ffffffff8100cef9
> #15 [ffff88085c587f00] cpu_startup_entry at ffffffff810ce5af
> 
> kernel config:
> http://pastebin.com/AmEqQNZx
> 
> /Tommy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
