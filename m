Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaFDElo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 00:41:44 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:25634
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750717AbaFDElm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 00:41:42 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: "Yang,Wei" <Wei.Yang@windriver.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Andrzej Pietrasiewicz" <andrzej.p@samsung.com>
CC: Felipe Balbi <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
Thread-Topic: [PATCH v1] USB:gadget: Fix a warning while loading
 g_mass_storage
Thread-Index: AQHPfw914N6/1BltqEeVaM9JvGUSI5tfd7eAgACwf4CAAAVUAIAAGvUAgAAWeeA=
Date: Wed, 4 Jun 2014 04:41:20 +0000
Message-ID: <1671f94cdace4264b3064749b9fec948@BL2PR03MB226.namprd03.prod.outlook.com>
References: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org>
 <538E745B.1020200@windriver.com>
 <411dd8052ca74ed38810f2a5248063e2@BL2PR03MB226.namprd03.prod.outlook.com>
 <538E8F70.2010600@windriver.com>
In-Reply-To: <538E8F70.2010600@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(377454003)(189002)(199002)(479174003)(24454002)(33646001)(74502001)(50986999)(54356999)(87936001)(31966008)(2171001)(74662001)(76176999)(83322001)(19580405001)(76576001)(19580395003)(99396002)(93886002)(66066001)(80022001)(99286001)(74316001)(85852003)(79102001)(20776003)(64706001)(4396001)(92566001)(86362001)(81542001)(81342001)(46102001)(2656002)(83072002)(76482001)(77982001)(101416001)(21056001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB226;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On 06/04/2014 09:45 AM, Peter Chen wrote:
> >
> >> commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
> >> Author: Robert Baldyga <r.baldyga@samsung.com>
> >> Date:   Thu Nov 21 13:49:18 2013 +0100
> >>
> >>       usb: gadget: s3c-hsotg: fix disconnect handling
> >>
> >>       This patch moves s3c_hsotg_disconnect function call from
> >> USBSusp interrupt
> >>       handler to SET_ADDRESS request handler.
> >>
> > It is a little strange we call gadget's disconnect at SET_ADDRESS?
> > How the udc calls gadget driver the disconnection has happened when
> > the usb cable is disconnected from the host?
> >
> > Usually, we call gadget's disconnect at two situations
> >
> > - udc's reset handler if udc's speed is not UNKNOWN, it is usually
> > happened when the host sends reset after enumeration.
> > - udc's disconnect handler, it is usually happened when the usb cable
> > is disconnected from host.
> 
> Hmm, usually the two situations, but according to the commit log, s3c
> hsotg does not support Disconnected interrupt for device mode, so the
> second situation does not happen for s3c hsotg, therefore, he has to
> disconnect the connection before it is connected again.
> 

Then, it seems Samsung uses other solution to detect disconnection, otherwise
how it notifies the app it has disconnected, eg, we disconnect usb cable with
pc for android phone, the usb icon should be disappeared.

Peter

