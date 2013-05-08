Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3EHGoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 02:44:24 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:59705 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3EHGoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 02:44:23 -0400
Date: Wed, 8 May 2013 08:44:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: John Stultz <john.stultz@linaro.org>, Feng Tang <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130508064419.GA5378@gmail.com>
References: <20130430074322.GA20110@gmail.com>
 <20130506230137.GA16801@amd.pavel.ucw.cz>
 <CA++bM2scosWgBpC3_LzcKYOjG4EQQzN5Vf4rZFds-5qRVRwvDQ@mail.gmail.com>
 <20130507023853.GA2945@feng-snb>
 <20130507065348.GF17705@gmail.com>
 <51892560.7090202@linaro.org>
 <20130507213142.GA10061@amd.pavel.ucw.cz>
 <51897497.7040806@linaro.org>
 <20130507215151.GB10061@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507215151.GB10061@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > Sorry. You seem to not like the merged change, but I guess I'm not
> > quite sure what exactly your objection is here.
> 
> I'm not exactly sure what my objections are.
> 
> TSC was not designed for long-term precise timekeeping. [...]

The TSC is just a 64-bit counter that can be read very cheaply.

If the TSC is _implemented_ precisely in hardware and is kept in sync over 
CPUs then it's obviously fit for long-term precise timekeeping from that 
point on.

> [...] I guess it may work ok for short naps, [...]

Historically the TSC was not very precise nor kept in sync, but see the 
measurements from Feng Tang, it's very precise now on good hardware - and 
it's also a very cheap to read clocksource.

> [...] but some people suspend their machines for longer than that. Plus 
> I wonder how it will interfere with /etc/adjtime.

If it's precise then why should it interfere?

The history of the TSC being problematic can be ignored the moment CPU 
makers fix it completely - and apparently that is happening...

Thanks,

	Ingo
