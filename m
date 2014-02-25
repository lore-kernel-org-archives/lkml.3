Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaBYU63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:58:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50031 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaBYU60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:58:26 -0500
Message-ID: <530D0394.4020208@ti.com>
Date: Tue, 25 Feb 2014 14:56:52 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mark Brown <broonie@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [RFC PATCH 1/6] PM / Voltagedomain: Add generic clk notifier
 handler for regulator based dynamic voltage scaling
References: <1392755543-28335-1-git-send-email-nm@ti.com> <1392755543-28335-2-git-send-email-nm@ti.com> <20140225055142.22529.21814@quantum>
In-Reply-To: <20140225055142.22529.21814@quantum>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
On 02/24/2014 11:51 PM, Mike Turquette wrote:
> Quoting Nishanth Menon (2014-02-18 12:32:18)
>> From: Mike Turquette <mturquette@linaro.org>
>>
>> This patch provides helper functions for drivers that wish to scale
>> voltage through the clock rate-change notifiers. The approach taken
>> is that the user-driver(cpufreq/devfreq) do not care about the
>> details of the OPP table, nor does it care about handling the voltage
>> regulator directly.
>>
>> By using the clk notifier flags, we are able to sequence the operations
>> in the right order. The current logic is heavily influenced by
>> implementation done in cpufreq-cpu0.
>>
>> [nm@ti.com: Fixes in logic, and broken out from clk to allow building
>> a generic voltagedomain solution independent of cpufreq]
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> 
> Not-signed-off-by: Mike Turquette <mturquette@linaro.org>
> 
> I haven't reviewed this series and it is a pretty big deviation from my
> original RFC. You can have authorship of the patches if you want.

Sure, I had send a private note requesting clarification about the
authorship, but I guess I can take this as the response :).

> 
> I'm not sure about trying to capture the "voltdm" as a core concept. It
> feels a bit unwieldy to me.

Considering it is a simple collation of regulators and SoC specific
"magic" which have to be operated in tandem to clock operation, Why
does it seem unwieldy? Usage of multiple voltage planes in a single
voltage domain concept does not seem unique to TI processors either:
For example, imx6q-cpufreq.c uses 3 regulators (arm, pu, soc),
s5pv210-cpufreq.c uses two regulators (vddarm, vddint), ideally OMAP
implementation would use two (vdd_mpu, vbb_mpu).

> I have wondered about making an abstract
> "performance domain" which is the dvfs analogue to generic power
> domains. This a reasonable split since gpd are good for idle power
> savings (e.g. clock gate, power gate, sleep state, etc) and "perf
> domains" would be good for active power savings (dvfs).
> 
> Having a generic container for performance domains might make a good
> place to stuff all of this glue logic that we keep running into (e.g.
> CPU and GPU max frequencies that are related), and it might make another
> nice knob for the thermal folks to use.

This sounds like one level higher abstraction that we are speaking of
here? I was'nt intending to solve the bigger picture problem here -
just an abstraction level that might allow reusablity for multiple
SoCs. In fact, having an abstraction away for voltage domain(which may
consist of multiple regulators and any SoC specific magic) purely
allows us to move towards a direction you mention here.

> 
> For the case of the OMAP voltage domains, it would be a place to stuff
> all of the VC/VP -> ABB -> Smart Reflex AVS stuff.
> 

Unfortunately, I dont completely comprehend objection we have to this
approach (other than an higher level abstraction is needed) and if we
do have an objection, what is the alternate approach should be for
representing hardware which this series attempts to present.

-- 
Regards,
Nishanth Menon
