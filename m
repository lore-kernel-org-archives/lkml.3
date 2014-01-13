Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaAMSrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:47:40 -0500
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:52246
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbaAMSrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:47:37 -0500
Message-ID: <1389638849.24905.51.camel@snotra.buserror.net>
Subject: Re: [PATCH] Driver/IFC: Move Freescale IFC driver to a common driver
From: Scott Wood <scottwood@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Prabhakar Kushwaha <prabhakar@freescale.com>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 13 Jan 2014 12:47:29 -0600
In-Reply-To: <201401131432.36880.arnd@arndb.de>
References: <1389590671-20289-1-git-send-email-prabhakar@freescale.com>
	 <201401131432.36880.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BL2PR01CA010.prod.exchangelabs.com (10.141.66.50) To
 DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 00909363D5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(377424004)(24454002)(51704005)(199002)(189002)(81686001)(33646001)(59766001)(54316002)(51856001)(46102001)(79102001)(42186004)(92566001)(77982001)(85306002)(80022001)(76482001)(81816001)(53806001)(65816001)(63696002)(93136001)(47776003)(85852003)(74366001)(83072002)(56776001)(74876001)(90146001)(87976001)(23676002)(50466002)(74706001)(76786001)(76796001)(87266001)(87286001)(77096001)(92726001)(50226001)(4396001)(50986001)(47736001)(49866001)(83322001)(89996001)(81542001)(56816005)(80976001)(69226001)(77156001)(62966002)(47976001)(19580395003)(74662001)(19580405001)(88136002)(47446002)(74502001)(81342001)(31966008)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:2601:2:5800:3f7:12bf:48ff:fe84:c9a0;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 14:32 +0100, Arnd Bergmann wrote:
> On Monday 13 January 2014, Prabhakar Kushwaha wrote:
> > Freescale IFC controller has been used for mpc8xxx. It will be used
> > for ARM-based SoC as well. This patch moves the driver to driver/misc
> > and fix the header file includes.
> > 
> > Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
> 
> No objections to the driver, but drivers/misc doesn't seem like the
> right place. Why not drivers/mfd or drivers/memory?

It's not a memory controller in the sense that I think most people would
interpret the phrase, but I guess it's similar in function to
mvebu-devbus.  If drivers/memory is broad enough to cover such things,
and doesn't have a memory controller subsystem that drivers are supposed
to register with, then that could work.

Are things in drivers/mfd expected to interact with mfd-core.c?  It's
not clear to me what that does or how it would be useful to the IFC
code.

-Scott


