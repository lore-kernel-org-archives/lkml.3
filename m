Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaE2SnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 14:43:09 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:8350
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbaE2SnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 14:43:07 -0400
Message-ID: <1401388979.6603.165.camel@snotra.buserror.net>
Subject: Re: [PATCH] pcmcia: m8xx: remove checks for four macros
From: Scott Wood <scottwood@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-pcmcia@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 29 May 2014 13:42:59 -0500
In-Reply-To: <1401388744.25908.16.camel@x220>
References: <1400916970.31526.78.camel@x220>
	 <1401387624.6603.161.camel@snotra.buserror.net>
	 <1401388744.25908.16.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:d1b9:9316:96e:1a3c]
X-ClientProxiedBy: BLUPR08CA0057.namprd08.prod.outlook.com (10.141.200.37) To
 BL2PR03MB387.namprd03.prod.outlook.com (10.141.91.152)
X-Forefront-PRVS: 022649CC2C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(428001)(199002)(189002)(24454002)(377424004)(51704005)(31966008)(74662001)(99396002)(76176999)(87286001)(50986999)(50226001)(88136002)(104166001)(19580405001)(74502001)(83322001)(86362001)(62966002)(4396001)(87976001)(77156001)(21056001)(101416001)(23676002)(102836001)(85852003)(81542001)(92566001)(20776003)(46102001)(92726001)(76482001)(42186004)(93916002)(89996001)(50466002)(80022001)(64706001)(19580395003)(77982001)(79102001)(33646001)(83072002)(81342001)(103116003)(47776003)(32563001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB387;H:[IPv6:2601:2:5800:3f7:d1b9:9316:96e:1a3c];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-29 at 20:39 +0200, Paul Bolle wrote:
> On Thu, 2014-05-29 at 13:20 -0500, Scott Wood wrote:
> > On Sat, 2014-05-24 at 09:36 +0200, Paul Bolle wrote:
> > > This driver contains checks for four Kconfig macros. But the related
> > > Kconfig symbols have never been part of the tree. Remove these checks
> > > and the code they hide.
> > > 
> > > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > > ---
> > > Untested.
> > > 
> > > This has been an issue ever since this driver was added in v2.6.15. Note
> > > that there is no header named "*/cpld.h", so setting PRxK can't possibly
> > > work.
> > > 
> > >  drivers/pcmcia/m8xx_pcmcia.c | 75 --------------------------------------------
> > >  1 file changed, 75 deletions(-)
> > 
> > Does anything in this driver still work?  It looks like bitrot from the
> > arch/ppc days, that sort of got updated to use the device tree -- but
> > even after this patch there are lots of instances of CONFIG symbols
> > being used to assert the exact hardware being used, rather than what
> > hardware is supported.
> 
> I'm not sure I get what you're pointing at. Can you give one example?

All the various stuff enabled by CONFIG_FADS, CONFIG_MPC885ADS, etc.
such as the voltage_set() implementation.

-Scott


