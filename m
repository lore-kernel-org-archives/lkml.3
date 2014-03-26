Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbaCZMbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:31:38 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:42474 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbaCZMbg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:31:36 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: David Miller <davem@davemloft.net>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Index: AQHPRT7oyWtXlru1UE29zpPCw7NDQZrySCzQgAC7j4CAAAEMAP//tHbwgAB+hICAABn2kA==
Date: Wed, 26 Mar 2014 12:31:24 +0000
Message-ID: <c7fe8f6655564fcf924521d01d3fa95a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1395434633-16771-1-git-send-email-haiyangz@microsoft.com>
 <216cd74854414cfc9b338cab41a3d1a0@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140325.204343.991901655152875043.davem@davemloft.net>
 <20140325.204728.2281772666453524010.davem@davemloft.net>
 <a8b374e420be42d883fb782c8f271659@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140326034955.GA10875@kroah.com>
In-Reply-To: <20140326034955.GA10875@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(100?=
 =?us-ascii?Q?09001)(51704005)(24454002)(13464003)(189002)(377454003)(3774?=
 =?us-ascii?Q?24004)(199002)(164054003)(81342001)(19580405001)(44976005)(9?=
 =?us-ascii?Q?8676001)(80976001)(81686001)(2656002)(19580395003)(83322001)?=
 =?us-ascii?Q?(87266001)(87936001)(81816001)(15975445006)(85306002)(474460?=
 =?us-ascii?Q?02)(74502001)(31966008)(94946001)(50466002)(86612001)(746620?=
 =?us-ascii?Q?01)(66066001)(80022001)(81542001)(74876001)(69226001)(925660?=
 =?us-ascii?Q?01)(46102001)(56816005)(90146001)(33646001)(97186001)(518560?=
 =?us-ascii?Q?01)(54316002)(93516002)(76786001)(76796001)(56776001)(477360?=
 =?us-ascii?Q?01)(47976001)(50986001)(83072002)(85852003)(4396001)(5380600?=
 =?us-ascii?Q?1)(65816001)(95416001)(94316002)(95666003)(59766001)(7798200?=
 =?us-ascii?Q?1)(575784001)(93886001)(76482001)(54356001)(84676001)(977560?=
 =?us-ascii?Q?01)(47776003)(74366001)(63696002)(79102001)(74706001)(237260?=
 =?us-ascii?Q?02)(15202345003)(6806004)(97336001)(2009001)(49866001)(46406?=
 =?us-ascii?Q?003)(20776003)(97736001)(93136001)(142933001)(24736002);DIR:?=
 =?us-ascii?Q?OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.micro?=
 =?us-ascii?Q?soft.com;FPR:3474F196.AF2931A.B3FF57A3.92E5D8D2.20471;PTR:In?=
 =?us-ascii?Q?foDomainNonexistent;MX:1;A:1;LANG:en;?=
X-Exchange-Organization-AntiSpam-Internal: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 0162ACCC24
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Tuesday, March 25, 2014 11:50 PM
> To: Haiyang Zhang
> Cc: David Miller; olaf@aepfle.de; netdev@vger.kernel.org;
> jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive
> Side Scaling (vRSS)
> 
> On Wed, Mar 26, 2014 at 03:23:47AM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: David Miller [mailto:davem@davemloft.net]
> > > Sent: Tuesday, March 25, 2014 8:47 PM
> > > To: Haiyang Zhang
> > > Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> > > jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> > > devel@linuxdriverproject.org
> > > Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual
> Receive
> > > Side Scaling (vRSS)
> > >
> > > From: David Miller <davem@davemloft.net>
> > > Date: Tue, 25 Mar 2014 20:43:43 -0400 (EDT)
> > >
> > > > From: Haiyang Zhang <haiyangz@microsoft.com>
> > > > Date: Tue, 25 Mar 2014 20:37:43 +0000
> > > >
> > > >> Do we know when the dependency (commit: 8a7206a89f) will be
> merged
> > > >> into net-next tree?
> > > >
> > > > You're really not very patient, to say the least.
> > > >
> > > > It's done now and I'm working to integrate your patch.
> > > >
> > > > That patch has been in under review state in patchwork, which
> means
> > > > that I will get to it at some point, so you don't need to worry
> about
> > > > it any more than any other patch you might submit.
> > > >
> > > > The whole reason patchwork exists is so that people don't have to
> > > > ask.
> > >
> > > And actually, this dependency "8a7206a89f" commit doesn't exist
> > > in the 'net' tree at all.  I just merged Linus's tree into 'net'
> > > and it doesn't exist there either.
> > >
> > > So this patch still doesn't compile.
> > >
> > > I'm tossing it from patchwork until you sort this out.
> >
> > Dave,
> >
> > Thank you for the efforts.
> > The commit is in the linux-next tree. You can see it from this link:
> > http://git.kernel.org/cgit/linux/kernel/git/next/linux-
> next.git/commit/?id=8a7206a89f85c8439561b0eff85bb9440a2e97a9
> > And, here is the commit log:
> >
> > author
> > K. Y. Srinivasan <kys@microsoft.com> 2014-02-03 20:42:45 (GMT)
> > committer
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> 2014-02-07 23:22:40
> (GMT)
> > commit
> > 8a7206a89f85c8439561b0eff85bb9440a2e97a9 (patch)
> > tree
> > 61f763919607368481ac128f56416df1f49cd187
> > parent
> > 011a7c3cc3aa60c7ea6bb49d847e80a299ba7b36 (diff)
> >
> > Drivers: hv: vmbus: Support per-channel driver state
> > As we implement Virtual Receive Side Scaling on the networking side
> > (the VRSS patches are currently under review), it will be useful to
> have
> > per-channel state that vmbus drivers can manage. Add support for
> > managing per-channel state.
> >
> > KY:
> > Do you know the original tree this patch was checked into by Greg KH?
> Or,
> > did Greg checked into linux-next tree directly?
> 
> No one "checks into the linux-next tree directly".
> 
> So your patch relies on a patch in my char-misc tree?  Ick, that wasn't
> very wise.
> 
> It will just have to wait until the patch goes into 3.15-rc1, as my
> trees are closed, sorry.

Greg,

Thank you for the info. We will wait until KY's earlier patch is merged into
3.15rc1.

In the future, the changes for vmbus or common header used by netvsc driver
should be submitted into net-next tree, correct? So, it can be available quickly
for the subsequent features?

Thanks,
- Haiyang

