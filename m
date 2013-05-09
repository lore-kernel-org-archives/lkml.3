Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3EII7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:59:07 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:54852 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3EII7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:59:05 -0400
Date: Thu, 9 May 2013 10:59:00 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Feng Tang <feng.tang@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Fwd: [GIT PULL] timer changes for v3.10
Message-ID: <20130509085900.GA19825@gmail.com>
References: <20130507023853.GA2945@feng-snb>
 <20130507065348.GF17705@gmail.com>
 <51892560.7090202@linaro.org>
 <20130507213142.GA10061@amd.pavel.ucw.cz>
 <51897497.7040806@linaro.org>
 <20130507215151.GB10061@amd.pavel.ucw.cz>
 <20130508064419.GA5378@gmail.com>
 <20130508105542.GA22703@amd.pavel.ucw.cz>
 <alpine.LFD.2.02.1305081626110.2863@ionos>
 <20130508194923.GA30896@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508194923.GA30896@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> [I still wonder how adjtime is going to work in TSC(runtime)+RTC(s2disk) 
> case; surely TSC has different drift than RTC, and so adjtime will have 
> fun trying to estimate the drift... but that's not new problem and not 
> affected by that patch.]

NTP, once it has settled, typically deals with millisecond, microsecond 
level adjustments.

The RTC has a basic granularity of 1 second - so s2ram is a ~500 msecs 
kick in the guts for NTP and drift is the least of the problems.

On future systems it won't matter, as the TSC will be used for everything 
that does not completely power off the system, as Thomas explained it.

Thanks,

	Ingo
