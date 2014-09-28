Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaI1Jw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:52:57 -0400
Received: from [157.56.110.105] ([157.56.110.105]:46936 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750818AbaI1Jwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:52:55 -0400
X-Greylist: delayed 167290 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2014 05:52:55 EDT
Date: Sun, 28 Sep 2014 17:53:16 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <kernel@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <Zhuoyu.Zhang@freescale.com>, <Jason.Jin@freescale.com>,
        <leoli@freescale.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] pm: add FSM configuration for deep sleep
Message-ID: <20140928095316.GA9797@udp189498uds.ap.freescale.net>
References: <1411730703-25836-1-git-send-email-chenhui.zhao@freescale.com>
 <1411730703-25836-3-git-send-email-chenhui.zhao@freescale.com>
 <20140926120201.GN5182@n2100.arm.linux.org.uk>
 <20140926205153.GY5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140926205153.GY5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(189002)(199003)(76176999)(83506001)(50986999)(85306004)(57986006)(54356999)(31966008)(44976005)(83322001)(6806004)(68736004)(93886004)(76482002)(92726001)(86362001)(92566001)(107046002)(97756001)(97736003)(110136001)(104016003)(90102001)(106466001)(105606002)(95666004)(10300001)(99396003)(120916001)(80022003)(81342003)(79102003)(81542003)(74502003)(74662003)(76506005)(77982003)(46102003)(50466002)(26826002)(102836001)(84676001)(33656002)(23726002)(21056001)(85852003)(87936001)(83072002)(46406003)(64706001)(20776003)(4396001)(47776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0727;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0727;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=chenhui.zhao@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 09:51:53PM +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 26, 2014 at 01:02:01PM +0100, Russell King - ARM Linux wrote:
> > On Fri, Sep 26, 2014 at 07:25:02PM +0800, Chenhui Zhao wrote:
> > > +void fsm_write32(void __iomem *addr, u32 val)
> > > +{
> > > +#ifdef __arm__
> > > +	iowrite32be(val, addr);
> > > +#endif
> > > +
> > > +#ifdef __powerpc__
> > > +	out_be32(addr, val);
> > > +#endif
> > 
> > The idea of iowrite* is that it should be able to address MMIO or IO
> > memory irrespective of the platform.  Why is PowerPC not implementing
> > this accessor, or why can't it be used for PowerPC?
> > 
> > This should just use iowrite32be(), and if it doesn't work on PowerPC,
> > PowerPC needs to be fixed.
> 
> BenH tells me that this should be able to use iowrite32be() on PowerPC
> too without problems, there should be no need to use the older out_be32()
> accessors here.  Please can you look into using only iowrite32be() here?
> 
> Thanks.
> 

Thanks. I'll fix it.

Chenhui
