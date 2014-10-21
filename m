Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaJUImN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:42:13 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:36352
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751014AbaJUImH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:42:07 -0400
From: Yuantian Tang <Yuantian.Tang@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: RE: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
 platforms
Thread-Topic: [PATCH] cpufreq: qoriq: Make the driver usable on all QorIQ
 platforms
Thread-Index: AQHP6bh2NIuvlhOTzUyj6ABxjLiyN5wz7kgAgAZNTAA=
Date: Tue, 21 Oct 2014 08:25:42 +0000
Message-ID: <8cf6bdb05e9b4d04994366db335f3a52@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1413515616-15874-1-git-send-email-B29983@freescale.com>
 <8F5E4DA7-8A64-4614-91E7-BFB28D91C737@kernel.crashing.org>
In-Reply-To: <8F5E4DA7-8A64-4614-91E7-BFB28D91C737@kernel.crashing.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB574;
x-forefront-prvs: 0371762FE7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(189002)(110136001)(80022003)(97736003)(108616004)(46102003)(33646002)(54356999)(76176999)(101416001)(66066001)(50986999)(21056001)(4396001)(122556002)(76482002)(107046002)(74316001)(85306004)(31966008)(99396003)(120916001)(85852003)(92566001)(95666004)(105586002)(76576001)(64706001)(86362001)(20776003)(99286002)(2656002)(87936001)(106356001)(40100003)(106116001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB574;H:DM2PR03MB574.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > #ifndef CONFIG_SMP
> > static inline const struct cpumask *cpu_core_mask(int cpu) { @@ -79,6
> > +75,79 @@ static inline const struct cpumask *cpu_core_mask(int cpu) }
> > #endif
> >
> > +#if defined(CONFIG_PPC_E500MC)
> 
> Probably should just be CONFIG_PPC, but do we need this at all.  Can't we just
> use topology_core_id() on both ARM & PPC?
> 
topology_core_id() doesn't work on PPC.
This function only supports PPC64 and non-thread SOCs.

I can make it work on PPC, but we are used to use get_hard_smp_processor_id() on ppc.

Regards,
Yuantian

> > +static int get_cpu_physical_id(int cpu) {
> > +	return get_hard_smp_processor_id(cpu); } #elif defined(CONFIG_ARM)
> > +static int get_cpu_physical_id(int cpu) {
> > +	return topology_core_id(cpu);
> > +}
> > +#endif
> > +

