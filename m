Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaIRXsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:48:07 -0400
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:22347
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754082AbaIRXsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:48:05 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 19:48:05 EDT
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Kim Phillips <Kim.Phillips@freescale.com>, Alexander Graf <agraf@suse.de>
CC: Jose Rivera <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Subject: RE: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Topic: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Thread-Index: AQHP0veD82/OvXJh/kGwROtkyAcbyZwG3uaAgAB3uYCAAC458A==
Date: Thu, 18 Sep 2014 23:13:13 +0000
Message-ID: <581cd5a2ba854ef883ba488cec70ad62@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	<1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	<20140915184451.962a3a19c4940792d182f10a@freescale.com>
	<541A5CF1.8000409@freescale.com>
	<C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
 <20140918152233.41647ee517393816bb35b72a@freescale.com>
In-Reply-To: <20140918152233.41647ee517393816bb35b72a@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.168.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(479174003)(377454003)(24454002)(189002)(86362001)(92566001)(80022003)(20776003)(74502003)(79102003)(77982003)(46102003)(64706001)(66066001)(4396001)(31966008)(76176999)(97736003)(87936001)(50986999)(76576001)(54356999)(74316001)(99396002)(101416001)(74662003)(83322001)(2656002)(85852003)(19580395003)(83072002)(19580405001)(76482002)(21056001)(90102001)(85306004)(33646002)(93886004)(81542003)(108616004)(81342003)(77096002)(99286002)(95666004)(105586002)(107046002)(106116001)(106356001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0732;H:CY1PR0301MB0748.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Kim Phillips [mailto:kim.phillips@freescale.com]
> Sent: Thursday, September 18, 2014 3:23 PM
> To: Alexander Graf
> Cc: Rivera Jose-B46482; <gregkh@linuxfoundation.org>; <arnd@arndb.de>; <linux-kernel@vger.kernel.org>; Yoder
> Stuart-B08248; Wood Scott-B07421; <linuxppc-release@linux.freescale.net>
> Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> 
> On Thu, 18 Sep 2014 15:14:03 +0200
> Alexander Graf <agraf@suse.de> wrote:
> 
> > > Am 18.09.2014 um 06:17 schrieb German Rivera <German.Rivera@freescale.com>:
> > >
> > >> On 09/15/2014 06:44 PM, Kim Phillips wrote:
> > >> On Thu, 11 Sep 2014 12:34:21 -0500
> > >> "J. German Rivera" <German.Rivera@freescale.com> wrote:
> > >>
> > >>> From: "J. German Rivera" <German.Rivera@freescale.com>
> > >>>
> > >>> APIs to access the Management Complex (MC) hardware
> > >>> module of Freescale LS2 SoCs. This patch includes
> > >>> APIs to check the MC firmware version and to manipulate
> > >>> DPRC objects in the MC.
> > >>>
> > >>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> > >>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> > >>> ---
> > >>>  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
> > >>>  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
> > >>>  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
> > >>>  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
> > >>>  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
> > >>>  include/linux/fsl_dpmng.h          |  120 ++++++
> > >>>  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
> > >>>  include/linux/fsl_mc_cmd.h         |  182 +++++++++
> > >>>  include/linux/fsl_mc_sys.h         |   81 ++++
> > >>>  9 files changed, 2635 insertions(+)
> > >>>  create mode 100644 drivers/bus/fsl-mc/dpmng.c
> > >>>  create mode 100644 drivers/bus/fsl-mc/dprc.c
> > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
> > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
> > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
> > >>>  create mode 100644 include/linux/fsl_dpmng.h
> > >>>  create mode 100644 include/linux/fsl_dprc.h
> > >>>  create mode 100644 include/linux/fsl_mc_cmd.h
> > >>>  create mode 100644 include/linux/fsl_mc_sys.h
> > >>
> > >> the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
> > >> its directory name fsl-mc/.  Note that I find dashes ('-') in
> > >> filenames make them easier to type: is there a reason we're using
> > >> underscores here?
> > > This is a convention that we decided early on '-' for directory names
> > > and '_' for file names.
> 
> based on what?

We looked at how generally files were named in kernel source.

For what it's worth in my 3.16 branch:

$ find drivers/ -type f | grep '-' | wc -l
4308
$ find drivers/ -type f | grep '_' | wc -l
6507

...it seems that there are far more files named with underscores.  If Greg
or Arnd wants the files renamed, fine, but other than that I see no reason
to change this.

Stuart
