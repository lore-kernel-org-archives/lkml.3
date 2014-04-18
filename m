Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaDRIHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:07:42 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46101 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbaDRIHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:07:22 -0400
Date: Fri, 18 Apr 2014 10:07:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Owen Kibel <qmewlo@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "atodorov@redhat.com" <atodorov@redhat.com>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/urgent] x86/mce: Fix CMCI preemption bugs
Message-ID: <20140418080716.GA14280@gmail.com>
References: <3908561D78D1C84285E8C5FCA982C28F31E2A1D3@ORSMSX106.amr.corp.intel.com>
 <20140417152611.GD4321@pd.tnic>
 <CA+5PVA7i=RrGUk_7zz1yU5gseWpvr+a=4dfkg=n9cNc53S7nPA@mail.gmail.com>
 <20140417192330.GE4321@pd.tnic>
 <CA+55aFyz62W7CD9=9p9OxKuFs9Rck_p93E_40CqLat1HvDdf0Q@mail.gmail.com>
 <20140417194241.GF4321@pd.tnic>
 <20140417205807.GA27852@pd.tnic>
 <CAK7FoDt6tnknX7cioe7=2svVksyAyLUtoZX_oprzJNxoHZEpdw@mail.gmail.com>
 <20140417213012.GC27852@pd.tnic>
 <20140417222028.GD27852@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417222028.GD27852@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Apr 17, 2014 at 11:30:12PM +0200, Borislav Petkov wrote:
> > This is most likely unrelated and is caused by the preemption checks
> > added to __this_cpu_* in 188a81409ff7. If you'd like to debug this
> > further, please send a full dmesg:
> > 
> > dmesg > dmesg.log
> > 
> > Privately is fine too.
> 
> Ok, thanks for the dmesg. Replying to the thread with everybody:
> 
> The splat Owen is seeing is the same as this one at the beginning of
> this thread here:
> 
> http://lkml.kernel.org/r/8761m7lm3j.fsf@canonical.com
> 
> which has a viable fix. Btw, those two splats happen on HP notebooks.
> 
> Ok, good, I think we're all solved. Phew :-)
> 
> Thanks to all for their help.

Okay, so AFAICS the fix in x86/urgent isn't wrong functionally, it's 
just that the changelog incorrectly claims the raw-spinlock use is a 
bug causing a problem here.

Still that raw spinlock is bogus and might be hiding other problems, 
so we can keep the x86/urgent change (ea431643d6c3) as-is and I'll get 
it to Linus later today ...

Thanks,

	Ingo
