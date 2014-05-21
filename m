Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaEUUWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:22:16 -0400
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:29638
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751962AbaEUUWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:22:13 -0400
Date: Wed, 21 May 2014 13:19:40 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, <linux-pm@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Michal Simek <michal.simek@xilinx.com>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
References: <91822600-39d0-4e71-b0f5-9eda35b76ec0@BN1AFFO11FD016.protection.gbl>
 <20140519161949.GG16662@pengutronix.de>
 <db8633e5-01a9-4d3a-80e8-74e23a456d52@BN1BFFO11FD051.protection.gbl>
 <20140520073358.GJ16662@pengutronix.de>
 <4bb5f44a-60bb-4e34-8f88-f91b8419be8d@BL2FFO11FD050.protection.gbl>
 <537B957B.5010001@codeaurora.org>
 <668683e3-856e-4f30-9b11-8f3e91e12d1d@BL2FFO11FD038.protection.gbl>
 <20140521073457.GD31687@pengutronix.de>
 <e9090453-ce40-4662-a3ea-fbdaffdb2aa4@BN1AFFO11FD046.protection.gbl>
 <20140521182308.GN31687@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140521182308.GN31687@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3ff23a63-f05f-4e46-835c-564e05e01048@BN1BFFO11FD016.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(377424004)(51704005)(479174003)(189002)(199002)(24454002)(21056001)(81342001)(33646001)(102836001)(53416003)(50986999)(99396002)(54356999)(87936001)(81542001)(76176999)(80022001)(70736001)(74316001)(50466002)(23676002)(85202002)(19580395003)(83322001)(20776003)(85182001)(86362001)(76482001)(44976005)(31696002)(83506001)(31966008)(74502001)(4396001)(74662001)(47776003)(77982001)(79102001)(64706001)(92566001)(46102001)(92726001)(85852003)(83072002)(15975445006)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB067;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 08:23PM +0200, Uwe Kleine-König wrote:
> Hello Sören,
> 
> On Wed, May 21, 2014 at 08:58:10AM -0700, Sören Brinkmann wrote:
> > On Wed, 2014-05-21 at 09:34AM +0200, Uwe Kleine-König wrote:
> > > On Tue, May 20, 2014 at 02:48:20PM -0700, Sören Brinkmann wrote:
> > > > On Tue, 2014-05-20 at 10:48AM -0700, Stephen Boyd wrote:
> > > > > On 05/20/14 09:01, Sören Brinkmann wrote:
> > > > > >
> > > > > >>>>> +{
> > > > > >>>>> +	unsigned long lower, upper, cur, lower_last, upper_last;
> > > > > >>>>> +
> > > > > >>>>> +	lower = clk_round_rate(clk, rate);
> > > > > >>>>> +	if (lower >= rate)
> > > > > >>>>> +		return lower;
> > > > > >>>> Is the >-case worth a warning?
> > > > > >>> No, it's correct behavior. If you request a rate that is way lower than what the
> > > > > >>> clock can generate, returning something larger is perfectly valid, IMHO.
> > > > > >>> Which reveals one problem in this whole discussion. The API does not
> > > > > >>> require clk_round_rate() to round down. It is actually an implementation
> > > > > >>> choice that had been made for clk-divider.
> > > > > >> I'm sure it's more than an implementation choice for clk-divider. But I
> > > > > >> don't find any respective documentation (but I didn't try hard).
> > > > > > A similar discussion - without final conclusion:
> > > > > > https://lkml.org/lkml/2010/7/14/260
> > > > > >
> > > > > >
> > > > > 
> > > > > Please call this new API something like clk_find_nearest_rate() or
> > > > > something. clk_round_rate() is supposed to return the rate that will be
> > > > > set if you call clk_set_rate() with the same arguments. It's up to the
> > > > > implementation to decide if that means rounding the rate up or down or
> > > > > to the nearest value.
> > > > 
> > > > Sounds good to me. Are there any cases of clocks that round up? I think
> > > > that case would not be handled correctly. But I also don't see a use
> > > > case for such an implementation.
> > > I don't really care which semantic (i.e. round up, round down or round
> > > closest) is picked, but I'd vote that all should pick up the same. I
> > > think the least surprising definition is to choose rounding down and add
> > > the function that is under discussion here to get a nearest match.
> > > 
> > > So I suggest:
> > > 
> > > 	- if round_rate is given a rate that is smaller than the
> > > 	  smallest available rate, return 0
> > > 	- add WARN_ONCE to round_rate and set_rate if they return with a
> > > 	  rate bigger than requested
> > 
> > Why do you think 0 is always valid? I think for a clock that can
> > generate 40, 70, 120, clk_round_rate(20) should return 40.
> I didn't say it's a valid value. It just makes the it possible to check
> for clk_round_rate(clk, rate) <= rate.

But if the set_rate() doesn't set the rate to 0 in that case, the
implementation was buggy.

> 
> I grepped a bit around and found da850_round_armrate which implements a
> round_rate callback returning the best match.
> omap1_clk_round_rate_ckctl_arm can return a value < 0.
> s3c2412_roundrate_usbsrc can return values that are bigger than
> requested. (I wonder if that is a bug though.)
> 
> > > 	- change the return values to unsigned long
> > 
> > Yep, I agree, this should happen.
> And we're using 0 as error value? e.g. for the case where
> omap1_clk_round_rate_ckctl_arm returns -EIO now?

IMHO, there should always be a valid frequency be returned from these
calls. The API says: return the frequency the clock provides when
set_rate() is called with the same argument. This should never result in
an error.

	Sören

