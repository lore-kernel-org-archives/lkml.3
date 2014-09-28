Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbaI1DPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:15:52 -0400
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:10272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753371AbaI1DPv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:15:51 -0400
Date: Sun, 28 Sep 2014 11:15:10 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <kernel@pengutronix.de>, <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <linux@arm.linux.org.uk>, <jingchang.lu@freescale.com>,
        <b20788@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>
Subject: Re: [PATCH 0/9] ARM: vf610: Suspend/resume support
Message-ID: <20140928031508.GB12999@dragon>
References: <cover.1411404079.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1411404079.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [221.225.208.47]
X-ClientProxiedBy: SINPR06CA009.apcprd06.prod.outlook.com (10.242.48.49) To
 DM2PR03MB351.namprd03.prod.outlook.com (10.141.54.22)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB351;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(51704005)(85306004)(97756001)(95666004)(33716001)(97736003)(50466002)(83506001)(47776003)(31966008)(21056001)(105586002)(20776003)(77096002)(83322001)(54356999)(23726002)(107046002)(64706001)(106356001)(46406003)(50986999)(66066001)(76176999)(83072002)(90102001)(74502003)(4396001)(42186005)(85852003)(110136001)(79102003)(92566001)(80022003)(33656002)(81542003)(46102003)(81342003)(74662003)(77982003)(87976001)(92726001)(102836001)(76482002)(101416001)(120916001)(10300001)(99396003)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB351;H:dragon;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 07:09:21PM +0200, Stefan Agner wrote:
> This patchset provides suspend/resume support for Freescale Vybrid
> SoC (vf610). The code is generally aligned to the implementation
> for i.MX6. The subsystems SRC and GPC need some changes to support
> the Vybrid specific implementation.
> 
> This patchset relies on GPIO driver to be present (in order to
> provide a wakeup source) as well as using the ARM Global Timer
> clock source (the Vybrid specifc PIT clock source, vf_pit_timer.c
> does not support shutdown).
> 
> The implemented sleep states (LP-RUN and STOP), are not the most
> power saving functions available on Vybrid. Especially for
> suspend-to-memory one of the LPSTOP modes looks more appropriate.
> However, the complexity is somewhat higher (we would need to move
> execution path to SRAM and store IOMUX and DDRMC configuration).
> Currently, I have not the resources to look into that so I hope
> that this initial code qualifies as power saving functions to be
> applied.

So you have quite a lot of unnecessary code which is only needed by
suspend from SRAM (store IOMUX and DDRMC configuration).

Not happy with that.

Shawn
