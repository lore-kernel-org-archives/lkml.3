Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaI0UBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 16:01:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54378 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaI0UBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 16:01:46 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thierry Reding <thierry.reding@gmail.com>,
        =?utf-8?q?Janusz_U=C5=BCycki?= <j.uzycki@elproma.com.pl>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20140923085130.GO30514@ulmo>
Cc: "Philipp Zabel" <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org
References: <5410AEFD.5030302@elproma.com.pl> <20140923085130.GO30514@ulmo>
Message-ID: <20140927200122.19023.40310@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: Add PWM clock driver
Date: Sat, 27 Sep 2014 13:01:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thierry Reding (2014-09-23 01:51:31)
> On Wed, Sep 10, 2014 at 10:05:17PM +0200, Janusz Użycki wrote:
> > Hi,
> > 
> > http://patchwork.ozlabs.org/patch/359069/
> > https://lkml.org/lkml/2014/6/12/186
> > 
> > Will the patch ever included to linux-next?
> 
> I've never seen this patch before. From a quick look it doesn't seem
> like it would work as is, but the idea is certainly interesting. If
> somebody decides to continue work on it, please Cc me and the linux-pwm
> mailing list.

I just merged a gpio-controlled clock gate and I'm fine with a PWM clock
output.

Janusz, how are you testing the clock driver?

Regards,
Mike

> 
> > pwm_config()  API could be extended to support
> > not only period [ns] and duty [ns] time
> > but also frequency [Hz] and duty cycle fraction [1/1000?]
> > (instead of time in ns) as parameters.
> > Then  ns (rounded by pwm) to freq. conversion problem
> > inclk_pwm_recalc_rate() usingpwm_get_period()
> > could be avoided.
> > To extend the API pwm_config() can support
> > new flags forduty_ns and period_ns,
> > eg. PWM_DUTY_PERCENT and PWM_PERIOD_HZ.
> 
> Is that rounding really a problem? Also the PWM chips will most likely
> use the concept of period and duty-cycle internally anyway, so it will
> convert back from Hz/percentage to nanoseconds and fall victim to
> similar rounding effects.
> 
> Thierry
