Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab3LLFrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:47:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43306 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab3LLFrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:47:09 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1386826641.6056.31.camel@marge.simpson.net>
References: <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de> <20131211113839.GF21683@pd.tnic> <20131211115239.GA21999@twins.programming.kicks-ass.net> <1386764955.12005.60.camel@marge.simpson.net> <20131211124352.GB21999@twins.programming.kicks-ass.net> <20131211134048.GH21683@pd.tnic> <20131211145655.GB4510@gmail.com> <20131211164318.GA2480@laptop.programming.kicks-ass.net> <20131211175036.GC12431@gmail.com> <52A8F073.9040500@zytor.com> <20131211231425.GD8863@pd.tnic> <52A908DB.60902@zytor.com> <1386822357.6056.12.camel@marge.simpson.net> <52A94065.1050103@zytor.com> <1386826641.6056.31.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 11 Dec 2013 21:45:55 -0800
To: Mike Galbraith <bitbucket@online.de>
CC: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Message-ID: <6e4b858b-fcad-4231-8351-d2f473bf6ba6@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As in it hangs at that point?

Mike Galbraith <bitbucket@online.de> wrote:
>On Wed, 2013-12-11 at 20:49 -0800, H. Peter Anvin wrote: 
>> On 12/11/2013 08:25 PM, Mike Galbraith wrote:
>> >  arch/x86/include/asm/mwait.h   |    4 ++--
>> >  arch/x86/kernel/cpu/common.c   |    7 ++++---
>> >  arch/x86/kernel/setup_percpu.c |    1 +
>> >  3 files changed, 7 insertions(+), 5 deletions(-)
>> > 
>> > Index: linux-2.6/arch/x86/kernel/cpu/common.c
>> > ===================================================================
>> > --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
>> > +++ linux-2.6/arch/x86/kernel/cpu/common.c
>> > @@ -65,13 +65,14 @@ void __init setup_cpu_local_masks(void)
>> >  }
>> >  
>> >  /* allocate percpu area for mwait doorbell */
>> > -char __percpu *mwait_doorbell;
>> > +DEFINE_PER_CPU(char *, mwait_doorbell);
>> > +EXPORT_PER_CPU_SYMBOL(mwait_doorbell);
>> >  
>> 
>> Sorry, this is wrong.  This is NOT a percpu variable, it is a pointer
>to
>> a percpu allocation, but the variable itself is not a percpu
>variable.
>> This explains your boom.
>
>With that fixed, it boots, but is not quite perfect.
>
>... 
>[  258.560079] fbcon: radeondrmfb (fb0) is primary device
>[  258.722483] Console: switching to colour frame buffer device 128x48
>[  258.847076] radeon 0000:01:03.0: fb0: radeondrmfb frame buffer
>device
>[  258.911991] radeon 0000:01:03.0: registered panic notifier
>[  258.968772] [drm] Initialized radeon 2.35.0 20080528 for
>0000:01:03.0 on minor 0
>...
>[  469.738604] netxen_nic 0000:04:00.3: using msi-x interrupts
>[  469.739078] netxen_nic 0000:04:00.3: eth5: GbE port initialized
>[  469.830512] ipmi_si 00:01: Found new BMC (man_id: 0x00000b, prod_id:
>0x2000, dev_id: 0x13)
>[  469.830524] ipmi_si 00:01: IPMI kcs interface initialized
>[  473.729862] iTCO_wdt: unable to reset NO_REBOOT flag, device
>disabled by hardware/BIOS
>...
>[  711.636741] fuse init (API version 7.22)
>
>...zzzz ok box, doctor appointment is in an hour away.
>
>-Mike 

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
