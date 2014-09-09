Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaIILCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:02:33 -0400
Received: from mail-bn1bon0062.outbound.protection.outlook.com ([157.56.111.62]:12721
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752295AbaIILCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:02:30 -0400
X-Greylist: delayed 3657 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 07:02:29 EDT
Date: Tue, 9 Sep 2014 11:26:53 +0200
From: Robert Richter <robert.richter@caviumnetworks.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Robert Richter <rric@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] GICv3: Fixing 32 bit compatibility
Message-ID: <20140909092653.GC4588@rric.localhost>
References: <1410185480-5153-1-git-send-email-rric@kernel.org>
 <20140909080042.GO23009@pengutronix.de>
 <20140909091201.GA4527@rric.localhost>
 <20140909091912.GQ23009@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140909091912.GQ23009@pengutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [92.224.193.215]
X-ClientProxiedBy: DB4PR07CA010.eurprd07.prod.outlook.com (10.242.229.20) To
 DM2PR0701MB811.namprd07.prod.outlook.com (10.242.127.25)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009018)(6069001)(6009001)(189002)(24454002)(199003)(51704005)(87976001)(77096002)(85852003)(83072002)(31966008)(74502001)(76176999)(54356999)(101416001)(42186005)(83322001)(81542001)(66066001)(20776003)(86362001)(97736003)(83506001)(50466002)(47776003)(76482001)(92566001)(99396002)(81342001)(64706001)(92726001)(102836001)(74662001)(95666004)(4396001)(93886004)(21056001)(50986999)(23756003)(110136001)(76506005)(85306004)(90102001)(46102001)(80022001)(33656002)(105586002)(77982001)(79102001)(107046002)(106356001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0701MB811;H:rric.localhost;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09.09.14 11:19:12, Uwe Kleine-König wrote:
> On Tue, Sep 09, 2014 at 11:12:01AM +0200, Robert Richter wrote:
> > On 09.09.14 10:00:42, Uwe Kleine-König wrote:
> > > On Mon, Sep 08, 2014 at 04:11:19PM +0200, Robert Richter wrote:
> > 
> > > > @@ -479,7 +479,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
> > > >     smp_wmb();
> > > >  
> > > >     for_each_cpu_mask(cpu, *mask) {
> > > > -           u64 cluster_id = cpu_logical_map(cpu) & ~0xffUL;
> > > > +           u64 cluster_id = cpu_logical_map(cpu) & ~0xffULL;
> > > This doesn't change anything, does it?
> > 
> > It does, not in 64 bit but in 32 bit there unsigned long is 32
> > bit. So, bit masks are broken if you compile a 32 bit kernel.
> Can you make an example where the result actually changes?

Upper 32 bits will be cleared above.

> > > I wonder if it would be cleaner to use (u64)0xff here.
> > 
> > No, that's ULL for. This is commonly used in x86 too.
> I don't care much here, but I'd say ULL is to force an unsigned long
> long. If you want to make it obvious that you want a 64bit value, a cast
> to u64 makes this more clear.

ULL is no cast at all.

-Robert
