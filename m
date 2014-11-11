Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaKKTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:09:57 -0500
Received: from mail-bl2on0123.outbound.protection.outlook.com ([65.55.169.123]:21568
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbaKKTJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:09:55 -0500
Message-ID: <1415732980.15957.33.camel@freescale.com>
Subject: Re: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
 platforms
From: Scott Wood <scottwood@freescale.com>
To: Yuantian Tang <Yuantian.Tang@freescale.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Tue, 11 Nov 2014 13:09:40 -0600
In-Reply-To: <6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1413515616-15874-1-git-send-email-B29983@freescale.com>
	 <CAKohpokotKSvQ13uU4MnCer+qzBUUbGVTd19y7xswCAEKk3nGQ@mail.gmail.com>
	 <6aaa50ef5f234fe2896f1c66eb646dfb@DM2PR03MB574.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR05CA0036.namprd05.prod.outlook.com (10.255.226.36) To
 CY1PR0301MB0729.namprd03.prod.outlook.com (25.160.159.147)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0729;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0729;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377424004)(189002)(24454002)(199003)(51704005)(36756003)(92726001)(92566001)(93916002)(87976001)(88136002)(86362001)(20776003)(47776003)(64706001)(89996001)(122386002)(62966003)(77096003)(50226001)(77156002)(4396001)(87286001)(103116003)(101416001)(102836001)(46102003)(50466002)(97736003)(104166001)(40100003)(120916001)(99396003)(42186005)(76176999)(50986999)(31966008)(107046002)(110136001)(33646002)(21056001)(105586002)(95666004)(106356001)(23676002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0729;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0729;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-21 at 08:59 +0000, Yuantian Tang wrote:
> > > -config PPC_CORENET_CPUFREQ
> > > -       tristate "CPU frequency scaling driver for Freescale E500MC SoCs"
> > > -       depends on PPC_E500MC && OF && COMMON_CLK
> > > +config QORIQ_CPUFREQ
> > > +       tristate "CPU frequency scaling driver for Freescale QorIQ SoCs"
> > > +       depends on OF && COMMON_CLK
> > >         select CLK_PPC_CORENET
> > >         help
> > > -         This adds the CPUFreq driver support for Freescale e500mc,
> > > -         e5500 and e6500 series SoCs which are capable of changing
> > > -         the CPU's frequency dynamically.
> > > +         This adds the CPUFreq driver support for Freescale QorIQ SoCs
> > > +         which are capable of changing the CPU's frequency dynamically.
> > >
> > >  config CPU_FREQ_PMAC
> > >         bool "Support for Apple PowerBooks"
> > 
> > Don't need this duplication at all. Just move this to Kconfig instead of .arm and
> > ppc.
> > 
> If I do so, menuconfig will display like this(on PPC):
> 	PowerPC CPU frequency scaling drivers  ----  
>     QorIQ CPU Frequency scaling  --->    
>   		<*> CPU frequency scaling driver for Freescale QorIQ SoCs
> On ARM, there should be a similar problem.
> Isn't weird?

What purpose do those "<arch> CPU frequency scaling drivers" submenus
serve, versus just including the options in the main cpufreq menu?  It's
not as if more than one arch would be visible at once (and when a
situation with multiple visible menus popped up, it was considered a
bug).

-Scott


