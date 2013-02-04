Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3BDNZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:25:29 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47250 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3BDNZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:25:26 -0500
MIME-Version: 1.0
In-Reply-To: <20130204130403.GD13909@pd.tnic>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<5808458.pvV2iHpBWm@vostro.rjw.lan>
	<CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
	<20130204123221.GA22340@pd.tnic>
	<CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
	<20130204130403.GD13909@pd.tnic>
Date: Mon, 4 Feb 2013 18:55:25 +0530
Message-ID: <CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 February 2013 18:34, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Feb 04, 2013 at 06:24:19PM +0530, Viresh Kumar wrote:

>> What i believe is, the place where this directory was present earlier
>> (cpu/cpufreq/) wasn't the right place. Everything else was in cpu/cpu*/cpufreq,
>> then why this in cpu/cpufreq/ ?
>
> For the simple reason that the "cpu*" stuff is per-cpu - the
> "cpu/cpufreq" is per system, i.e. one governor for the whole system.

That's not completely true. There lies cpufreq directory in cpu/cpu*/ too,
where we have per policy stuff in cpu/cpu*/, like policy tunables and stats.
And the same is true for governor too.

>> I don't know how much of a pain it would be to fix userspace for it,
>> but i know it wouldn't be that small.
>
> I wouldn't fix userspace but simply not touch it. You can add your
> per-policy stuff in "cpu/cpu*" as new sysfs nodes and no need to
> change anything.

That was slightly confusing to me :(
The whole governor directory is per policy, i have to keep that in
cpu/cpu*/cpufreq
instead of cpu/cpufreq .

> And, also, as I suggested earlier, you should make it
> configurable since this code wouldn't make sense on x86, for example,
> where one system-wide governor should suffice.

Its not only for multicluster system, but a system where multiple cpus have
separate clock control and hence multiple policy structures.

>> I had another idea of doing this only for platforms where we have
>> multiple struct policy alive at the same time. But didn't wanted to
>> implement it before discussing this further.
>
> Simply put it behind a config option like
> CONFIG_CPU_IDLE_MULTIPLE_DRIVERS, call the whole menu
> "Multi-power-domain-policy" something and that should be modulary
> enough.

Problem with this is it would fail for single image solutions on which everybody
is working on. So, with multiple platforms compiled into a single
image, this wouldn't
work.
