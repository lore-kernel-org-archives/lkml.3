Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaETHwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:52:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33783 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaETHwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:52:09 -0400
Date: Tue, 20 May 2014 09:51:58 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
Message-ID: <20140520075158.GK16662@pengutronix.de>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
 <1400106655-22465-3-git-send-email-soren.brinkmann@xilinx.com>
 <20140515073816.GI16662@pengutronix.de>
 <91822600-39d0-4e71-b0f5-9eda35b76ec0@BN1AFFO11FD016.protection.gbl>
 <20140519161949.GG16662@pengutronix.de>
 <db8633e5-01a9-4d3a-80e8-74e23a456d52@BN1BFFO11FD051.protection.gbl>
 <df742b46-c630-49ea-b234-4d746bb66ec1@BL2FFO11FD040.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <df742b46-c630-49ea-b234-4d746bb66ec1@BL2FFO11FD040.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 19, 2014 at 10:29:05AM -0700, Sören Brinkmann wrote:
> With the improvements suggested by you I have this now:
> 
> long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
> {
> 	unsigned long lower, upper;
> 
> 	lower = clk_round_rate(clk, rate);
> 	if (lower >= rate)
> 		return lower;
> 
> 	upper = clk_round_rate(clk, rate + (rate - lower) - 1);
> 	if (upper == lower)
> 		return upper;
> 
> 	lower = rate + 1;
> 	while (lower < upper) {
> 		unsigned long rounded, mid;
> 
> 		mid = lower + ((upper - lower) >> 1);
> 		rounded = clk_round_rate(clk, mid);
> 		if (rounded < lower)
> 			lower = mid + 1;
> 		else
> 			upper = rounded;
> 	}
> 
> 	return upper;
> }
This is nearly my version now. I just lacks the overflow check when
calculating upper and I skipped the early return if (upper == lower).
(Instead the while condition evaluates to false on the first hit and
returns with the same result.)

Other than that I added a few comments. :-)

Something we still should resolve is the return type. It should match
clk_round_rate, but should both be signed or unsigned? 

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
