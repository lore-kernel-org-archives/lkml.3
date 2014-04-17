Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaDQVaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:30:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35392 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbaDQVaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:30:14 -0400
Date: Thu, 17 Apr 2014 23:30:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Owen Kibel <qmewlo@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140417213012.GC27852@pd.tnic>
References: <20140417100944.GG11096@twins.programming.kicks-ass.net>
 <20140417102442.GA8215@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
 <20140417152611.GD4321@pd.tnic>
 <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
 <20140417192330.GE4321@pd.tnic>
 <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
 <20140417194241.GF4321@pd.tnic>
 <20140417205807.GA27852@pd.tnic>
 <CAK7FoDt6tnknX7cioe7=2svVksyAyLUtoZX_oprzJNxoHZEpdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAK7FoDt6tnknX7cioe7=2svVksyAyLUtoZX_oprzJNxoHZEpdw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:21:41PM -0700, Owen Kibel wrote:
> The patch tested was from Chen, Gong
> 
> https://lkml.org/lkml/2014/4/15/838
> 
> It worked, apart from the warning on boot described previously - the
> possible boot message was extracted from /var/log/kern.log
> 
> The above patch on mainline: 3.15-rc1 2014-04-13 [tar.xz]
> 
> seems to have cured the problem

Ok, good. So this is straightened out.

@Ingo: just pick up Gong's fix without the raw_spin_lock* stuff.

> - the kernel appears fine after announcing something like
> 
> kernel: [    7.341085] BUG: using __this_cpu_write() in preemptible
> [00000000] code: modprobe/546
> 
> in the boot process.

This is most likely unrelated and is caused by the preemption checks
added to __this_cpu_* in 188a81409ff7. If you'd like to debug this
further, please send a full dmesg:

dmesg > dmesg.log

Privately is fine too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
