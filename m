Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3BDMyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:54:22 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:42153 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3BDMyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 07:54:20 -0500
MIME-Version: 1.0
In-Reply-To: <20130204123221.GA22340@pd.tnic>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
	<5808458.pvV2iHpBWm@vostro.rjw.lan>
	<CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
	<20130204123221.GA22340@pd.tnic>
Date: Mon, 4 Feb 2013 18:24:19 +0530
Message-ID: <CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
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

On 4 February 2013 18:02, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Feb 04, 2013 at 05:54:18PM +0530, Viresh Kumar wrote:
>> One important point i would like to highlight is: governors directory
>> would be present in cpu/cpu*/cpufreq/ now instead of cpu/cpufreq/.
>
> Uh, hold on, isn't this breaking a bunch of userspace with this move?
> Also, on all those other systems which don't need per-policy governors,
> we probably don't need this. So maybe this should be made optional, to
> be enabled by a config option IMO...

That's why i am highlighting it again and again. :)
What i believe is, the place where this directory was present earlier
(cpu/cpufreq/) wasn't the right place. Everything else was in cpu/cpu*/cpufreq,
then why this in cpu/cpufreq/ ?

I don't know how much of a pain it would be to fix userspace for it, but i know
it wouldn't be that small.

I had another idea of doing this only for platforms where we have multiple
struct policy alive at the same time. But didn't wanted to implement it before
discussing this further.
