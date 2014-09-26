Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbaIZOwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:52:31 -0400
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:12837
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755546AbaIZOwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:52:30 -0400
Date: Fri, 26 Sep 2014 22:51:49 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <kernel@pengutronix.de>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <bpringlemeir@nbsps.com>,
        <l.stach@pengutronix.de>
Subject: Re: [PATCH v3 4/5] ARM: dts: vf610: use new GPIO support
Message-ID: <20140926145147.GA5737@dragon>
References: <cover.1411662961.git.stefan@agner.ch>
 <590a5fbc4f8b552355a93c1002041765352cd1c3.1411662961.git.stefan@agner.ch>
 <20140926012126.GC21077@dragon>
 <f3bba83ea15d680c852eb7d6e45de08a@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f3bba83ea15d680c852eb7d6e45de08a@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [121.227.51.193]
X-ClientProxiedBy: SIXPR01CA001.apcprd01.prod.exchangelabs.com (10.242.58.11)
 To BL2PR03MB339.namprd03.prod.outlook.com (10.141.68.23)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB339;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(189002)(199003)(47776003)(20776003)(76176999)(50986999)(97756001)(83072002)(85852003)(66066001)(64706001)(107046002)(83322001)(99396003)(110136001)(42186005)(33656002)(83506001)(54356999)(23726002)(50466002)(101416001)(77096002)(95666004)(85306004)(31966008)(93886004)(21056001)(46102003)(77982003)(4396001)(120916001)(87976001)(102836001)(105586002)(33716001)(92566001)(86362001)(92726001)(46406003)(97736003)(79102003)(81342003)(76482002)(74502003)(74662003)(10300001)(80022003)(81542003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB339;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB616;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 09:40:34AM +0200, Stefan Agner wrote:
> This GPIO's are meant to be used from user space by default. The latest
> implementation of imx_pmx_gpio_request_enable not only takes care of the
> muxing, but also applies the whole pad settings. Hence we do not need
> the pinctrl subsystem to apply it (through pinctrl-* dt properties).
> 
> I changed this now in v3, in v2 I had still to use the pinctrl-*
> properties. I like that 3rd version much more, this way the pin only
> really gets muxed when the user uses it (e.g. we save power because the
> pad is disabled when the GPIO is not in use). If the pin needs to be in
> a defined state, then we would have to explicitly configure/enable it
> through a pinctrl-* properties, but this is not the case for these
> external GPIO's.

Ah, yes, you're right.  I was still thinking about the way how it worked
before your patch.

Patch applied, thanks.
