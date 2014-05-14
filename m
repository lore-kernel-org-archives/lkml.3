Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaENRb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:31:26 -0400
Received: from mail-bn1bon0135.outbound.protection.outlook.com ([157.56.111.135]:20847
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751751AbaENRbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:31:23 -0400
X-Greylist: delayed 100113 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 13:31:23 EDT
Date: Wed, 14 May 2014 10:29:38 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rdunlap@infradead.org>,
        <linux@arm.linux.org.uk>, <daniel.lezcano@linaro.org>,
        <tglx@linutronix.de>, <thierry.reding@gmail.com>,
        <florian.vaussard@epfl.ch>, <jic23@kernel.org>, <jason@lakedaemon.net>,
        <andrew@lunn.ch>, <silvio.fricke@gmail.com>, <heiko.stuebner@bq.com>,
        <olof@lixom.net>, <sebastian.hesselbarth@gmail.com>,
        <sboyd@codeaurora.org>, <gregory.clement@free-electrons.com>,
        <arnd@arndb.de>, <robherring2@gmail.com>, <marc.zyngier@arm.com>,
        <maxime.ripard@free-electrons.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/6] clocksource: Add support for the Mediatek SoCs
References: <1400087579-4250-1-git-send-email-matthias.bgg@gmail.com>
 <1400087579-4250-2-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400087579-4250-2-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2fe960fd-b145-42a8-ace2-e2cd3aaf0cdc@BN1AFFO11FD010.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(6029001)(438001)(24454002)(377424004)(199002)(51704005)(189002)(83506001)(46102001)(92566001)(83072002)(74316001)(54356999)(33646001)(85182001)(85852003)(99396002)(53416003)(102836001)(76176999)(50466002)(87936001)(50986999)(79102001)(83322001)(23676002)(70736001)(74502001)(31966008)(44976005)(81542001)(81342001)(80022001)(92726001)(31696002)(47776003)(86362001)(77982001)(74662001)(85202002)(4396001)(20776003)(76482001)(23106003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1AFFO11HUB051;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

just a few suggestions below. Nothing serious.

On Wed, 2014-05-14 at 07:12PM +0200, Matthias Brugger wrote:
> This patch adds a clock source and clock event for the timer found
> on the Mediatek SoCs.
> 
> The Mediatek General Porpose Timer block provides five 32 bit timers and
> one 64 bit timer.
> 
> Two 32 bit timers are used:
> TIMER1: clock events supporting periodic and oneshot events
> TIMER2: clock source configured as a free running counter

It is pretty common, I think, to use the free running counter also as
sched_clock. You probably want to look into this, but that's just a
possible enhancement.

[...]
> +static void __init mtk_timer_init(struct device_node *node)
> +{
> +	struct mtk_clock_event_device *evt;
> +	struct resource res;
> +	unsigned long rate = 0;
> +	struct clk *clk;
> +	int ret;
> +	u32 val;
> +
> +	evt = kzalloc(sizeof(*evt), GFP_KERNEL);
> +	if (!evt)
> +		panic("Can't allocate mtk clock event driver struct");

I'm not that sure about the A7s, but on Cortex-A9 there is also a global
timer which can be used for timing. And there might be other timing
options for this SOC too. Do you really want to panic?

	Sören
