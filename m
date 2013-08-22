Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3HVNMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:12:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab3HVNMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:12:17 -0400
Date: Thu, 22 Aug 2013 09:11:37 -0400
From: Don Zickus <dzickus@redhat.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
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
Subject: Re: Re: [PATCH] [BUGFIX] crash/ioapic: Prevent crash_kexec() from
 deadlocking of ioapic_lock
Message-ID: <20130822131137.GL5564@redhat.com>
References: <20130819081220.24406.15846.stgit@yunodevel>
 <20130819094623.GA30389@gmail.com>
 <5212B31A.6090504@hitachi.com>
 <871u5or7qn.fsf@tw-ebiederman.twitter.com>
 <20130820142740.GO239280@redhat.com>
 <5215CDEF.30004@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5215CDEF.30004@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 05:38:07PM +0900, Yoshihiro YUNOMAE wrote:
> >So, I agree with Eric, let's remove the disable_IO_APIC() stuff and keep
> >the code simpler.
> 
> Thank you for commenting about my patch.
> I didn't know you already have submitted the patches for this deadlock
> problem.
> 
> I can't answer definitively right now that no problems are induced by
> removing disable_IO_APIC(). However, my patch should be work well (and
> has already been merged to -tip tree). So how about taking my patch at
> first, and then discussing the removal of disabled_IO_APIC()?

It doesn't matter to me.  My orignal patch last year was similar to yours
until it was suggested that we were working around a problem which was we
shouldn't touch the IO_APIC code on panic.  Then I wrote the removal of
disable_IO_APIC patch and did lots of testing on it.  I don't think I have
seen any issues with it (just the removal of disabling the lapic stuff).

Regardless, your patch fixes a similar problem we saw on RHEL, so I am
happy either way.  The removal of the disable_IO_APIC() just makes the
code look cleaner.

Cheers,
Don
