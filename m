Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3JGRYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 13:24:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57871 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3JGRYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 13:24:11 -0400
Message-ID: <5252EDBE.7030805@zytor.com>
Date: Mon, 07 Oct 2013 10:22:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Clean up cap_user_time* setting
References: <tip-nmgn0j0muo1r4c94vlfh23xy@git.kernel.org> <524F097A.9010506@intel.com> <20131004185539.GT15690@laptop.programming.kicks-ass.net> <20131006091054.GA4342@gmail.com>
In-Reply-To: <20131006091054.GA4342@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 02:10 AM, Ingo Molnar wrote:
>>
>> I'm wanting to hear from the x86 people on why we have this absurd knob 
>> to begin with; but I'm tempted to simply disable all of perf if you 
>> touch it.
> 
> I'm fully with you, please zap the 'notsc' boot option - it's an ancient 
> relic, if any box is still broken with the TSC on we want to hear about it 
> and fix it!
> 

Perhaps better would be to make the notsc option do what other feature
removal options do and just remove the CPU feature flag.

Early on we had a bunch of ad hoc behaviors for feature disabling.  They
are harmful and just wrong... "not present" and "disabled" should be the
same thing in 99% of all cases (in the case of the TSC one may wish to
set the CR4 bit which disables the TSC from userspace, but I don't think
"notsc" ever did that.)

However:

pr_warn("Kernel compiled with CONFIG_X86_TSC, cannot disable TSC
completely\n");

That is a total "say what"?

At one point it even said:

printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "	
"cannot disable TSC.\n");

CONFIG_X86_TSC is a baseline control option; we shouldn't key
functionality off of it.  It's fine to say notsc -> no tracing, but
making it a compile-time key makes me a bit uphappy.  We cut off 386,
but cutting of 486 at this point makes me nervous.

	-hpa

