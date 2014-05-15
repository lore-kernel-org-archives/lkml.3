Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaEOOHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:07:21 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:45133
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752880AbaEOOHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:07:19 -0400
Date: Thu, 15 May 2014 07:05:28 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/5] Frequency resolution in CCF vs. cpufreq
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
 <CAKohpokm3WVnu_DggKc4PbhVAKNexrJ4051F-gnVFFTDOyz9ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpokm3WVnu_DggKc4PbhVAKNexrJ4051F-gnVFFTDOyz9ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3c6b2890-3df4-48e9-8cc5-8e2d8955f64f@BL2FFO11FD032.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(199002)(189002)(51704005)(377424004)(24454002)(80022001)(46102001)(44976005)(83322001)(74502001)(23676002)(81542001)(50466002)(50986999)(83506001)(81342001)(86362001)(47776003)(76176999)(31966008)(4396001)(31696002)(33646001)(77982001)(74662001)(74316001)(87936001)(92726001)(92566001)(99396002)(19580395003)(85182001)(79102001)(19580405001)(20776003)(76482001)(83072002)(53416003)(70736001)(54356999)(85852003)(85202002)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB063;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Thu, 2014-05-15 at 11:42AM +0530, Viresh Kumar wrote:
> On 15 May 2014 04:00, Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > I have one or two problems with cpufreq and the CCF, which are caused by
> > rounding/different frequency resolutions.
> >
> > cpufreq works with kHz, while the CCF uses Hz. On Zynq our default frequency is
> > 666666666 Hz which the CCF, due to rounding, reports as 666666660. And for
> > cpufreq, which simply divides values it obtains through clk_round_rate() by
> > 1000, 666666.
> > Since passing 666666 to clk_round_rate() does not result in 666666660
> > (clk_round_rate() always rounds down!), we chose to put 666667 in the OPP. This
> > causes issue 1: cpufreq stats are broken.
> 
> I know it might a big exercise, but wouldn't it be worth to make cpufreq start
> using frequencies in Hz ?

I haven't looked into this. As you say yourself, that might be a rather
big project. I will take a look at it, but I can't promise that I have
time to dedicate to this. Also, as said above, even though our CPU is
supposed to run at 666666666 Hz, rounding lets the last 6 Hz disappear.
I think we have to handle deviances either way.

	Sören

