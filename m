Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab3BDOJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:09:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48793 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3BDOJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:09:18 -0500
Date: Mon, 4 Feb 2013 15:09:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130204140908.GC15452@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com
References: <cover.1359976493.git.viresh.kumar@linaro.org>
 <5808458.pvV2iHpBWm@vostro.rjw.lan>
 <CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
 <20130204123221.GA22340@pd.tnic>
 <CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
 <20130204130403.GD13909@pd.tnic>
 <CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
 <20130204133648.GE13909@pd.tnic>
 <CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpo=aLnhM0Op_32ohWZK5eG5nT7iK0OktBe+8ygOQW7zUqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 07:28:16PM +0530, Viresh Kumar wrote:
> All files which are directly present in cpu/cpu*/cpufreq/ folder. I am
> not talking about governor tunables but policy tunables. Things like
> scaling_[min]max_freq are policy tunables.

No, on x86 those are the P-states frequencies. They're defined by the
hardware.

> Policies don't have a name associated with them and so
> cpu/cpufreq/policies doesn't make any sense. Rather one policy is
> related to multiple cpus and its tunables are linked in all the cpus
> that belong to it, like scaling_[min]max_freq.

Then do the following:

cpu/cpufreq/policies/
|-> policy0
    |-> min_freq
    |-> max_freq
    |-> affected_cpus
    ...

or whatever needs to be a flexible interface for multi-policy cpufreq
support.

Remember: once you do those, they're more or less cast in stone so take
your time and do the design right, do not hurry those.

> Don't have examples of these, but there can be few. Over that it is a
> must for multicluster systems as clusters normally have separate clock
> control.

Yeah, nice try. We only support real hardware in the kernel, not what
could there be.

> But then we will get governors tunables in cpu/cpu*/cpufreq/ instead
> of cpu/cpufreq/ . Will that not break userspace for other systems?

What's wrong with having both? The cpu/cpufreq/ governor will set the
system-wide governor and the cpu/cpu*/cpufreq/ will add the different
policies.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
