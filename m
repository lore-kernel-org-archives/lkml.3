Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaEOOCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:02:21 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:20462
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751768AbaEOOCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:02:19 -0400
Date: Thu, 15 May 2014 07:00:26 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/5] Frequency resolution in CCF vs. cpufreq
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140515074724.GJ16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140515074724.GJ16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <6fe97032-ba6b-4dac-9064-34a9c788c57c@BN1BFFO11FD001.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(377424004)(24454002)(189002)(51704005)(199002)(33646001)(31966008)(50466002)(50986999)(44976005)(86362001)(74502001)(70736001)(81542001)(83072002)(87936001)(92726001)(4396001)(74316001)(99396002)(47776003)(76176999)(54356999)(83322001)(46102001)(83506001)(85852003)(53416003)(80022001)(81342001)(79102001)(31696002)(85182001)(23676002)(85202002)(20776003)(76482001)(77982001)(74662001)(92566001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB039;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, 2014-05-15 at 09:47AM +0200, Uwe Kleine-König wrote:
> On Wed, May 14, 2014 at 03:30:50PM -0700, Soren Brinkmann wrote:
> > Hi,
> > 
> > I have one or two problems with cpufreq and the CCF, which are caused by
> > rounding/different frequency resolutions.
> > 
> > cpufreq works with kHz, while the CCF uses Hz. On Zynq our default frequency is
> > 666666666 Hz which the CCF, due to rounding, reports as 666666660. And for
> Why does this happen? Isn't that a bug? What is the actual freqency?
> 666666666 Hz or 2000000000/3 Hz?

I don't know for sure. I think it's rounding that takes place in the
CCF. That output clock goes from a x-tal through an PLL and various
muxes and dividers. I guess some inaccuracies in the magnitude of a few
Hz are probably not avoidable in that processing chain.

> 
> > cpufreq, which simply divides values it obtains through clk_round_rate() by
> > 1000, 666666.
> > Since passing 666666 to clk_round_rate() does not result in 666666660
> > (clk_round_rate() always rounds down!), we chose to put 666667 in the OPP. This
> What is OPP?

As Nishanth already said, Operating Performance Points. Sorry for being
lazy and not having spelled that out.

	Sören

