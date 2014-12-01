Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaLAW2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:28:44 -0500
Received: from mail-bn1bbn0105.outbound.protection.outlook.com ([157.56.111.105]:49664
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932160AbaLAW2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:28:42 -0500
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alexander Graf <agraf@suse.de>, Jose Rivera <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>,
        "bhamciu1@freescale.com" <bhamciu1@freescale.com>,
        "R89243@freescale.com" <R89243@freescale.com>,
        Geoff Thorpe <Geoff.Thorpe@freescale.com>,
        "bhupesh.sharma@freescale.com" <bhupesh.sharma@freescale.com>,
        "nir.erez@freescale.com" <nir.erez@freescale.com>,
        Richard Schmitt <richard.schmitt@freescale.com>
Subject: RE: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
Thread-Topic: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex
 APIs
Thread-Index: AQHQCk6VizjvEAXJzUaTeK76eOkwuZx7VtaA
Date: Mon, 1 Dec 2014 22:28:36 +0000
Message-ID: <CY1PR0301MB0748FD38A1FD925F273EB33A877D0@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1415901246-24131-1-git-send-email-German.Rivera@freescale.com>
 <1415901246-24131-2-git-send-email-German.Rivera@freescale.com>
 <54773557.6020600@suse.de>
In-Reply-To: <54773557.6020600@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1305;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1305;
x-forefront-prvs: 0412A98A59
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(13464003)(51704005)(24454002)(199003)(51444003)(377454003)(86362001)(46102003)(62966003)(77156002)(74316001)(19580395003)(19580405001)(54606007)(66066001)(92566001)(99286002)(2201001)(95666004)(68736005)(92726001)(77096004)(31966008)(54356999)(76176999)(50986999)(64706001)(105586002)(33656002)(101416001)(20776003)(106356001)(76576001)(2656002)(2501002)(107046002)(87936001)(54206007)(99396003)(4396001)(122556002)(106116001)(40100003)(97736003)(21056001)(120916001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1305;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1178;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Alexander Graf [mailto:agraf@suse.de]
> Sent: Thursday, November 27, 2014 8:30 AM
> To: Rivera Jose-B46482; gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org
> Cc: Yoder Stuart-B08248; Phillips Kim-R1AAHA; Wood Scott-B07421; Hamciuc Bogdan-BHAMCIU1; Marginean
> Alexandru-R89243; Thorpe Geoff-R01361; Sharma Bhupesh-B45370; Erez Nir-RM30794; Schmitt Richard-B43082
> Subject: Re: [PATCH 1/3 v4] drivers/bus: Added Freescale Management Complex APIs
> 
> 
> 
> On 13.11.14 18:54, J. German Rivera wrote:
> > APIs to access the Management Complex (MC) hardware
> > module of Freescale LS2 SoCs. This patch includes
> > APIs to check the MC firmware version and to manipulate
> > DPRC objects in the MC.
> >
> > Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> > Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> 
> [...]
> 
> > +/*
> > + * Object descriptor, returned from dprc_get_obj()
> > + */
> > +struct dprc_obj_desc {
> > +	/* Type of object: NULL terminated string */
> > +	char type[16];
> 
> I don't see where it actually gets NULL terminated - all 16 bytes come
> directly from the device.
> 
> While it's probably ok to trust it, I think we'd still be safer off if
> we just make this a char[17] array to always have our NULL terminating
> string. That way we're guaranteed we'll never run over our memory
> boundaries.

The device is supposed to guarantee that the string is null 
terminated...so there will never be valid chars in the 16th
character.  So, what about just forcing type[15] = '\0'?

I think that would be better than making it a char[17].

Stuart
