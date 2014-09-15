Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaIOCcw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 22:32:52 -0400
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:28832
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753244AbaIOCcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 22:32:50 -0400
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Sep 2014 22:32:49 EDT
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "peter.griffin@linaro.org" <peter.griffin@linaro.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] fbdev: fsl-sii902x: HDMI support for Freescale SoCs
Thread-Topic: [PATCH] fbdev: fsl-sii902x: HDMI support for Freescale SoCs
Thread-Index: AQHPyMvaWBifoj9+nk+GtZ+aL5BNi5v9R9mAgAQ5dcA=
Date: Mon, 15 Sep 2014 02:17:24 +0000
Message-ID: <d94bf53d85884b4da0fb4da3041e5742@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409892517-29816-1-git-send-email-Li.Xiubo@freescale.com>
 <5412BE19.2010302@ti.com>
In-Reply-To: <5412BE19.2010302@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03355EE97E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(6029001)(24454002)(479174003)(199003)(51704005)(189002)(164054003)(31966008)(86362001)(74502001)(108616004)(106356001)(106116001)(85306004)(110136001)(74662001)(74316001)(85852003)(81542001)(101416001)(76576001)(83072002)(21056001)(33646002)(105586002)(90102001)(87936001)(46102001)(79102001)(92566001)(99396002)(107046002)(76482001)(20776003)(95666004)(2656002)(66066001)(64706001)(81342001)(80022001)(99286002)(4396001)(97736003)(54356999)(76176999)(50986999)(19580395003)(19580405001)(77982001)(83322001)(77096002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0613;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomi,

Thanks very much for your comments.


> Subject: Re: [PATCH] fbdev: fsl-sii902x: HDMI support for Freescale SoCs
> 
> Hi,
> 
> On 05/09/14 07:48, Xiubo Li wrote:
> > Some Freescale SoCs, there has an DVI/HDMI controller and a PHY,
> > attached to one of their display controller unit's LCDC interfaces.
> > This patch adds a preliminary static support for such controllers.
> >
> > This will support for many modes and a dynamic switching between
> > them.
> >
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  .../devicetree/bindings/video/fsl-sii902x.txt      |  17 +
> >  drivers/video/fbdev/Kconfig                        |   7 +
> >  drivers/video/fbdev/Makefile                       |   1 +
> >  drivers/video/fbdev/fsl-sii902x.c                  | 526
> +++++++++++++++++++++
> >  4 files changed, 551 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/video/fsl-sii902x.txt
> >  create mode 100644 drivers/video/fbdev/fsl-sii902x.c
> 
> I don't know how you picked the names of the people you sent this patch
> to, but looks to me that most of them are probably not interested in
> this patch.
> 

I just using the get_maintainer.pl script.


> Anyway, a few quick comments on the patch:
> 
> - You should probably use regmap instead of direct i2c calls.
> Interestingly, you define regmap variable, but you never use it.

Yes, this it's my another version in my local machine using regmap which
need much more test.

> - Use defines for register offsets, instead of magic numbers.

This will be fixed together with regmap using.

> - You should not use static variables. They prevent having multiple
> instances of the device.
> 

Okay.

> So the SiI902x chip is on the SoC, not on the board? And it's a plain
> standard SiI902x in other aspects?
> 

No, it's on board.

And it will be used for i.MX and LS1+ platforms.

Thanks,

BRs
Xiubo
