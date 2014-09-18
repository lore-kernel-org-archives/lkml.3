Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaISBOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 21:14:00 -0400
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:3681
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750815AbaISBN6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 21:13:58 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>,
        Jose Rivera <German.Rivera@freescale.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kim Phillips <Kim.Phillips@freescale.com>,
        Scott Wood <scottwood@freescale.com>, "agraf@suse.de" <agraf@suse.de>,
        "linuxppc-release@linux.freescale.net" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0T/H82/OvXJh/kGwROtkyAcbyZwHjCHA
Date: Thu, 18 Sep 2014 23:39:48 +0000
Message-ID: <4abacb49a6724879b6b2f4ed03890ad1@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
In-Reply-To: <20140915184451.962a3a19c4940792d182f10a@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(13464003)(51704005)(377454003)(199003)(189002)(79102003)(64706001)(80022003)(83072002)(54356999)(46102003)(74502003)(81342003)(74662003)(85852003)(77982003)(21056001)(66066001)(20776003)(86362001)(92566001)(76176999)(81542003)(101416001)(83322001)(19580405001)(19580395003)(50986999)(108616004)(74316001)(99396002)(87936001)(76482002)(95666004)(106116001)(99286002)(33646002)(106356001)(105586002)(90102001)(76576001)(4396001)(31966008)(85306004)(77096002)(2656002)(107046002)(97736003)(2004002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0730;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Monday, September 15, 2014 6:45 PM
> To: Rivera Jose-B46482
> Cc: gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org; Yoder Stuart-B08248; Phillips
> Kim-R1AAHA; Wood Scott-B07421; agraf@suse.de; linuxppc-release@linux.freescale.net
> Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> 
> On Thu, 11 Sep 2014 12:34:21 -0500
> "J. German Rivera" <German.Rivera@freescale.com> wrote:
> 
> > From: "J. German Rivera" <German.Rivera@freescale.com>
> >
> > APIs to access the Management Complex (MC) hardware
> > module of Freescale LS2 SoCs. This patch includes
> > APIs to check the MC firmware version and to manipulate
> > DPRC objects in the MC.
> >
> > Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> > Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> > ---
> >  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
> >  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
> >  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
> >  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
> >  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
> >  include/linux/fsl_dpmng.h          |  120 ++++++
> >  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
> >  include/linux/fsl_mc_cmd.h         |  182 +++++++++
> >  include/linux/fsl_mc_sys.h         |   81 ++++
> >  9 files changed, 2635 insertions(+)
> >  create mode 100644 drivers/bus/fsl-mc/dpmng.c
> >  create mode 100644 drivers/bus/fsl-mc/dprc.c
> >  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
> >  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
> >  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
> >  create mode 100644 include/linux/fsl_dpmng.h
> >  create mode 100644 include/linux/fsl_dprc.h
> >  create mode 100644 include/linux/fsl_mc_cmd.h
> >  create mode 100644 include/linux/fsl_mc_sys.h
> 
> the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
> its directory name fsl-mc/.  Note that I find dashes ('-') in
> filenames make them easier to type: is there a reason we're using
> underscores here?
> 
> Also, any reason why these and future include files aren't being put
> in include/linux/fsl/, so as to not pollute the top level
> include/linux/?  That way, we can also remove the fsl- prefix from
> those filenames, too..

There is nothing in include/linux/fsl except 1 driver from 2 years ago.
Why is that?

I'd also prefer to see these headers is include/linux/fsl, but given that
the directory is essentially unused it seemed that include/linux was more
conventional.

> > diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
> > new file mode 100644
> > index 0000000..c6ed27c
> > --- /dev/null
> > +++ b/drivers/bus/fsl-mc/dpmng.c
> > @@ -0,0 +1,93 @@
> > +/* Copyright 2013-2014 Freescale Semiconductor Inc.
> > + *
> > + * Redistribution and use in source and binary forms, with or without
> > + * modification, are permitted provided that the following conditions are met:
> > + *     * Redistributions of source code must retain the above copyright
> > + *       notice, this list of conditions and the following disclaimer.
> > + *     * Redistributions in binary form must reproduce the above copyright
> > + *       notice, this list of conditions and the following disclaimer in the
> > + *       documentation and/or other materials provided with the distribution.
> > + *     * Neither the name of Freescale Semiconductor nor the
> > + *       names of its contributors may be used to endorse or promote products
> > + *       derived from this software without specific prior written permission.
> > + *
> > + *
> > + * ALTERNATIVELY, this software may be distributed under the terms of the
> > + * GNU General Public License ("GPL") as published by the Free Software
> > + * Foundation, either version 2 of that License or (at your option) any
> > + * later version.
> > + *
> > + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
> 
> interesting, normally this text reads:
> 
> "THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS"
> 
> ...does that mean we're excluding non-Freescale copyright holders
> and contributors from this warranty statement?  That doesn't seem
> appropriate for an upstream kernel submission.

This is a standard license dual license used by Freescale, wording
most likely set by the legal dept. 

There are many instances of it in the kernel (mostly in device trees).

git grep 'THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor' | wc -l
180

Unless it is condition of being accepted into the kernel I want
to leave it as is.

Stuart
