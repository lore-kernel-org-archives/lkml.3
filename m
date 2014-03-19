Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbaCSWft (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 18:35:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35122 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbaCSWfq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 18:35:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>, "Mark Brown" <broonie@kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <531E11B7.6080109@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "MyungJoo Ham" <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-4-git-send-email-nm@ti.com>
 <20140224015826.GU25940@sirena.org.uk> <530B594F.2030500@ti.com>
 <20140303035426.GC2411@sirena.org.uk> <531DF250.5060100@ti.com>
 <20140310172221.GT28112@sirena.org.uk> <531DF931.1060108@ti.com>
 <20140310180131.GZ28112@sirena.org.uk> <531E11B7.6080109@ti.com>
Message-ID: <20140319223536.31449.32103@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 3/6] PM / Voltagedomain: introduce voltage domain driver
 support
Date: Wed, 19 Mar 2014 15:35:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2014-03-10 12:25:43)
> On 03/10/2014 01:01 PM, Mark Brown wrote:
> > On Mon, Mar 10, 2014 at 12:41:05PM -0500, Nishanth Menon wrote:
> > 
> >> The only other options are:
> >> a) Abstract it at a higher level at "user drivers", since they are
> >> aware of the sequencing needs - but this partially defeats the
> >> purpose, unless ofcourse, we do a tricky implementation such as:
> >> clk a, b, c -> prenotifiers in a, postnotifiers in c (which as you
> >> mentioned is a little trickier to get right).
> >> b) introduce a higher level generic dvfs function[1] which does not
> >> seem very attractive either.

I disagree that a higher level DVFS interface is unattractive. I think
it has taken a while to get there but people are finally interested in
this. A small amount of discussion about this took place at Linaro
Connect earlier this month (just hallway talk) but we shouldn't rule out
the idea of a general framework for managing DVFS, which frankly is
complex enough to merit not being shoved into the clock layer.

> > 
> >> Any other suggestions other than limiting the usage(and documenting it
> >> so) and hoping for a future evolution to take this into consideration?
> > 
> > Something might be doable with telling the clock API about maintianing
> > ratios between clocks?  I do think we should have an idea where we'd go
> > with such requirements, even if we don't currently handle it, so that we
> > can hopefully avoid another round of refactoring everything but it
> > doesn't seem 100% essential, just very nice to have.

This sounds reasonable but I must point out that the clock framework
today (based on the existing clk.h api) does not have a single instance
of constraint-based logic. For instance there is no clk_set_min_rate or
clk_set_max_rate or clk_set_rate_range. These have been discussed before
but I feel that pushing something before now would have been premature
given that the level of discussion around those features never hit
critical mass.

So the ratio thing is sensible, but it would be the first
constraint-like mechanism in the clock framework so what that looks like
bares careful consideration.

> > 
> Mike,
> Any suggestions about the above? could we use composite clocks in some
> manner here(even though I think the original intent of the same was
> not the same)?

NACK. Let's just model the hardware in the clock framework, please. If
you need to invent fake clocks to represent other constructs then it
means the framework is missing something (or we're missing an entire
framework, e.g. DVFS).

Regards,
Mike

> 
> -- 
> Regards,
> Nishanth Menon
