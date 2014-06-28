Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaF1PJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 11:09:33 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:11001
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751215AbaF1PJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 11:09:31 -0400
Date: Sat, 28 Jun 2014 22:52:54 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: <rjw@rjwysocki.net>, <sboyd@codeaurora.org>,
        <linaro-kernel@lists.linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <arvind.chauhan@arm.com>,
        <mturquette@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <spk.linux@gmail.com>,
        <thomas.ab@samsung.com>, <nm@ti.com>, <t.figa@samsung.com>
Subject: Re: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
Message-ID: <20140628145253.GB7869@dragon>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
 <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130484407914903507;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(448002)(189002)(199002)(69224002)(24454002)(51704005)(6806004)(46406003)(19580405001)(68736004)(26826002)(79102001)(76482001)(74662001)(80022001)(23726002)(81542001)(19580395003)(83322001)(69596002)(50986999)(74502001)(107046002)(21056001)(81156004)(47776003)(106466001)(99396002)(20776003)(83072002)(85852003)(31966008)(54356999)(4396001)(44976005)(77982001)(64706001)(84676001)(46102001)(87936001)(50466002)(57986006)(95666004)(85306003)(104016002)(86362001)(92566001)(85326001)(33716001)(76176999)(92726001)(97736001)(102836001)(83506001)(33656002)(15975445006)(81342001)(97756001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB372;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0256C18696
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 02:12:29PM +0530, Viresh Kumar wrote:
> cpufreq-cpu0 driver supports only platforms which have single clock line shared
> among all CPUs.
> 
> We already have platforms where this limitation doesn't hold true.For example on
> Qualcomm's KRAIT all CPUs have separate clock line and so have separate
> policies.
> 
> Instead of adding another driver for this (Stephen just tried that:
> https://lkml.org/lkml/2014/6/24/918), we must reuse cpufreq-cpu0 driver.
> 
> cpufreq-cpu0 must be updated to break the assumption on which it is based (all
> cores sharing clock line) and this patch tries to do exactly that.
> 
> As we don't have standard DT bindings to mention CPUs sharing clock-line, i.e.
> affected_cpus, this patch also have few limitations. Though easy to fix once we
> have proper bindings.
> 
> Limitation: We only supports two types of platforms:
> - All CPUs sharing same clock line, existing user platforms
> - All CPUs have separate clock lines, KRAIT
> 
> And so platforms which have multiple clusters with multiple CPUs per cluster
> aren't supported yet. We need proper bindings for that first.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   8 +-
>  drivers/cpufreq/Kconfig                            |   5 +-
>  drivers/cpufreq/cpufreq-cpu0.c                     | 280 +++++++++++++--------
>  3 files changed, 190 insertions(+), 103 deletions(-)

Hi Viresh,

Thanks for all the effort on maintaining and improving cpufreq-cpu0
driver.  Your patch rewrote the most part of the driver, so I'd like to
hand over the driver to you.  Please add yourself as the primary person
for MODULE_AUTHOR.

Shawn
