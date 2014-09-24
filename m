Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaIXGpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 02:45:09 -0400
Received: from mail-bn1bon0141.outbound.protection.outlook.com ([157.56.111.141]:19996
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751281AbaIXGpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 02:45:05 -0400
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
Thread-Index: AQHPyMvaWBifoj9+nk+GtZ+aL5BNi5v9R9mAgAQ5dcCABw0DgIAHZi3w
Date: Wed, 24 Sep 2014 06:45:00 +0000
Message-ID: <7076eb85d2e547d2a287c195725a0bb4@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409892517-29816-1-git-send-email-Li.Xiubo@freescale.com>
 <5412BE19.2010302@ti.com>
 <d94bf53d85884b4da0fb4da3041e5742@BY2PR0301MB0613.namprd03.prod.outlook.com>
 <541C3371.8080100@ti.com>
In-Reply-To: <541C3371.8080100@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(6029001)(199003)(51704005)(164054003)(52314003)(189002)(77096002)(46102003)(110136001)(83322001)(74502003)(86362001)(81542003)(79102003)(83072002)(31966008)(74662003)(10300001)(77982003)(97736003)(120916001)(19580395003)(50986999)(107046002)(99396003)(92566001)(64706001)(20776003)(81342003)(85852003)(85306004)(76482002)(106116001)(93886004)(106356001)(105586002)(66066001)(87936001)(2656002)(99286002)(76576001)(95666004)(4396001)(33646002)(108616004)(21056001)(80022003)(54356999)(101416001)(74316001)(76176999)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


[...]
> >>>  4 files changed, 551 insertions(+)
> >>>  create mode 100644 Documentation/devicetree/bindings/video/fsl-
> sii902x.txt
> >>>  create mode 100644 drivers/video/fbdev/fsl-sii902x.c
> >>
> >> I don't know how you picked the names of the people you sent this patch
> >> to, but looks to me that most of them are probably not interested in
> >> this patch.
> >>
> >
> > I just using the get_maintainer.pl script.
> 
> Yes, and that's good, but you have to use your judgment also.
> get_maintainer.pl gives you names of people who have at some point
> touched the files or directories you are changing. Usually only the
> first names returned by get_maintainer.pl are relevant.
> 
Okay :)


> >> Anyway, a few quick comments on the patch:
> >>
> >> - You should probably use regmap instead of direct i2c calls.
> >> Interestingly, you define regmap variable, but you never use it.
> >
> > Yes, this it's my another version in my local machine using regmap which
> > need much more test.
> >
> >> - Use defines for register offsets, instead of magic numbers.
> >
> > This will be fixed together with regmap using.
> 
> Well, it's better to send the patch only when you have tested and
> cleaned up your driver.
> 
> >> - You should not use static variables. They prevent having multiple
> >> instances of the device.
> >>
> >
> > Okay.
> >
> >> So the SiI902x chip is on the SoC, not on the board? And it's a plain
> >> standard SiI902x in other aspects?
> >>
> >
> > No, it's on board.
> >
> > And it will be used for i.MX and LS1+ platforms.
> 
> Ok. In that case, I would suggest you to move to the DRM framework. The
> fbdev framework is not suited to adding external encoders. The end
> result with fbdev will be a SoC/board specific hack driver.
> 
> That said, we already have such drivers for fbdev, so I'm not 100%
> against adding a new one. But I'm very very seriously recommending
> moving to DRM.
> 
> And if this driver is added to fbdev, I think the device tree bindings
> should use the video ports/endpoints to describe the connections.
>
I will have a try to use the DRM framework.

Thanks,

BRs
Xiubo
 
>  Tomi
> 

