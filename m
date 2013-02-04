Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3BDNEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:04:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53976 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab3BDNEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:04:13 -0500
Date: Mon, 4 Feb 2013 14:04:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130204130403.GD13909@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2013 at 06:24:19PM +0530, Viresh Kumar wrote:
> That's why i am highlighting it again and again. :)

Ah, see, someone caught up with it :).

> What i believe is, the place where this directory was present earlier
> (cpu/cpufreq/) wasn't the right place. Everything else was in cpu/cpu*/cpufreq,
> then why this in cpu/cpufreq/ ?

For the simple reason that the "cpu*" stuff is per-cpu - the
"cpu/cpufreq" is per system, i.e. one governor for the whole system.

> I don't know how much of a pain it would be to fix userspace for it,
> but i know it wouldn't be that small.

I wouldn't fix userspace but simply not touch it. You can add your
per-policy stuff in "cpu/cpu*" as new sysfs nodes and no need to
change anything. And, also, as I suggested earlier, you should make it
configurable since this code wouldn't make sense on x86, for example,
where one system-wide governor should suffice.

> I had another idea of doing this only for platforms where we have
> multiple struct policy alive at the same time. But didn't wanted to
> implement it before discussing this further.

Simply put it behind a config option like
CONFIG_CPU_IDLE_MULTIPLE_DRIVERS, call the whole menu
"Multi-power-domain-policy" something and that should be modulary
enough.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
