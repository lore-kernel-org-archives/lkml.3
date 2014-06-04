Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaFDBpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:45:30 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:28256
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752439AbaFDBp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:45:28 -0400
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
Thread-Index: AQHPfw914N6/1BltqEeVaM9JvGUSI5tfd7eAgACwf4CAAAVUAA==
Date: Wed, 4 Jun 2014 01:45:23 +0000
Message-ID: <411dd8052ca74ed38810f2a5248063e2@BL2PR03MB226.namprd03.prod.outlook.com>
References: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org>
 <538E745B.1020200@windriver.com>
In-Reply-To: <538E745B.1020200@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(51704005)(189002)(199002)(83072002)(86362001)(85852003)(2171001)(76176999)(50986999)(76576001)(54356999)(92566001)(87936001)(2656002)(19580395003)(83322001)(19580405001)(101416001)(21056001)(74316001)(79102001)(81542001)(46102001)(31966008)(80022001)(81342001)(74502001)(99396002)(74662001)(77982001)(99286001)(33646001)(66066001)(64706001)(76482001)(4396001)(20776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB225;H:BL2PR03MB226.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Peter.Chen@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
> Author: Robert Baldyga <r.baldyga@samsung.com>
> Date:   Thu Nov 21 13:49:18 2013 +0100
> 
>      usb: gadget: s3c-hsotg: fix disconnect handling
> 
>      This patch moves s3c_hsotg_disconnect function call from USBSusp
> interrupt
>      handler to SET_ADDRESS request handler.
> 

It is a little strange we call gadget's disconnect at SET_ADDRESS?
How the udc calls gadget driver the disconnection has happened when
the usb cable is disconnected from the host?

Usually, we call gadget's disconnect at two situations

- udc's reset handler if udc's speed is not UNKNOWN, it is usually happened
when the host sends reset after enumeration.
- udc's disconnect handler, it is usually happened when the usb cable
is disconnected from host.

Peter
