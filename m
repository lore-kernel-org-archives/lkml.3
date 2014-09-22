Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaIVWYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:24:13 -0400
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:32465
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754684AbaIVWYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:24:11 -0400
X-Greylist: delayed 947 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 18:24:11 EDT
Date: Mon, 22 Sep 2014 17:03:07 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Yoder Stuart-B08248 <stuart.yoder@freescale.com>
CC: Rivera Jose-B46482 <German.Rivera@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wood Scott-B07421 <scottwood@freescale.com>,
        "agraf@suse.de" <agraf@suse.de>,
        "linuxppc-release@linux.freescale.net" 
	<linuxppc-release@linux.freescale.net>
Subject: Re: [PATCH 0/3 v2] drivers/bus: Freescale Management Complex bus
 driver patch series
Message-ID: <20140922170307.fdcbfb495695c03833ff6c53@freescale.com>
In-Reply-To: <0e13cde24a284873ab6f65f7e5ffdb3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
References: <1411166981-3610-1-git-send-email-German.Rivera@freescale.com>
	<20140922115328.7d6fa30635ed52de425f9ebc@freescale.com>
	<0e13cde24a284873ab6f65f7e5ffdb3e@CY1PR0301MB0748.namprd03.prod.outlook.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(377454003)(189002)(24454002)(87936001)(19580405001)(6806004)(4396001)(93916002)(46406003)(105606002)(68736004)(76176999)(120916001)(90102001)(81156004)(62966002)(23726002)(86362001)(104166001)(77982003)(87286001)(69596002)(92726001)(83072002)(83322001)(44976005)(89996001)(74502003)(84676001)(36756003)(77156001)(26826002)(19580395003)(85852003)(106466001)(47776003)(21056001)(81542003)(76482002)(85306004)(50466002)(104016003)(31966008)(92566001)(80022003)(97736003)(100306002)(50226001)(79102003)(50986999)(110136001)(64706001)(46102003)(20776003)(74662003)(95666004)(88136002)(107046002)(33646002)(81342003)(102836001)(99396002)(10300001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB331;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 034215E98F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 12:59:21 -0500
Yoder Stuart-B08248 <stuart.yoder@freescale.com> wrote:

> > From: Kim Phillips [mailto:kim.phillips@freescale.com]
> > Sent: Monday, September 22, 2014 11:53 AM
> > 
> > On Fri, 19 Sep 2014 17:49:38 -0500
> > "J. German Rivera" <German.Rivera@freescale.com> wrote:
> > 
> > > CHANGE HISTORY
> > >
> > > Issues pending resolution not addressed by v2:
> > > - What to do with Doxygen comments in patch 1
> > 
> > It's clear they should be removed.
> > 
> > > - Whether to move or not FSL-specific header files added in include/linux,
> > >   by this patch series, to another location
> > 
> > there wasn't a valid objection against moving them under fsl/ and
> > changing them to use dashes instead of underscores, was there?
> 
> There was no objection, but here is the observation.  The current
> convention seems to be that under include/linux are 'subsystem'
> types--
>    include/linux/mmc
>    include/linux/spi
>    include/linux/raid
>     etc
> 
> There is no other "company" that has an include/linux/[company-name] that I can
> see.  Freescale seems to be the only one.   And there is only a single driver
> in there.  So it looks like a complete anomaly.
> 
> Why is that?
> 
> I guess we could try moving our stuff to incluce/linux/fsl and see if there is
> any negative feedback on it.

these two commits:

commit 9a32299 "powerpc, dma: move bestcomm driver from
arch/powerpc/sysdev to drivers/dma"

commit 3946860 "mxs-dma : move the mxs dma.h to a more common place"

create/update files in include/linux/fsl for the same reason as this
patchseries wants, i.e., in order to support multiple drivers
including the files, and in an arch- (and mach-) independent manner.

hth,

Kim
