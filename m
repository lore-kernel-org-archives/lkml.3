Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaIQABD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:01:03 -0400
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:24035
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754103AbaIQABA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:01:00 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Topic: [PATCH v5 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Index: AQHP0NDpWnm3JjW0pU2AiZfxawwF/JwDdS2AgABQP4CAAAeXgIAAo1wQ
Date: Wed, 17 Sep 2014 00:00:57 +0000
Message-ID: <9aaef3c1f0944174b725371fff9813ab@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1410777378-12726-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410777378-12726-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140916005129.GC3379@peterchendt> <20140916133841.GA4869@kwain>
 <20140916140551.GE4869@kwain>
In-Reply-To: <20140916140551.GE4869@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(189002)(199003)(76176999)(106116001)(101416001)(50986999)(85852003)(107046002)(92566001)(106356001)(31966008)(20776003)(79102003)(83072002)(105586002)(4396001)(90102001)(97736003)(110136001)(86362001)(85306004)(83322001)(19580405001)(46102003)(80022003)(99396002)(93886004)(74316001)(19580395003)(76576001)(33646002)(21056001)(99286002)(64706001)(54356999)(2656002)(87936001)(108616004)(76482002)(66066001)(81542003)(77982003)(77096002)(95666004)(74662003)(74502003)(81342003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0770;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > > Tested on the Marvell Berlin SoCs USB controllers.
> > > >
> > > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > > > ---
> > > >  drivers/usb/chipidea/Makefile       |   1 +
> > > >  drivers/usb/chipidea/ci_hdrc_usb2.c | 137
> > > > ++++++++++++++++++++++++++++++++++++
> > > >  2 files changed, 138 insertions(+)  create mode 100644
> > > > drivers/usb/chipidea/ci_hdrc_usb2.c
> > > >
> > >
> > > compile error:
> > >
> > > /home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c: In
> function 'ci_hdrc_usb2_dt_probe':
> > > /home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c:30
> > > :2: error: implicit declaration of function 'of_phy_get'
> > > [-Werror=implicit-function-declaration]
> > > /home/peter/work/projects/usb/drivers/usb/chipidea/ci_hdrc_usb2.c:30
> > > :16: warning: assignment makes pointer from integer without a cast
> > > [enabled by default]
> >
> > Did you apply the series introducing the support for the generic PHY
> > framework in the USB subsystem first? One of the patches includes
> > 'linux/phy/phy.h' in 'linux/usb/otg.h'. That's why I did not encounter
> > this error.
> >
> > Anyway, you're right and 'linux/phy/phy.h' should be explicitly
> > included here.
> 
> Let me know if you want me to quickly cook up a new version fixing this.
> 

You can send this fix if you don't want to get comments for other parts in this
series.

I also see other dependencies like generic phy support for chipidea with this one.
I think the 7th and 8th in this series are ok after adding 'linux/phy/phy.h', but
you generic phy support series should be queued before this one.

Peter
