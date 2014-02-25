Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaBYFvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 00:51:53 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44893 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaBYFvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 00:51:49 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "MyungJoo Ham" <myungjoo.ham@samsung.com>,
        "Mark Brown" <broonie@kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1392755543-28335-2-git-send-email-nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, "Nishanth Menon" <nm@ti.com>
References: <1392755543-28335-1-git-send-email-nm@ti.com>
 <1392755543-28335-2-git-send-email-nm@ti.com>
Message-ID: <20140225055142.22529.21814@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 1/6] PM / Voltagedomain: Add generic clk notifier handler for
 regulator based dynamic voltage scaling
Date: Mon, 24 Feb 2014 21:51:42 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2014-02-18 12:32:18)
> From: Mike Turquette <mturquette@linaro.org>
> 
> This patch provides helper functions for drivers that wish to scale
> voltage through the clock rate-change notifiers. The approach taken
> is that the user-driver(cpufreq/devfreq) do not care about the
> details of the OPP table, nor does it care about handling the voltage
> regulator directly.
> 
> By using the clk notifier flags, we are able to sequence the operations
> in the right order. The current logic is heavily influenced by
> implementation done in cpufreq-cpu0.
> 
> [nm@ti.com: Fixes in logic, and broken out from clk to allow building
> a generic voltagedomain solution independent of cpufreq]
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>

Not-signed-off-by: Mike Turquette <mturquette@linaro.org>

I haven't reviewed this series and it is a pretty big deviation from my
original RFC. You can have authorship of the patches if you want.

I'm not sure about trying to capture the "voltdm" as a core concept. It
feels a bit unwieldy to me. I have wondered about making an abstract
"performance domain" which is the dvfs analogue to generic power
domains. This a reasonable split since gpd are good for idle power
savings (e.g. clock gate, power gate, sleep state, etc) and "perf
domains" would be good for active power savings (dvfs).

Having a generic container for performance domains might make a good
place to stuff all of this glue logic that we keep running into (e.g.
CPU and GPU max frequencies that are related), and it might make another
nice knob for the thermal folks to use.

For the case of the OMAP voltage domains, it would be a place to stuff
all of the VC/VP -> ABB -> Smart Reflex AVS stuff.

Anyways, I don't have a real proposal. I just don't want my name on
these patches since they are really yours now. I might resurrect them
some day in a different context.

Regards,
Mike
