Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaCZDYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:24:35 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.30]:43739 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307AbaCZDYX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:24:23 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Index: AQHPRT7oyWtXlru1UE29zpPCw7NDQZrySCzQgAC7j4CAAAEMAP//tHbw
Date: Wed, 26 Mar 2014 03:23:47 +0000
Message-ID: <a8b374e420be42d883fb782c8f271659@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1395434633-16771-1-git-send-email-haiyangz@microsoft.com>
	<216cd74854414cfc9b338cab41a3d1a0@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140325.204343.991901655152875043.davem@davemloft.net>
 <20140325.204728.2281772666453524010.davem@davemloft.net>
In-Reply-To: <20140325.204728.2281772666453524010.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: =?us-ascii?Q?CIP:131.107.159.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10?=
 =?us-ascii?Q?009001)(377454003)(199002)(189002)(51704005)(164054003)(3774?=
 =?us-ascii?Q?24004)(13464003)(94316002)(2009001)(97756001)(65816001)(5098?=
 =?us-ascii?Q?6001)(46406003)(97736001)(80022001)(66066001)(90146001)(5757?=
 =?us-ascii?Q?84001)(95416001)(74662001)(93886001)(51856001)(93516002)(949?=
 =?us-ascii?Q?46001)(85306002)(63696002)(23726002)(15975445006)(31966008)(?=
 =?us-ascii?Q?86612001)(95666003)(85852003)(83072002)(33646001)(80976001)(?=
 =?us-ascii?Q?4396001)(56816005)(81686001)(81816001)(97186001)(47776003)(8?=
 =?us-ascii?Q?4676001)(20776003)(47446002)(74502001)(15202345003)(93136001?=
 =?us-ascii?Q?)(19580395003)(19580405001)(54356001)(83322001)(53806001)(46?=
 =?us-ascii?Q?102001)(98676001)(76482001)(2656002)(47736001)(76796001)(767?=
 =?us-ascii?Q?86001)(81342001)(87936001)(74706001)(59766001)(77982001)(449?=
 =?us-ascii?Q?76005)(74366001)(79102001)(6806004)(81542001)(47976001)(6922?=
 =?us-ascii?Q?6001)(54316002)(50466002)(49866001)(56776001)(97336001)(9256?=
 =?us-ascii?Q?6001)(74876001)(87266001)(142933001)(24736002);DIR:OUT;SFP:1?=
 =?us-ascii?Q?101;SCL:1;SRVR:BL2SR01MB593;H:hybrid.exchange.microsoft.com;?=
 =?us-ascii?Q?FPR:3454F156.AF2935A.B3FF57A3.92E5C8BE.2039A;PTR:InfoDomainN?=
 =?us-ascii?Q?onexistent;A:1;MX:1;LANG:en;?=
X-Exchange-Organization-AntiSpam-Internal: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 0162ACCC24
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, March 25, 2014 8:47 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive
> Side Scaling (vRSS)
> 
> From: David Miller <davem@davemloft.net>
> Date: Tue, 25 Mar 2014 20:43:43 -0400 (EDT)
> 
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> > Date: Tue, 25 Mar 2014 20:37:43 +0000
> >
> >> Do we know when the dependency (commit: 8a7206a89f) will be merged
> >> into net-next tree?
> >
> > You're really not very patient, to say the least.
> >
> > It's done now and I'm working to integrate your patch.
> >
> > That patch has been in under review state in patchwork, which means
> > that I will get to it at some point, so you don't need to worry about
> > it any more than any other patch you might submit.
> >
> > The whole reason patchwork exists is so that people don't have to
> > ask.
> 
> And actually, this dependency "8a7206a89f" commit doesn't exist
> in the 'net' tree at all.  I just merged Linus's tree into 'net'
> and it doesn't exist there either.
> 
> So this patch still doesn't compile.
> 
> I'm tossing it from patchwork until you sort this out.

Dave,

Thank you for the efforts.
The commit is in the linux-next tree. You can see it from this link:
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=8a7206a89f85c8439561b0eff85bb9440a2e97a9
And, here is the commit log:

author
K. Y. Srinivasan <kys@microsoft.com> 2014-02-03 20:42:45 (GMT) 
committer
Greg Kroah-Hartman <gregkh@linuxfoundation.org> 2014-02-07 23:22:40 (GMT) 
commit
8a7206a89f85c8439561b0eff85bb9440a2e97a9 (patch) 
tree
61f763919607368481ac128f56416df1f49cd187 
parent
011a7c3cc3aa60c7ea6bb49d847e80a299ba7b36 (diff) 

Drivers: hv: vmbus: Support per-channel driver state
As we implement Virtual Receive Side Scaling on the networking side
(the VRSS patches are currently under review), it will be useful to have
per-channel state that vmbus drivers can manage. Add support for
managing per-channel state.

KY:
Do you know the original tree this patch was checked into by Greg KH? Or, 
did Greg checked into linux-next tree directly?

Thanks,
- Haiyang

