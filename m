Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaIRXDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:03:25 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:27328
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750815AbaIRXDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:03:24 -0400
X-Greylist: delayed 109350 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2014 19:03:24 EDT
Message-ID: <1411081392.13320.15.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@freescale.com>
CC: Alexander Graf <agraf@suse.de>,
        German Rivera <German.Rivera@freescale.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<arnd@arndb.de>" <arnd@arndb.de>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<stuart.yoder@freescale.com>" <stuart.yoder@freescale.com>,
        "<linuxppc-release@linux.freescale.net>" 
	<linuxppc-release@linux.freescale.net>
Date: Thu, 18 Sep 2014 18:03:12 -0500
In-Reply-To: <20140918152233.41647ee517393816bb35b72a@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
	 <541A5CF1.8000409@freescale.com>
	 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	 <20140918152233.41647ee517393816bb35b72a@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:9d2d:42ec:ad0e:7ffa]
X-ClientProxiedBy: DM2PR04CA033.namprd04.prod.outlook.com (10.141.154.151) To
 BN1PR0301MB0723.namprd03.prod.outlook.com (25.160.78.142)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0723;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(377424004)(377454003)(479174003)(189002)(24454002)(51704005)(86362001)(46102003)(74662003)(77096002)(81542003)(77982003)(4396001)(93916002)(97736003)(80022003)(74502003)(81342003)(79102003)(31966008)(90102001)(50226001)(106356001)(105586002)(50466002)(20776003)(95666004)(104166001)(89996001)(47776003)(33646002)(88136002)(76482002)(103116003)(50986999)(21056001)(76176999)(102836001)(19580405001)(83322001)(107046002)(83072002)(19580395003)(101416001)(42186005)(85852003)(85306004)(62966002)(93886004)(64706001)(110136001)(92726001)(87286001)(87976001)(92566001)(23676002)(77156001)(99396002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0723;H:[IPv6:2601:2:5800:3f7:9d2d:42ec:ad0e:7ffa];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-18 at 15:22 -0500, Kim Phillips wrote:
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

I agree with Kim here.

> > >>> +/**
> > >>> + * @brief    Management Complex firmware version information
> > >>> + */
> > >>> +#define MC_VER_MAJOR 2
> > >>> +#define MC_VER_MINOR 0
> > >> 
> > >> code should be adjusted to run on all *compatible* versions of h/w,
> > >> not strictly the one set in these defines.
> > > This comment is not precise enough be actionable.
> > > What exactly you want to be changed  here?
> > 
> >
> > I think the easy thing to do is to convert the exact version check
> > into a ranged version check: have minimum and maximum versions you
> > support. Or a list of exact versions you support. Or not check for the
> > version at all - or only for the major version and guarantee that the
> > major version indicates backwards compatibility.
> >
> yes, this was my point: elsewhere I noticed the code denies to run
> iff those defines are not matched exactly: that code should change
> to run as Alex describes.

Also keep in mind that in the future we may need to support multiple
versions that behave differently.

-Scott


