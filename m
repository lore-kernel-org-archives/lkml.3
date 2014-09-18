Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaIRXxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:53:43 -0400
Received: from mail-bl2on0126.outbound.protection.outlook.com ([65.55.169.126]:12208
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbaIRXxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:53:41 -0400
Message-ID: <1411084409.13320.40.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
From: Scott Wood <scottwood@freescale.com>
To: Yoder Stuart-B08248 <stuart.yoder@freescale.com>
CC: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>,
        Rivera Jose-B46482 <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "agraf@suse.de" <agraf@suse.de>,
        "linuxppc-release@linux.freescale.net" 
	<linuxppc-release@linux.freescale.net>
Date: Thu, 18 Sep 2014 18:53:29 -0500
In-Reply-To: <4abacb49a6724879b6b2f4ed03890ad1@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
	 <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
	 <20140915184451.962a3a19c4940792d182f10a@freescale.com>
	 <4abacb49a6724879b6b2f4ed03890ad1@CY1PR0301MB0748.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:9d2d:42ec:ad0e:7ffa]
X-ClientProxiedBy: CO1PR06CA029.namprd06.prod.outlook.com (10.242.160.19) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(377424004)(13464003)(51704005)(189002)(377454003)(199003)(90102001)(99396002)(47776003)(20776003)(87976001)(87286001)(50986999)(76176999)(62966002)(21056001)(97736003)(42186005)(77096002)(106356001)(95666004)(105586002)(76482002)(107046002)(104166001)(92726001)(92566001)(93916002)(86362001)(50466002)(46102003)(81542003)(77982003)(50226001)(4396001)(93886004)(79102003)(80022003)(74662003)(74502003)(23676002)(77156001)(81342003)(85306004)(83322001)(19580405001)(19580395003)(83072002)(85852003)(110136001)(64706001)(89996001)(33646002)(88136002)(102836001)(103116003)(31966008)(101416001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:9d2d:42ec:ad0e:7ffa];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-18 at 18:39 -0500, Yoder Stuart-B08248 wrote:
> 
> > -----Original Message-----
> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Monday, September 15, 2014 6:45 PM
> > To: Rivera Jose-B46482
> > Cc: gregkh@linuxfoundation.org; arnd@arndb.de; linux-kernel@vger.kernel.org; Yoder Stuart-B08248; Phillips
> > Kim-R1AAHA; Wood Scott-B07421; agraf@suse.de; linuxppc-release@linux.freescale.net
> > Subject: Re: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
> > 
> > On Thu, 11 Sep 2014 12:34:21 -0500
> > "J. German Rivera" <German.Rivera@freescale.com> wrote:
> > 
> > > From: "J. German Rivera" <German.Rivera@freescale.com>
> > >
> > > APIs to access the Management Complex (MC) hardware
> > > module of Freescale LS2 SoCs. This patch includes
> > > APIs to check the MC firmware version and to manipulate
> > > DPRC objects in the MC.
> > >
> > > Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
> > > Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
> > > ---
> > >  drivers/bus/fsl-mc/dpmng.c         |   93 +++++
> > >  drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
> > >  drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
> > >  drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
> > >  drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
> > >  include/linux/fsl_dpmng.h          |  120 ++++++
> > >  include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
> > >  include/linux/fsl_mc_cmd.h         |  182 +++++++++
> > >  include/linux/fsl_mc_sys.h         |   81 ++++
> > >  9 files changed, 2635 insertions(+)
> > >  create mode 100644 drivers/bus/fsl-mc/dpmng.c
> > >  create mode 100644 drivers/bus/fsl-mc/dprc.c
> > >  create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
> > >  create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
> > >  create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
> > >  create mode 100644 include/linux/fsl_dpmng.h
> > >  create mode 100644 include/linux/fsl_dprc.h
> > >  create mode 100644 include/linux/fsl_mc_cmd.h
> > >  create mode 100644 include/linux/fsl_mc_sys.h
> > 
> > the fsl prefix in the filename fsl_dpmng_cmd.h is redundant with
> > its directory name fsl-mc/.  Note that I find dashes ('-') in
> > filenames make them easier to type: is there a reason we're using
> > underscores here?
> > 
> > Also, any reason why these and future include files aren't being put
> > in include/linux/fsl/, so as to not pollute the top level
> > include/linux/?  That way, we can also remove the fsl- prefix from
> > those filenames, too..
> 
> There is nothing in include/linux/fsl except 1 driver from 2 years ago.
> Why is that?
> 
> I'd also prefer to see these headers is include/linux/fsl, but given that
> the directory is essentially unused it seemed that include/linux was more
> conventional.

I thought I saw some other patch dump some more things in there recently
-- maybe LS1 stuff?

-Scott


