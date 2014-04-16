Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaDPDqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:46:20 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:59293
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750864AbaDPDqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:46:17 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Topic: [RFC][PATCH 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Index: AQHPWSBc9k7OgjbNkEijY/VC8/wPu5sTkuOAgAAGLJA=
Date: Wed, 16 Apr 2014 03:45:56 +0000
Message-ID: <0f09e4ff3a4e42e6818bc2ab8a622b26@DM2PR03MB509.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-4-git-send-email-Li.Xiubo@freescale.com>
 <d4863b3b92ef4aebbc05ca5e6cb9aede@BN1PR03MB188.namprd03.prod.outlook.com>
In-Reply-To: <d4863b3b92ef4aebbc05ca5e6cb9aede@BN1PR03MB188.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(164054003)(51704005)(33646001)(74316001)(76482001)(81342001)(31966008)(2656002)(83322001)(19580405001)(83072002)(85852003)(74502001)(87936001)(74662001)(4396001)(80976001)(46102001)(20776003)(66066001)(80022001)(76576001)(99396002)(86362001)(76176999)(79102001)(2201001)(92566001)(77982001)(54356999)(77096999)(81542001)(99286001)(50986999)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB479;H:DM2PR03MB509.namprd03.prod.outlook.com;FPR:C049E709.30E0FFDB.F1C323BC.10DE05BB.2017C;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> > +static void ftm_set_mode(enum clock_event_mode mode,
> > +				struct clock_event_device *evt)
> > +{
> > +	switch (mode) {
> > +	case CLOCK_EVT_MODE_PERIODIC:
> > +		ftm_set_next_event(peroidic_cyc, evt);
> > +		break;
> > +	default:
> > +		break;
> 
> Remove this break;
> 

I'll revise this.


> > +	}
> > +}


[...]
> > +static void __init ftm_timer_init(struct device_node *np)
> > +{
> > +	struct clk *ftm_clk;
> > +	void __iomem *timer_base;
> > +	unsigned long freq;
> > +	int irq;
> > +
> > +	timer_base = of_iomap(np, 0);
> > +	BUG_ON(!timer_base);
> > +
> > +	clksrc_base = timer_base + FTM_OFFSET(1);
> > +	clkevt_base = timer_base + FTM_OFFSET(0);
> > +
> > +	irq = irq_of_parse_and_map(np, 0);
> > +	BUG_ON(irq <= 0);
> > +
> > +	ftm_clk = of_clk_get_by_name(np, "ftm0_counter_en");
> > +	BUG_ON(IS_ERR(ftm_clk));
> > +	BUG_ON(clk_prepare_enable(ftm_clk));
> > +
> > +	ftm_clk = of_clk_get_by_name(np, "ftm1_counter_en");
> > +	BUG_ON(IS_ERR(ftm_clk));
> > +	BUG_ON(clk_prepare_enable(ftm_clk));
> > +
> > +	ftm_clk = of_clk_get_by_name(np, "ftm0");
> > +	BUG_ON(IS_ERR(ftm_clk));
> > +	BUG_ON(clk_prepare_enable(ftm_clk));
> > +
> > +	ftm_clk = of_clk_get_by_name(np, "ftm1");
> 
> Why dts is not have ftm1 node?
> 

Because the 'ftm0: ftm@40038000' node is used to ftm0
and ftm1 device nodes at the same time.

May using 'ftm: ftm@40038000' will be much better ?

Thanks,

BRs
Xiubo



