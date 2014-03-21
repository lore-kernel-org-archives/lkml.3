Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaCUUOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 16:14:07 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41718 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaCUUOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 16:14:03 -0400
Date: Fri, 21 Mar 2014 21:13:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matthias Graf <matthias.graf@st.ovgu.de>
Cc: linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: Re: PROBLEM: Fatal Machine Check >= 3.13.5-101.fc19.x86_64
Message-ID: <20140321201352.GC1338@pd.tnic>
References: <532C727F.1080803@st.ovgu.de>
 <20140321172742.GA2846@pd.tnic>
 <532C97DF.9010201@st.ovgu.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <532C97DF.9010201@st.ovgu.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony.

Provided the decode is correct and I'm reading it right, this looks
like the cores get to livelock for some reason without any forward
progress. The MCEs signal that there hasn't been any instruction retired
in relatively long time, thus a stall.

You say, this happens when gnome starts. Does it also happen if you
don't start gnome, i.e. don't start X at all? Try booting into a
runlevel without graphics.

Tony, any other ideas?

Also, can you send full dmesg of both a working boot, without the MCEs
and one with?

Leaving in the rest.

On Fri, Mar 21, 2014 at 08:49:51PM +0100, Matthias Graf wrote:
> (Please CC me on all replies)
> 
> mcelog output for all mces:
> 
> 
> 
> Hardware event. This is not a software error.
> CPU 3 BANK 0
> MCG status:RIPV MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
> Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 5
> 
> 
> Hardware event. This is not a software error.
> CPU 3 BANK 5
> MCG status:RIPV MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200220024080400 MCGSTATUS 5
> 
> 
> Hardware event. This is not a software error.
> CPU 1 BANK 0
> MCG status:MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
> Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 4
> 
> 
> Hardware event. This is not a software error.
> CPU 1 BANK 5
> MCG status:MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200220010040400 MCGSTATUS 4
> 
> 
> Hardware event. This is not a software error.
> CPU 2 BANK 0
> MCG status:MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
> Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 4
> 
> 
> Hardware event. This is not a software error.
> CPU 2 BANK 5
> MCG status:MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200221010040400 MCGSTATUS 4
> 
> Hardware event. This is not a software error.
> CPU 0 BANK 5
> MCG status:RIPV MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200221024080400 MCGSTATUS 5
> 
> 
> Hardware event. This is not a software error.
> CPU 0 BANK 0
> MCG status:RIPV MCIP
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access
> Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 5
> 
> 
> 
> Am 21.03.2014 18:27, schrieb Borislav Petkov:
> > On Fri, Mar 21, 2014 at 06:10:23PM +0100, Matthias Graf wrote:
> >> Please CC me on replies.
> >>
> >> [1.] Kernel panic: Fatal Machine Check after booting >=
> >> 3.13.5-101.fc19.x86_64; 3.12.11-201.fc19.x86_64 works fine!
> >> [2.] Screen freezes a few seconds after Gnome appears. The error message
> >> (see attachement) is seldom still printed to the screen. Booting
> >> 3.12.11-201 with otherwise the same setup, I do not see the panic.
> >> Booting on different hardware (my laptop) does not produce the panic. I
> >> also notice low frames per seconds after gnome started up, right before
> >> the panic occures. I therefore suppose this is graphics hardware related.
> >> [3.] Fatal Machine Check Exception, RIP Inexact, apic_timer_interrupt,
> >> Kernel panic
> >> [4.] 3.13.6-100.fc19.x86_64 && 3.13.5-103.fc19.x86 && 3.13.5-101.fc19.x86_64
> >> [5.] OCRed: (see Attachement for photo)
> >>
> >> Started Accounts Service.
> >> [ 34.348483] mce: [Hardware Error]: CPU 3: Machine Check Exception: 5 Bank 8: bZ88884888888888
> >> [ 44.468168] mce: [Hardware Error]: HIP ?IHEXﬁCT? 18:<ffffffff816881f8> {apicgtimer_interrupt+8x8/8x88}
> >> I 44.468168] mce: [Hardware Error]: TSC 36S??8ad8c
> >> f 44.468168] mce: [Hardware Error]: PROCESSOR 8:6fb TIM 138471666? SOCKET 8 HPIC 2 microcode ba
> >> I 44.468168] mce: [Hardware Error]: Run the above through 'mcelog ~~ascii’
> > 
> > This looks like you had some text recognition done on the jpeg. :-)
> > 
> > Please correct the error message to be exactly as in the jpeg and run it
> > through mcelog --ascii to see what that bank 8 is trying to tell us.
> > 
> > Thanks.
> > 

