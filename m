Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab3EHONv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:13:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:33397 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab3EHONu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:13:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,635,1363158000"; 
   d="scan'208";a="299410738"
Date: Wed, 8 May 2013 22:11:03 +0800
From: Feng Tang <feng.tang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130508141103.GA24865@feng-snb>
References: <20130506230137.GA16801@amd.pavel.ucw.cz>
 <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
 <20130507023853.GA2945@feng-snb>
 <20130507065348.GF17705@gmail.com>
 <51892560.7090202@linaro.org>
 <20130507213142.GA10061@amd.pavel.ucw.cz>
 <51897497.7040806@linaro.org>
 <20130507215151.GB10061@amd.pavel.ucw.cz>
 <20130508064419.GA5378@gmail.com>
 <20130508105542.GA22703@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508105542.GA22703@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, May 08, 2013 at 12:55:42PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > Sorry. You seem to not like the merged change, but I guess I'm not
> > > > quite sure what exactly your objection is here.
> > > 
> > > I'm not exactly sure what my objections are.
> > > 
> > > TSC was not designed for long-term precise timekeeping. [...]
> > 
> > The TSC is just a 64-bit counter that can be read very cheaply.
> > 
> > If the TSC is _implemented_ precisely in hardware and is kept in sync over 
> > CPUs then it's obviously fit for long-term precise timekeeping from that 
> > point on.
> 
> Yes. But the clock for TSC is not being generated in CPU (right?) and
> AFAICT, the code said "if the CPU is new enough, assume TSC is good
> timesource". You need good clock for good timesource.
> 
> > > [...] but some people suspend their machines for longer than that. Plus 
> > > I wonder how it will interfere with /etc/adjtime.
> > 
> > If it's precise then why should it interfere?
> > 
> > The history of the TSC being problematic can be ignored the moment CPU 
> > makers fix it completely - and apparently that is happening...
> 
> AFAICT we normally use RTC/PIT during runtime.

This is not true. AFAIK, most modern X86 processors used by
Laptop/Desktop/Servers/Smartphone is not using PIT as the runtime clocksource.
If you check the Linux laptop/desktop you are using, most probably it is using
TSC as clocksource, less likely the "hpet", and not likey the "pit".

Thanks,
Feng
