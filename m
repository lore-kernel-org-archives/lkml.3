Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaIPOn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 10:43:28 -0400
Received: from mail-bn1on0079.outbound.protection.outlook.com ([157.56.110.79]:61830
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754568AbaIPOnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 10:43:25 -0400
Date: Tue, 16 Sep 2014 09:22:43 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Weike Chen <alvin.chen@intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/4 v4] GPIO: gpio-dwapb: Enable platform driver binding
 to MFD driver
In-Reply-To: <1410859335-11080-2-git-send-email-alvin.chen@intel.com>
Message-ID: <alpine.DEB.2.02.1409160921020.4740@atx-linux-37>
References: <1410859335-11080-1-git-send-email-alvin.chen@intel.com> <1410859335-11080-2-git-send-email-alvin.chen@intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CO1PR06CA051.namprd06.prod.outlook.com (10.242.160.41) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(189002)(199003)(101416001)(90102001)(46406003)(95666004)(69596002)(20776003)(85852003)(66066001)(50986999)(23726002)(77096002)(81156004)(105586002)(54356999)(31966008)(42186005)(86152002)(110136001)(76176999)(87976001)(99396002)(50466002)(107046002)(85306004)(64706001)(97736003)(92566001)(4396001)(83072002)(76482001)(53416004)(33716001)(102836001)(21056001)(83322001)(79102003)(77982003)(86362001)(47776003)(92726001)(74502003)(81542003)(106356001)(81342003)(46102003)(74662003)(80022003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014, Weike Chen wrote:

One more:

> +
> +		/*
> +		 * Only port A can provide interrupts in all configurations of
> +		 * the IP.
> +		 */
> +		if (pp->idx == 0 &&
> +		    of_property_read_bool(port_np, "interrupt-controller")) {
> +			pp->irq = irq_of_parse_and_map(port_np, 0);
> +			if (!pp->irq) {
> +				dev_warn(dev, "no irq for bank %s\n",
> +					 port_np->full_name);
> +			}
> +		} else {
> +			pp->irq	= 0;
> +		}

The else clause is not needed since pp->irq == 0 already, right?

Alan

> +
> +		pp->irq_shared	= false;
> +		pp->gpio_base	= -1;
> +		pp->name	= port_np->full_name;
> +	}
> +
> +	return pdata;
> +}