> [ 34.348483] mce: [Hardware Error]: CPU 3: Machine Check Exception: 5 Bank 0: b200004000000800
> [ 44.468168] mce: [Hardware Error]: RIP !INEXACT! 10:<ffffffff816901f0> {apic_timer_interrupt+0x0/0x80}
> [ 44.468168] mce: [Hardware Error]: TSC 365779ad0c
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 2 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: CPU 3: Machine Check Exception: 5 Bank 5: b200220024080400
> [ 44.468168] mce: [Hardware Error]: RIP !INEXACT! 10:<ffffffff816901f0> {apic_timer_interrupt+0x0/0x80}
> [ 44.468168] mce: [Hardware Error]: TSC 365779ad0c
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 2 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: CPU 1: Machine Check Exception: 4 Bank 0: b200004000000800
> [ 44.468168] mce: [Hardware Error]: TSC 365779ad42
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 3 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: CPU 1: Machine Check Exception: 4 Bank 5: b200220010040400
> [ 44.468168] mce: [Hardware Error]: TSC 365779ad42
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 3 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: CPU 2: Machine Check Exception: 4 Bank 0: b200004000000800
> [ 44.468168] mce: [Hardware Error]: TSC 365779aeaa
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 1 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: CPU 2: Machine Check Exception: 4 Bank 5: b200221010040400
> [ 44.468168] mce: [Hardware Error]: TSC 365779aeaa
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 1 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: CPU 0: Machine Check Exception: 5 Bank 5: b200221024080400
> [ 44.468168] mce: [Hardware Error]: RIP !INEXACT! 10:<ffffffff816901f0> {apic_timer_interrupt+0x0/0x80}
> [ 44.468168] mce: [Hardware Error]: TSC 365779aece
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 0 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: CPU 0: Machine Check Exception: 5 Bank 0: b200004000000800
> [ 44.468168] mce: [Hardware Error]: RIP !INEXACT! 10:<ffffffff816901f0> {apic_timer_interrupt+0x0/0x80}
> [ 44.468168] mce: [Hardware Error]: TSC 365779aece
> [ 44.468168] mce: [Hardware Error]: PROCESSOR 0:6fb TIME 1394716667 SOCKET 0 APIC 0 microcode ba
> [ 44.468168] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> [ 44.468168] mce: [Hardware Error]: Machine check: Processor context corrupt
> [ 44.468168] Kernel panic — not syncing: Fatal Machine check
> [ 44.468168] drm_kms_helper: panic occurred, switching back to text console
> [ 44.468168] Rebooting in 30 seconds..

> Hardware event. This is not a software error.
> CPU 3 BANK 0 
> MCG status:RIPV MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 5
> 
> 
> Hardware event. This is not a software error.
> CPU 3 BANK 5 
> MCG status:RIPV MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200220024080400 MCGSTATUS 5
> 
> 
> Hardware event. This is not a software error.
> CPU 1 BANK 0 
> MCG status:MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 4
> 
> 
> Hardware event. This is not a software error.
> CPU 1 BANK 5 
> MCG status:MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200220010040400 MCGSTATUS 4
> 
> 
> Hardware event. This is not a software error.
> CPU 2 BANK 0 
> MCG status:MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 4
> 
> 
> Hardware event. This is not a software error.
> CPU 2 BANK 5 
> MCG status:MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200221010040400 MCGSTATUS 4
> 
> Hardware event. This is not a software error.
> CPU 0 BANK 5 
> MCG status:RIPV MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: Internal Timer error
> STATUS b200221024080400 MCGSTATUS 5
> 
> 
> Hardware event. This is not a software error.
> CPU 0 BANK 0 
> MCG status:RIPV MCIP 
> MCi status:
> Uncorrected error
> Error enabled
> Processor context corrupt
> MCA: BUS Level-0 Local-CPU-originated-request Generic Memory-access Request-did-not-timeout Error
> BQ_DCU_READ_TYPE BQ_ERR_HARD_TYPE BQ_ERR_HARD_TYPE
> timeout BINIT (ROB timeout). No micro-instruction retired for some time
> STATUS b200004000000800 MCGSTATUS 5
> 




-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
