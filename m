Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892AbaGPL6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:58:22 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:45655
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759448AbaGPL6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:58:18 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>,
        =?iso-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
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
Subject: RE: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Topic: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Index: AQHPoM+g9rJqVrp5SkK+NRByw9cq15uiYcMAgAAJm4CAABBXAIAAGzwg
Date: Wed, 16 Jul 2014 11:58:14 +0000
Message-ID: <cd73d8a384cc4040a0bbc6afc1f3063d@DM2PR0301MB0783.namprd03.prod.outlook.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <42036198.zWkqnus6xa@wuerfel> <20140716091533.GB28151@kwain>
 <5615007.cNNjmu3rBK@wuerfel>
In-Reply-To: <5615007.cNNjmu3rBK@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(199002)(189002)(81542001)(74316001)(4396001)(79102001)(76482001)(31966008)(87936001)(99286002)(2656002)(106356001)(33646002)(83072002)(66066001)(76576001)(85852003)(21056001)(54356999)(92566001)(64706001)(99396002)(74502001)(81342001)(86362001)(93886003)(74662001)(101416001)(106116001)(105586002)(50986999)(46102001)(80022001)(76176999)(77096002)(77982001)(95666004)(83322001)(85306003)(20776003)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0782;H:DM2PR0301MB0783.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> >
> > Some people wanted the possibility to set the DMA mask as this USB2 CI
> > driver does not do specific Berlin operation and can be reused later.
> > I don't particularly need to call dma_coerce_mask_and_coherent() in my
> > case, as far as I know.
> 
> Ok, just remove the call then and rely on the default mask.
> 
> > They can maybe give the restrictions they might want to put on the DMA
> > mask.
> 
> If the restriction is from the bus, it should get handled automatically
> by the device probe as long as the correct dma-ranges property is there
> (though we have a small bug there at the moment). If there is a variation
> of ci13xxx that can't do 32-bit DMA, that should use a different
> compatible string and pass a fixed mask into dma_set_mask_and_coherent()
> based on the device.
> 

Correct me if my below understanding is wrong please.

For three chipidea users:
user_a: don't need dma mask
user_b: dma mask value is dma_mask_b
user_c: dma mask value is dma_mask_c

We don't need to call dma_coerce_mask_and_coherent() at generic chipidea
glue driver, and set dma-ranges as dma_mask_b at user_b's dts, and set
dma-ranges as dma_mask_c at user_c's dts.

Peter 
