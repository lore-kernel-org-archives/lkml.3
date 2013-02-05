Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab3BELjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 06:39:55 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39356 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3BELjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 06:39:52 -0500
Date: Tue, 5 Feb 2013 12:39:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Robin Randhawa <Robin.Randhawa@arm.com>,
        Steve Bannister <Steve.Bannister@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 0/4] CPUFreq: Implement per policy instances of governors
Message-ID: <20130205113950.GG4827@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Robin Randhawa <Robin.Randhawa@ARM.com>,
	Steve Bannister <Steve.Bannister@arm.com>,
	Liviu Dudau <Liviu.Dudau@arm.com>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
 <5808458.pvV2iHpBWm@vostro.rjw.lan>
 <CAKohpok7RiJ_HKGi3r0vU26kNEtFKq==pMMoshT6Z2yy9ghemA@mail.gmail.com>
 <20130204123221.GA22340@pd.tnic>
 <CAKohpomcrtV3i9fL4zV6Mt0uDza-9pHTOsqTe2=C1t6mE6cpCQ@mail.gmail.com>
 <20130204130403.GD13909@pd.tnic>
 <CAKohpokuFC5gnTFcD3+RH3p5XaW8vBtyfq+Kej=d2J8tERdmoQ@mail.gmail.com>
 <20130204133648.GE13909@pd.tnic>
 <CAKohpokejWugM+wP5xcqp0F9AggLxuEf9Ox5fDViMxJh1c+kEw@mail.gmail.com>
 <80D6EFE2711DED4189C7C8F0430BFEA86D23D6A80E@BUNGLE.Emea.Arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80D6EFE2711DED4189C7C8F0430BFEA86D23D6A80E@BUNGLE.Emea.Arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 11:29:04AM +0000, Charles Garcia-Tobin wrote:
> Actually shooting myself in the foot here, Krait is not such a great
> example because although you can use difference between frequencies
> you are less likely to use different tunables (not inconceivable
> but unlikely). The best examples systems are multi cluster and
> hereterogeneous systems, like the recently announced Samsung Exynos 5
> octa http://en.wikipedia.org/wiki/Exynos_(system_on_chip). We will see
> more systems like this appearing, sporting low power cores combined
> with high performance ones, all running at the same time. I appreciate
> this is all very new, but more will come, and the requirement to have
> different tunables per cluster is very real. In ARM on our own multi
> cluster test chip, using an experimental version of this approach, we
> have seen good improvements in power consumption without compromising
> performance.

Ok, thanks for giving this insight, this is useful.

Question: do you need the granularity of that control to be per cpu
(with that I mean what linux understands under "cpu," i.e. logical or
physical core) or does one governor suffice per a set of cores, or as
you call it, a cluster?

> (Apologies ahead for any bit my mail server appends, not much I can do
> about it)

Yeah, my condolences :-)

> -- IMPORTANT NOTICE: The contents of this email and any attachments
> are confidential and may also be privileged. If you are not the
> intended recipient, please notify the sender immediately and do not
> disclose the contents to any other person, use it for any purpose, or
> store or copy the information in any medium. Thank you.

Leaving it in, in case you haven't seen how it looks like :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
