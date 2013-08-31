Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab3HaA6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 20:58:40 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:46033 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3HaA6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 20:58:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Don Zickus <dzickus@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Gleb Natapov <gleb@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Ingo Molnar <mingo@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20130819081220.24406.15846.stgit@yunodevel>
	<20130819094623.GA30389@gmail.com> <5212B31A.6090504@hitachi.com>
	<871u5or7qn.fsf@tw-ebiederman.twitter.com>
	<20130820142740.GO239280@redhat.com> <5215CDEF.30004@hitachi.com>
	<20130822131137.GL5564@redhat.com> <521C1FFF.5060203@hitachi.com>
	<20130827133355.GM239280@redhat.com>
Date: Fri, 30 Aug 2013 17:58:23 -0700
In-Reply-To: <20130827133355.GM239280@redhat.com> (Don Zickus's message of
	"Tue, 27 Aug 2013 09:33:55 -0400")
Message-ID: <878uzir80g.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19b6T6735QxXJM+JpuNJXynwElC9eP/miU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1020]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Don Zickus <dzickus@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from deadlocking of ioapic_lock
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Zickus <dzickus@redhat.com> writes:

> On Tue, Aug 27, 2013 at 12:41:51PM +0900, Yoshihiro YUNOMAE wrote:
>> Hi Don,
>> 
>> Sorry for the late reply.
>> 
>> (2013/08/22 22:11), Don Zickus wrote:
>> >On Thu, Aug 22, 2013 at 05:38:07PM +0900, Yoshihiro YUNOMAE wrote:
>> >>>So, I agree with Eric, let's remove the disable_IO_APIC() stuff and keep
>> >>>the code simpler.
>> >>
>> >>Thank you for commenting about my patch.
>> >>I didn't know you already have submitted the patches for this deadlock
>> >>problem.
>> >>
>> >>I can't answer definitively right now that no problems are induced by
>> >>removing disable_IO_APIC(). However, my patch should be work well (and
>> >>has already been merged to -tip tree). So how about taking my patch at
>> >>first, and then discussing the removal of disabled_IO_APIC()?
>> >
>> >It doesn't matter to me.  My orignal patch last year was similar to yours
>> >until it was suggested that we were working around a problem which was we
>> >shouldn't touch the IO_APIC code on panic.  Then I wrote the removal of
>> >disable_IO_APIC patch and did lots of testing on it.  I don't think I have
>> >seen any issues with it (just the removal of disabling the lapic stuff).
>> 
>> Yes, you really did a lot of testing about this problem according to
>> your patch(https://lkml.org/lkml/2012/1/31/391). Although you
>> said jiffies calibration code does not need the PIT in
>> http://lists.infradead.org/pipermail/kexec/2012-February/006017.html,
>> I don't understand yet why we can remove disable_IO_APIC.
>> Would you please explain about the calibration codes?
>
> I forgot a lot of this, Eric B. might remember more (as he was the one that
> pointed this out initially).  I believe initially the io_apic had to be in
> a pre-configured state in order to do some early calibration of the timing
> code.  Later on, it was my understanding, that the calibration of various
> time keeping stuff did not need the io_apic in a correct state.  The code
> might have switched to tsc instead of PIT, I forget.

Yes.  Alan Coxe's initial SMP port had a few cases where it still
exepected the system to be in PIT mode during boot and it took us a
decade or so before those assumptions were finally expunged.

> Then again looking at the output of the latest dmesg, it seems the IO APIC
> is initialized way before the tsc is calibrated.  So I am not sure what
> needed to get done or what interrupts are needed before the IO APIC gets
> initialized.

The practical issue is that jiffies was calibrated off of the PIT timer
if I recall.  But that is all old news.

>> By the way, can we remove disable_IO_APIC even if an old dump capture
>> kernel is used?
>
> Good question.  I did a bunch of testing with RHEL-6 too, which is 2.6.32
> based.  But I think we added some IRR fixes (commit 1e75b31d638), which
> may or may not have helped in this case.  So I don't know when a kernel
> started worked correctly during init (with the right changes).  I believe
> 2.6.32 had everything.

A sufficient old and buggy dump capture kernel will fail because of bugs
in it's startup path, but I don't think anyone cares.

The kernel startup path has been fixed for years, and disable_IO_APIC in
crash_kexec has always been a bug work-around for deficiencies in the
kernel's start up path (not part of the guaranteed interface).
Furthermore every real system configuration I have encountered used the
same kernel version for the crashdump kernel and the production kernel.
So we should be good.

> However, at the same time, the memory layout of current kernels has
> changed and I am not sure if older kernels can read them correctly (or if
> you just need the latest makedumpfile tool).  In other words, an old
> kernel like 2.6.32 might not work as a kdump kernel for a 3.10 kernel.  I
> don't know.

Memory layout should not be an issue at all.  The details are passed
from one kernel to another in a set of ELF headers.  So if the crash
dump kernel can run in the memory reserved for it, all should work well.

Eric
