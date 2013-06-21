Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935614Ab3FUMoA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 08:44:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57320 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab3FUMn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 08:43:59 -0400
Date: Fri, 21 Jun 2013 07:43:55 -0500
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <viresh.kumar@linaro.org>,
        <cpufreq@vger.kernel.org>
Subject: Re: [RFC PATCH] regulator: core: allow consumers to request to
 closes step voltage
Message-ID: <20130621124355.GA16513@kahuna>
References: <1371669474-24473-1-git-send-email-nm@ti.com>
 <20130619223828.GK1403@sirena.org.uk>
 <20130620124542.GA28320@kahuna>
 <20130621095157.GK27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130621095157.GK27646@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:51-20130621, Mark Brown wrote:
> On Thu, Jun 20, 2013 at 07:45:42AM -0500, Nishanth Menon wrote:
> > On 23:38-20130619, Mark Brown wrote:
> 
> > > If the consumer can tolerate a different voltage why not just request
> > > the range that can be tolerated?  Your problem here is specifying an
> > > exact voltage.
> 
> > I think you mean using regulator_get_linear_step
> 
> No, I don't.  Why would that make sense?  It limits the regulators that
> can be used and the properties of the regulator have no impact on what
> the SoC can support.
> 
> > > Or as I keep telling you guys the consumer can just do that directly
> > > using the existing API; the whole point in specifying the voltage as a
> > > range is to allow the consumer to cope with arbatrary regulators by
> > > giving a range of voltages that it can accept.
> 
> > I agree. The intent of this series was to start a conversation to see if
> > we can make it simpler.
> 
> It's already very simple.  The consumer driver just needs to supply the
> list of voltages which it can accept, that's all.
> 
> > For a generic driver which needs to handle platforms which
> > have tolerance, they'd use regulator_set_voltage_tol. But the
> > implementation would allow for uV - tol to uV + tol as range, which in
> > the case I mentioned(min voltage =uV) wont work.
> 
> So just write it as an explicit voltage range then.  For example many
> devices can tolerate any supply up to the maximum rated supply at any
> frequency so just specify that as the upper limit.
> 
> > If the consumer wants to be aware of linear step regulator, they'd have to do:
> > step_uV = regulator_get_linear_step(...);
> > regulator_set_voltage(uV, uV + step_uV);
> 
> No, the consumer really doesn't want to be aware of linear step
> regulators.  Why would it care that there even are linear steps?  If
> the consumer is doing this based on the properties of the regulator
> rather than on the properties of the consumer this indicates that the
> consumer has a problem  If the consumer is doing this based on the
> properties of the regulator rather than on the properties of the
> consumer this indicates that the consumer has a problem
The specific case that I am trying to tackle is as follows:
cpufreq-cpu0 uses definitions of voltages that are SoC specific. For a
given frequency, the optimal voltage is X, max voltage(Y) is already
expected to be in constraints for device functionality. We however want
to find the closest voltage for a regulator in range X to Y best
achievable by regulator. I think the area where I am getting confused is
this: I am thinking the job belongs to the consumer/regulator core to
find the best match. However, looking at implementations in existing
regulators and based on your explanation, it seems to be the job of
the regulator driver rather than the consumer/ regulator core to provide
the best match.

Thanks for the discussion and explanation.

-- 
Regards,
Nishanth Menon
