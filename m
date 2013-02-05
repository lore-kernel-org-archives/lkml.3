Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab3BELEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:04:25 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43770 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3BELEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:04:10 -0500
Date: Tue, 5 Feb 2013 12:04:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130205110407.GC4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
	Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
	Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
References: <20130204140908.GC15452@pd.tnic>
 <CAKohpokowK6ybYd8aDUdfFYsnzoc5VAKsuPSkfxoDqJ3k+FwGA@mail.gmail.com>
 <20130204150511.GF13909@pd.tnic>
 <CAKohpokt0xtsj1eQDMw6JgvQVp4rgFyU-vUrtuuF+0jjOVNHRQ@mail.gmail.com>
 <20130204165057.GH13909@pd.tnic>
 <CAOh2x==fyfYwz+eXmPhBJTE+_q_fHyx2drXrM789XvCfEqPBUQ@mail.gmail.com>
 <20130205091532.GA4827@pd.tnic>
 <CAKohpo=6q+Bcgq0Re=3SXM6zwub5N=vJBO=sTeEgZZ9byFK7=g@mail.gmail.com>
 <20130205102721.GB4827@pd.tnic>
 <CAKohpo=_Qq-_Aqy7nZD+f28-B7DY8ioQ5fe8bYKTe64A0RXeGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpo=_Qq-_Aqy7nZD+f28-B7DY8ioQ5fe8bYKTe64A0RXeGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:13:23PM +0530, Viresh Kumar wrote:
> There isn't lot of code that we have to keep inside the macro you
> suggest. Its just an if else (with single line block), which would
> give the parent kobject. Nothing else.
>
> I didn't wanted to create a macro for just that. For me an if/else is
> not that big code.

Yeah, I imagine for you it isn't, no.

> Anyway, if nobody else comes on my side i can create that macro for you.
> But, personally i would prefer code without such macros.

Here's an even cleaner way:

platform_driver:
init(struct cpufreq_policy *policy)
{
	...

	add_additional_sysfs_entries(policy);

	...
}

...

static void add_additional_sysfs_entries(struct cpufreq_policy *policy)
{
#ifdef CONFIG_CPUFREQ_MULTIPLE_POLICIES
	create-folder-in-cpu/cpu*/cpufreq;
	...
#endif
}

and the platform driver will have in its Kconfig section:

config CPUFREQ_PLATFORM_DRIVER_X
	...
	select CPUFREQ_MULTIPLE_POLICIES


You don't need the policy->have_multiple_policies member even.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
