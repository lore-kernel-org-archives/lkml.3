Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab3EGRTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 13:19:01 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:44729 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3EGRS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 13:18:59 -0400
Date: Tue, 7 May 2013 19:18:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Feng Tang <feng.tang@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130507171855.GB29686@gmail.com>
References: <20130430074322.GA20110@gmail.com>
 <20130506230137.GA16801@amd.pavel.ucw.cz>
 <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
 <20130507023853.GA2945@feng-snb>
 <20130507065348.GF17705@gmail.com>
 <51892560.7090202@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51892560.7090202@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> On 05/06/2013 11:53 PM, Ingo Molnar wrote:
> >* Feng Tang <feng.tang@intel.com> wrote:
> >
> >>>is even worse than that. Machine can stay is s2ram for weeks (for a
> >>>lot more if it is desktop and you do s2ram for powersaving). Also
> >>>temperature of CPU varies a lot between active and s2ram states. Is
> >>>TSC good enough?
> >>Yes, I think it is relatively precise. Per our test, system time backed
> >>by the S3 non stop TSC only has 1 second drift after 4 days running
> >>(with mixed running and S3 states). And before using this feature, we've
> >>seen many time drift problems due to the RTC HW or system FW with our
> >>platforms.
> >Nice result ...
> >
> >Is that with NTP running?
> >
> > Without NTP, the TSC fast-calibration on bootup is not (expected to 
> > be) nearly as precise as the 1:345600 precision you've measured.
> 
> We also do refined calibration now on the TSC asynchronously over a 
> period of seconds at boot up that gives us much better accuracy then the 
> fast calibration. This helps provide much more consistent boot-to-boot 
> TSC frequencies.

Indeed, I just checked from the logs of a system booting newer kernels how 
well it works in practice, and it's about 10 ppm or better, which is much 
better than the ~1000 ppm calibration inaccuracy I remembered.

Thanks,

	Ingo
