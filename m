Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaEZVza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:55:30 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:36875
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751575AbaEZVz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:55:28 -0400
Date: Mon, 26 May 2014 14:52:47 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
References: <20140521073457.GD31687@pengutronix.de>
 <9956925.Qsz2bH3rDg@vostro.rjw.lan>
 <CAKohpomam0qKdkMMMRDOfWN9QnZ3DzCviV=RuZ5f_7JbmYNDNw@mail.gmail.com>
 <9956935.0oj56vcaUh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9956935.0oj56vcaUh@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2827f20b-b489-4eb0-8ec9-9db957e28788@BL2FFO11FD008.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(377424004)(24454002)(51704005)(189002)(199002)(377454003)(70736001)(19580405001)(50986999)(92726001)(85202002)(83322001)(74502001)(85182001)(46102001)(54356999)(31696002)(53416003)(19580395003)(44976005)(23676002)(81342001)(86362001)(76176999)(104016001)(83072002)(83506001)(33646001)(74662001)(87936001)(74316001)(64706001)(102836001)(77982001)(50466002)(79102001)(99396002)(47776003)(81542001)(4396001)(21056001)(85852003)(76482001)(20776003)(80022001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB038;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 02234DBFF6
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-26 at 01:47PM +0200, Rafael J. Wysocki wrote:
> On Monday, May 26, 2014 04:37:13 PM Viresh Kumar wrote:
> > On 26 May 2014 16:52, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > > I agree as far as the 64-bit thing goes, but is switching to Hz really
> > > necessary?
> > 
> > Don't really know that.. It seems that there will always be problems with
> > close enough frequencies whenever rounding is done.
> 
> Well, rounding errors are a problem, but question is if that is enough of
> a problem to justify expanding the storage size twice.  Also, that'd be
> a performance hit on 32-bit systems.
> 
> > More can be elaborated by Soren.
> 
> OK

I'd say it's probably not worth switching. As you and I said, rounding
issues are likely to happen no matter what. In this particular case,
switching would not remove the need for the patch I proposed to allow
for rounding errors. The error margin could be reduced, but that's it.
I think it would be nice if CCF, OPP and cpufreq would use the same
resolution and types, since it would remove the need for all these
conversions that are going on in cpufreq drivers, but looking at the
wide usage of cpufreq and the potential drawbacks Rafael pointed at:
nice-to-have is probably not enough of a justification.

	Sören

