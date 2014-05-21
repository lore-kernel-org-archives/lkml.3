Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaEUOQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 10:16:45 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:52746
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751395AbaEUOQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 10:16:44 -0400
Date: Wed, 21 May 2014 22:16:24 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Sudeep Holla <sudeep.holla@arm.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        "inderpal.s@samsung.com" <inderpal.s@samsung.com>,
        "nm@ti.com" <nm@ti.com>,
        "chander.kashyap@linaro.org" <chander.kashyap@linaro.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: [PATCH V2 5/7] cpufreq: imx6q: don't initialize opp table
Message-ID: <20140521141622.GB27211@dragon>
References: <cover.1400670427.git.viresh.kumar@linaro.org>
 <cc399206d57ef946d27a98203c6b0a247cd1b245.1400670427.git.viresh.kumar@linaro.org>
 <537CB328.6000400@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <537CB328.6000400@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130451554009184256;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(99396002)(44976005)(6806004)(102836001)(77982001)(92726001)(69596002)(81342001)(81542001)(50986999)(57986005)(76176999)(54356999)(87936001)(85852003)(77096999)(83072002)(86362001)(81156002)(21056001)(74502001)(64706001)(31966008)(74662001)(4396001)(46406003)(20776003)(47776003)(80022001)(83506001)(76482001)(97756001)(79102001)(50466002)(92566001)(46102001)(33656002)(84676001)(97736001)(68736004)(33716001)(23726002)(32563001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB415;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 03:07:36PM +0100, Sudeep Holla wrote:
> >@@ -376,7 +356,7 @@ static void __init imx6q_init_late(void)
> >  		imx6q_cpuidle_init();
> >
> >  	if (IS_ENABLED(CONFIG_ARM_IMX6Q_CPUFREQ)) {
> >-		imx6q_opp_init();
> >+		imx6q_opp_check_speed_grading();
> 
> [Query] Not exactly related to this patch, but asking it here to get clarified.
> 
> This OPP limiting is done as part of late initcall and if the cpufreq driver is
> built in the kernel, there will be a small window where the OPPs not supported
> are still enabled ? Will that not be an issue if say performance governor is
> selected by default.

Even if cpufreq driver is built in the kernel, it won't be probed until
platform_device_register(&imx6q_cpufreq_pdev) is called.  And we make
this call only after the OPP limiting.

Shawn
