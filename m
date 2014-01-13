Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaAMUKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:10:38 -0500
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:50637
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751534AbaAMUKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:10:36 -0500
Message-ID: <1389643828.24905.80.camel@snotra.buserror.net>
Subject: Re: [PATCH] Driver/IFC: Move Freescale IFC driver to a common driver
From: Scott Wood <scottwood@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Prabhakar Kushwaha <prabhakar@freescale.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jan 2014 14:10:28 -0600
In-Reply-To: <201401132045.44063.arnd@arndb.de>
References: <1389590671-20289-1-git-send-email-prabhakar@freescale.com>
	 <201401131432.36880.arnd@arndb.de>
	 <1389638849.24905.51.camel@snotra.buserror.net>
	 <201401132045.44063.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR04CA009.namprd04.prod.outlook.com (10.255.197.19) To
 BY2PR03MB396.namprd03.prod.outlook.com (10.141.141.26)
X-Forefront-PRVS: 00909363D5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(51704005)(189002)(199002)(377424004)(24454002)(50466002)(89996001)(74706001)(47736001)(50226001)(49866001)(59766001)(4396001)(74876001)(80976001)(83072002)(19580405001)(83322001)(92566001)(56816005)(81542001)(62966002)(92726001)(90146001)(81816001)(77156001)(77096001)(47976001)(76786001)(85306002)(33646001)(54316002)(79102001)(53806001)(51856001)(46102001)(74366001)(23676002)(87976001)(65816001)(80022001)(87286001)(42186004)(50986001)(85852003)(19580395003)(88136002)(81342001)(69226001)(76796001)(77982001)(74502001)(56776001)(47446002)(87266001)(74662001)(81686001)(93136001)(31966008)(63696002)(76482001)(47776003)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB396;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 20:45 +0100, Arnd Bergmann wrote:
> On Monday 13 January 2014, Scott Wood wrote:
> > On Mon, 2014-01-13 at 14:32 +0100, Arnd Bergmann wrote:
> > > On Monday 13 January 2014, Prabhakar Kushwaha wrote:
> > > > Freescale IFC controller has been used for mpc8xxx. It will be used
> > > > for ARM-based SoC as well. This patch moves the driver to driver/misc
> > > > and fix the header file includes.
> > > > 
> > > > Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
> > > 
> > > No objections to the driver, but drivers/misc doesn't seem like the
> > > right place. Why not drivers/mfd or drivers/memory?
> > 
> > It's not a memory controller in the sense that I think most people would
> > interpret the phrase, but I guess it's similar in function to
> > mvebu-devbus.  If drivers/memory is broad enough to cover such things,
> > and doesn't have a memory controller subsystem that drivers are supposed
> > to register with, then that could work.
> > 
> > Are things in drivers/mfd expected to interact with mfd-core.c?  It's
> > not clear to me what that does or how it would be useful to the IFC
> > code.
> 
> Sorry, I meant mtd not mfd. mtd would make sense if the only devices
> behind it are things like flash or sram memory.

Some of the things behind it are flash, but those portions of the driver
are already in drivers/mtd.  This is just the common code.

-Scott


