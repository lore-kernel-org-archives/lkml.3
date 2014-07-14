Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbaGNWk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:40:27 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.26]:39124 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756749AbaGNWkW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:40:22 -0400
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
Thread-Index: AQHPmVd2lonpWupwu0Spl7Lqc9fFbZuU0/7ggACNCICABXpggIAAJvuQgAWV9wD//5q4EA==
Date: Mon, 14 Jul 2014 22:39:48 +0000
Message-ID: <8b68f48141a045f784c10f9c081cd51f@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20140706201800.GA10587@sucs.org>
 <941b0055b1a94c66b3a608ae67764d11@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140707181341.GA2646@sucs.org> <20140711055259.GA10317@sucs.org>
 <52afbe119b1a481aa1c80f909c3a2432@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140714213032.GA23639@sucs.org>
In-Reply-To: <20140714213032.GA23639@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(164054003)(377454003)(199002)(189002)(24454002)(51704005)(51914003)(13464003)(50466002)(46406003)(74502001)(68736004)(97736001)(92566001)(19580395003)(79102001)(6806004)(2656002)(21056001)(81342001)(2009001)(97756001)(4396001)(93886003)(80022001)(81542001)(74662001)(66066001)(44976005)(20776003)(47776003)(84676001)(46102001)(33646001)(77096999)(54356999)(76176999)(106466001)(106116001)(50986999)(110136001)(76482001)(85852003)(31966008)(64706001)(77982001)(83322001)(19580405001)(83072002)(99396002)(1411001)(87936001)(86612001)(107046002)(23726002)(108616002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB599;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Monday, July 14, 2014 5:31 PM
> To: Haiyang Zhang
> Cc: KY Srinivasan; David S. Miller; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [BISECTED][REGRESSION] Loading Hyper-V network drivers is
> racy in 3.14+ on Hyper-V 2012 R2
> 
> On Fri, Jul 11, 2014 at 03:25:11PM +0000, Haiyang Zhang wrote:
> > Since you found the commit b679ef73edc is related to this problem,
> > could you do a simple test:
> >   Reduce the receive buffer size back to 2MB, like below, then re-test
> >   it, see if the problem goes away?
> > 	drivers/net/hyperv/hyperv_net.h
> > 	#define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024*2)	/* 2MB
> */
> 
> After doing this I was able to reach over 900 reboots where the network
> connected properly.

Thanks for the tests! I will make a patch that can automatically retry
smaller memory allocs when memory is insufficient.

Thanks,
- Haiyang

