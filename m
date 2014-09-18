Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbaIRX3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:29:17 -0400
Received: from mail-bn1on0119.outbound.protection.outlook.com ([157.56.110.119]:45307
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751223AbaIRX3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:29:16 -0400
Message-ID: <1411082946.13320.29.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Scott Wood <scottwood@freescale.com>
To: Yoder Stuart-B08248 <stuart.yoder@freescale.com>
CC: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>,
        Alexander Graf <agraf@suse.de>,
        Rivera Jose-B46482 <German.Rivera@freescale.com>,
        <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 18 Sep 2014 18:29:06 -0500
In-Reply-To: <581cd5a2ba854ef883ba488cec70ad62@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
	 <541A5CF1.8000409@freescale.com>
	 <C6468126-D7AF-4144-992A-311C642CAD7F@suse.de>
	 <20140918152233.41647ee517393816bb35b72a@freescale.com>
	 <581cd5a2ba854ef883ba488cec70ad62@CY1PR0301MB0748.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:9d2d:42ec:ad0e:7ffa]
X-ClientProxiedBy: DM2PR04CA032.namprd04.prod.outlook.com (10.141.154.150) To
 CY1PR0301MB0729.namprd03.prod.outlook.com (25.160.159.147)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(377454003)(13464003)(377424004)(479174003)(189002)(199003)(50466002)(21056001)(50226001)(79102003)(81542003)(46102003)(77982003)(83322001)(19580395003)(81342003)(77096002)(62966002)(80022003)(95666004)(74662003)(74502003)(19580405001)(42186005)(23676002)(87286001)(93886004)(85306004)(77156001)(4396001)(31966008)(90102001)(107046002)(110136001)(64706001)(97736003)(103116003)(101416001)(106356001)(33646002)(99396002)(105586002)(20776003)(47776003)(92726001)(85852003)(88136002)(87976001)(86362001)(92566001)(89996001)(104166001)(83072002)(93916002)(76482002)(50986999)(76176999)(102836001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0729;H:[IPv6:2601:2:5800:3f7:9d2d:42ec:ad0e:7ffa];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-18 at 18:13 -0500, Yoder Stuart-B08248 wrote:
> 
> > -----Original Message-----
> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Thursday, September 18, 2014 3:23 PM
> > To: Alexander Graf
> > Cc: Rivera Jose-B46482; <gregkh@linuxfoundation.org>; <arnd@arndb.de>; <linux-kernel@vger.kernel.org>; Yoder
> > Stuart-B08248; Wood Scott-B07421; <linuxppc-release@linux.freescale.net>
> > Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> > 
> > On Thu, 18 Sep 2014 15:14:03 +0200
> > Alexander Graf <agraf@suse.de> wrote:
> > 
> > > > Am 18.09.2014 um 06:17 schrieb German Rivera <German.Rivera@freescale.com>:
> > > >
> > > >> On 09/15/2014 06:44 PM, Kim Phillips wrote:
> > > >> On Thu, 11 Sep 2014 12:34:21 -0500
> > > >> "J. German Rivera" <German.Rivera@freescale.com> wrote:
> > > >>
> > > >>> From: "J. German Rivera" <German.Rivera@freescale.com>
> > > >>>
> > > >>> APIs to access the Management Complex (MC) hardware
> > > >>> module of Freescale LS2 SoCs. This patch includes
> > > >>> APIs to check the MC firmware version and to manipulate
> > > >>> DPRC objects in the MC.
> > > >>>
> > > >>> Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> > > >>> Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> > > >>> ---
> > > >>>  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
> > > >>>  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
> > > >>>  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
> > > >>>  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
> > > >>>  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
> > > >>>  include/linux/fsl_dpmng.h          |  120 ++++++
> > > >>>  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
> > > >>>  include/linux/fsl_mc_cmd.h         |  182 +++++++++
> > > >>>  include/linux/fsl_mc_sys.h         |   81 ++++
> > > >>>  9 files changed, 2635 insertions(+)
> > > >>>  create mode 100644 drivers/bus/fsl-mc/dpmng.c
> > > >>>  create mode 100644 drivers/bus/fsl-mc/dprc.c
> > > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
> > > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
> > > >>>  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
> > > >>>  create mode 100644 include/linux/fsl_dpmng.h
> > > >>>  create mode 100644 include/linux/fsl_dprc.h
> > > >>>  create mode 100644 include/linux/fsl_mc_cmd.h
> > > >>>  create mode 100644 include/linux/fsl_mc_sys.h
> > > >>
> > > >> the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
> > > >> its directory name fsl-mc/.  Note that I find dashes ('-') in
> > > >> filenames make them easier to type: is there a reason we're using
> > > >> underscores here?
> > > > This is a convention that we decided early on '-' for directory names
> > > > and '_' for file names.
> > 
> > based on what?
> 
> We looked at how generally files were named in kernel source.
> 
> For what it's worth in my 3.16 branch:
> 
> $ find drivers/ -type f | grep '-' | wc -l
> 4308
> $ find drivers/ -type f | grep '_' | wc -l
> 6507
> 
> ...it seems that there are far more files named with underscores.  If Greg
> or Arnd wants the files renamed, fine, but other than that I see no reason
> to change this.

60% isn't "far more".  Regardless of whether we change this (dashes are
easier to read, easier to type, and are what English normally uses --
underscores are for when you can't use a dash for technical reasons),
let's not start making rules based on weak statistical inferences.

Plus, why limit the search to drivers?  E.g. if you looked at arch/
you'd reach the opposite conclusion.

-Scott


