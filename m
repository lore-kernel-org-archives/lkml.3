Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3BELM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:12:26 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41250 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3BELMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:12:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130205110407.GC4827@pd.tnic>
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
	<20130205110407.GC4827@pd.tnic>
Date: Tue, 5 Feb 2013 16:42:23 +0530
Message-ID: <CAKohponiiVO_P2EDDTUHeoo7j3FG-ELtP8oLwfdEQ3HkgOS77g@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 February 2013 16:34, Borislav Petkov <bp@alien8.de> wrote:
> Here's an even cleaner way:
>
> platform_driver:
> init(struct cpufreq_policy *policy)
> {
>         ...
>
>         add_additional_sysfs_entries(policy);
>
>         ...
> }
>
> ...
>
> static void add_additional_sysfs_entries(struct cpufreq_policy *policy)
> {
> #ifdef CONFIG_CPUFREQ_MULTIPLE_POLICIES
>         create-folder-in-cpu/cpu*/cpufreq;
>         ...
> #endif
> }
>
> and the platform driver will have in its Kconfig section:
>
> config CPUFREQ_PLATFORM_DRIVER_X
>         ...
>         select CPUFREQ_MULTIPLE_POLICIES
>
>
> You don't need the policy->have_multiple_policies member even.

Tricky part is the name of this routine: add_additional_sysfs_entries().

I am not proposing additional set of directories inside cpu/cpu*/cpufreq/
but either of cpu/cpufreq/ or cpu/cpu*/cpufreq/ for governor.

And so, keeping that additional variable looks a better solution. Let me
get a patch with this change only and see how it looks.
