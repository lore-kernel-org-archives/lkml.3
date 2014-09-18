Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbaIRXqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:46:45 -0400
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:49434
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751223AbaIRXqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:46:43 -0400
X-Greylist: delayed 1051 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 19:46:43 EDT
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: Kim Phillips <Kim.Phillips@freescale.com>, Alexander Graf <agraf@suse.de>,
        Jose Rivera <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAB3uYCAAC458IAABeYAgAADROA=
Date: Thu, 18 Sep 2014 23:46:40 +0000
Message-ID: <9dc0e51cd48f453dbd22e2eb9f5719e5@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
	 <541A5CF1.8000409@freescale.com>
	 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	 <20140918152233.41647ee517393816bb35b72a@freescale.com>
	 <581cd5a2ba854ef883ba488cec70ad62@CY1PR0301MB0748.namprd03.prod.outlook.com>
 <1411082946.13320.29.camel@snotra.buserror.net>
In-Reply-To: <1411082946.13320.29.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(13464003)(377424004)(51704005)(377454003)(479174003)(199003)(189002)(79102003)(64706001)(80022003)(83072002)(54356999)(46102003)(74502003)(81342003)(74662003)(85852003)(77982003)(21056001)(66066001)(20776003)(86362001)(92566001)(76176999)(81542003)(110136001)(101416001)(83322001)(19580405001)(19580395003)(50986999)(108616004)(74316001)(99396002)(87936001)(76482002)(95666004)(106116001)(99286002)(33646002)(106356001)(105586002)(90102001)(76576001)(4396001)(31966008)(93886004)(85306004)(77096002)(2656002)(107046002)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0730;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8INknnQ012800



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Thursday, September 18, 2014 6:29 PM
> To: Yoder Stuart-B08248
> Cc: Phillips Kim-R1AAHA; Alexander Graf; Rivera Jose-B46482; gregkh@linuxfoundation.org; arnd@arndb.de;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> 
> On Thu, 2014-09-18 at 18:13 -0500, Yoder Stuart-B08248 wrote:
> >
> > > -----Original Message-----
> > > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > > Sent: Thursday, September 18, 2014 3:23 PM
> > > To: Alexander Graf
> > > Cc: Rivera Jose-B46482; <gregkh@linuxfoundation.org>; <arnd@arndb.de>; <linux-kernel@vger.kernel.org>;
> Yoder
> > > Stuart-B08248; Wood Scott-B07421; <linuxppc-release@linux.freescale.net>
> > > Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> > >
> > > On Thu, 18 Sep 2014 15:14:03 +0200
> > > Alexander Graf <agraf@suse.de> wrote:
> > >
> > > > > Am 18.09.2014 um 06:17 schrieb German Rivera <German.Rivera@freescale.com>:
> > > > >
> > > > >> On 09/15/2014 06:44 PM, Kim Phillips wrote:
> > > > >> On Thu, 11 Sep 2014 12:34:21 -0500
> > > > >> "J. German Rivera" <German.Rivera@freescale.com> wrote:
> > > > >>
> > > > >>> From: "J. German Rivera" <German.Rivera@freescale.com>
> > > > >>>
> > > > >>> APIs to access the Management Complex (MC) hardware
> > > > >>> module of Freescale LS2 SoCs. This patch includes
> > > > >>> APIs to check the MC firmware version and to manipulate
> > > > >>> DPRC objects in the MC.
> > > > >>>
> > > > >>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> > > > >>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> > > > >>> ---
> > > > >>>  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
> > > > >>>  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
> > > > >>>  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
> > > > >>>  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
> > > > >>>  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
> > > > >>>  include/linux/fsl_dpmng.h          |  120 ++++++
> > > > >>>  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
> > > > >>>  include/linux/fsl_mc_cmd.h         |  182 +++++++++
> > > > >>>  include/linux/fsl_mc_sys.h         |   81 ++++
> > > > >>>  9 files changed, 2635 insertions(+)
> > > > >>>  create mode 100644 drivers/bus/fsl-mc/dpmng.c
> > > > >>>  create mode 100644 drivers/bus/fsl-mc/dprc.c
> > > > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
> > > > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
> > > > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
> > > > >>>  create mode 100644 include/linux/fsl_dpmng.h
> > > > >>>  create mode 100644 include/linux/fsl_dprc.h
> > > > >>>  create mode 100644 include/linux/fsl_mc_cmd.h
> > > > >>>  create mode 100644 include/linux/fsl_mc_sys.h
> > > > >>
> > > > >> the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
> > > > >> its directory name fsl-mc/.  Note that I find dashes ('-') in
> > > > >> filenames make them easier to type: is there a reason we're using
> > > > >> underscores here?
> > > > > This is a convention that we decided early on '-' for directory names
> > > > > and '_' for file names.
> > >
> > > based on what?
> >
> > We looked at how generally files were named in kernel source.
> >
> > For what it's worth in my 3.16 branch:
> >
> > $ find drivers/ -type f | grep '-' | wc -l
> > 4308
> > $ find drivers/ -type f | grep '_' | wc -l
> > 6507
> >
> > ...it seems that there are far more files named with underscores.  If Greg
> > or Arnd wants the files renamed, fine, but other than that I see no reason
> > to change this.
> 
> 60% isn't "far more".  Regardless of whether we change this (dashes are
> easier to read, easier to type, and are what English normally uses --
> underscores are for when you can't use a dash for technical reasons),
> let's not start making rules based on weak statistical inferences.
> 
> Plus, why limit the search to drivers?

It's a driver and we looked at the precedent/conventions used by
other drivers.

> E.g. if you looked at arch/
> you'd reach the opposite conclusion.

I guess if you look at the kernel as a whole it's almost exactly
50/50.  So, don't understand how anyone can say it is _clear_
that underscores are better.

Stuart
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
