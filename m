Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbaGRVrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:47:21 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.24]:49928 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbaGRVrT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:47:19 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>, "David S. Miller" <davem@davemloft.net>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [BISECTED][REGRESSION] Loading Hyper-V network drivers is racy
 in 3.14+ on Hyper-V 2012 R2
Thread-Topic: [BISECTED][REGRESSION] Loading Hyper-V network drivers is racy
 in 3.14+ on Hyper-V 2012 R2
Thread-Index: AQHPmVd2lonpWupwu0Spl7Lqc9fFbZuU0/7ggACNCICABXpggIAAJvuQgAWV9wD//5q4EIAA5T4AgAVQRhA=
Date: Fri, 18 Jul 2014 21:30:49 +0000
Message-ID: <e72aea6f4eab48e6851fdc4d32b89fa2@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20140706201800.GA10587@sucs.org>
 <941b0055b1a94c66b3a608ae67764d11@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140707181341.GA2646@sucs.org> <20140711055259.GA10317@sucs.org>
 <52afbe119b1a481aa1c80f909c3a2432@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140714213032.GA23639@sucs.org>
 <8b68f48141a045f784c10f9c081cd51f@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140715050832.GA28549@sucs.org>
In-Reply-To: <20140715050832.GA28549@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(24454002)(51704005)(164054003)(51914003)(377454003)(13464003)(199002)(189002)(87936001)(46406003)(107046002)(66066001)(99396002)(21056001)(4396001)(2009001)(84676001)(2656002)(74502001)(80022001)(31966008)(106116001)(97756001)(93886003)(97736001)(6806004)(86612001)(76176999)(54356999)(77982001)(106466001)(79102001)(44976005)(50986999)(77096999)(23726002)(46102001)(1411001)(64706001)(92566001)(81342001)(19580395003)(83322001)(20776003)(47776003)(81542001)(19580405001)(68736004)(76482001)(110136001)(85852003)(74662001)(50466002)(33646002)(83072002)(108616002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB598;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-Forefront-PRVS: 02760F0D1C
Authentication-Results: spf=pass (sender IP is 131.107.159.100)
 smtp.mailfrom=haiyangz@microsoft.com; 
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, July 15, 2014 1:09 AM
> To: Haiyang Zhang
> Cc: KY Srinivasan; David S. Miller; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [BISECTED][REGRESSION] Loading Hyper-V network drivers is
> racy in 3.14+ on Hyper-V 2012 R2
> 
> On Mon, Jul 14, 2014 at 10:39:48PM +0000, Haiyang Zhang wrote:
> > > -----Original Message-----
> > > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > > Sent: Monday, July 14, 2014 5:31 PM
> > > To: Haiyang Zhang
> > > Cc: KY Srinivasan; David S. Miller; devel@linuxdriverproject.org;
> linux-
> > > kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [BISECTED][REGRESSION] Loading Hyper-V network drivers
> is
> > > racy in 3.14+ on Hyper-V 2012 R2
> >
> > Thanks for the tests! I will make a patch that can automatically retry
> > smaller memory allocs when memory is insufficient.
> 
> This concerns me a bit - why would there be insufficient memory on a 64
> bit VM with 4 GBytes of RAM just after startup (presumably the host's
> memory isn't the issue)? Additionally, while things might fail just when
> things are starting up, doing ifup eth0 at some point later succeeds so
> whatever issue it had seems temporary.
> 
> Perhaps it would be wise to adding some debugging output to see if the
> allocation really failed and why...

Actually, there will be debug log in dmesg if the memory allocation fails. 
But it didn't show up in your dmesg. And since it can be recovered by 
"ifup eth0" later, the NIC must have been properly loaded (buffer alloc was 
successful but took a bit longer time). I think the larger receive-buffer 
size (16MB) may take longer time, because vzalloc() may sleep. And, that's 
why we don't see the bug with a small buffer size, because the allocation 
is quick.

Could you try put "LINKDELAY=60" into the this file?
	/etc/sysconfig/network-scripts/ifcfg-eth0
And see if the problem goes away?

Thanks,
- Haiyang

