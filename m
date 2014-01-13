Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaAMVYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:24:34 -0500
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:13877
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbaAMVYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:24:30 -0500
Message-ID: <1389648261.24905.82.camel@snotra.buserror.net>
Subject: Re: [PATCH] Driver/IFC: Move Freescale IFC driver to a common driver
From: Scott Wood <scottwood@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Prabhakar Kushwaha <prabhakar@freescale.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jan 2014 15:24:21 -0600
In-Reply-To: <201401132222.12572.arnd@arndb.de>
References: <1389590671-20289-1-git-send-email-prabhakar@freescale.com>
	 <201401132045.44063.arnd@arndb.de>
	 <1389643828.24905.80.camel@snotra.buserror.net>
	 <201401132222.12572.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR06CA020.namprd06.prod.outlook.com (10.141.154.168)
 To BY2PR03MB396.namprd03.prod.outlook.com (10.141.141.26)
X-Forefront-PRVS: 00909363D5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(24454002)(51704005)(377424004)(189002)(199002)(65816001)(74366001)(23676002)(87976001)(85852003)(50986001)(19580395003)(80022001)(87286001)(42186004)(46102001)(54316002)(79102001)(53806001)(85306002)(33646001)(51856001)(81686001)(93136001)(87266001)(74662001)(76482001)(47776003)(31966008)(63696002)(69226001)(76796001)(81342001)(88136002)(74502001)(47446002)(56776001)(77982001)(80976001)(83072002)(83322001)(19580405001)(74706001)(50466002)(89996001)(47736001)(74876001)(59766001)(4396001)(49866001)(50226001)(77156001)(81816001)(47976001)(77096001)(76786001)(92566001)(56816005)(81542001)(62966002)(92726001)(90146001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB396;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 22:22 +0100, Arnd Bergmann wrote:
> On Monday 13 January 2014, Scott Wood wrote:
> > On Mon, 2014-01-13 at 20:45 +0100, Arnd Bergmann wrote:
> > > On Monday 13 January 2014, Scott Wood wrote:
> > > > On Mon, 2014-01-13 at 14:32 +0100, Arnd Bergmann wrote:
> > > > > On Monday 13 January 2014, Prabhakar Kushwaha wrote:
> > > > > > Freescale IFC controller has been used for mpc8xxx. It will be used
> > > > > > for ARM-based SoC as well. This patch moves the driver to driver/misc
> > > > > > and fix the header file includes.
> > > > > > 
> > > > > > Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
> > > > > 
> > > > > No objections to the driver, but drivers/misc doesn't seem like the
> > > > > right place. Why not drivers/mfd or drivers/memory?
> > > > 
> > > > It's not a memory controller in the sense that I think most people would
> > > > interpret the phrase, but I guess it's similar in function to
> > > > mvebu-devbus.  If drivers/memory is broad enough to cover such things,
> > > > and doesn't have a memory controller subsystem that drivers are supposed
> > > > to register with, then that could work.
> > > > 
> > > > Are things in drivers/mfd expected to interact with mfd-core.c?  It's
> > > > not clear to me what that does or how it would be useful to the IFC
> > > > code.
> > > 
> > > Sorry, I meant mtd not mfd. mtd would make sense if the only devices
> > > behind it are things like flash or sram memory.
> > 
> > Some of the things behind it are flash, but those portions of the driver
> > are already in drivers/mtd.  This is just the common code.
> > 
> 
> What are the things that are not flash then?

FPGAs or any other random things that might get connected to it on a
custom board.

-Scott


