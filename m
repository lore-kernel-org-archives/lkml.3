Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaA0Vs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:48:29 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.91]:52893 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717AbaA0Vs0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:48:26 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
Thread-Topic: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
Thread-Index: AQHPDYLf/ncyAhKSa0a/KsTaDpfeiJqFW9eAgAjb6ECAAIw/AIAKckiQ
Date: Mon, 27 Jan 2014 21:47:43 +0000
Message-ID: <0671791e2ca8487a86a551eadf2e2bcd@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1389306287-20057-1-git-send-email-haiyangz@microsoft.com>
 <20140114.143133.1863157816134006560.davem@davemloft.net>
 <5f60b6bd1ea84eadbb730c7ea9d3d4d5@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <18b9150b090043b7b296593af994f8ee@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <18b9150b090043b7b296593af994f8ee@BY2PR03MB299.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(377454003)(164054003)(13464003)(199002)(189002)(90146001)(83072002)(85852003)(56816005)(92566001)(46102001)(69226001)(2656002)(85326001)(85306002)(74662001)(31966008)(44976005)(74502001)(19580395003)(83322001)(19580405001)(87936001)(47446002)(6806004)(54356001)(53806001)(23726002)(51856001)(65816001)(81342001)(66066001)(80022001)(33646001)(87266001)(46406003)(81542001)(76786001)(74366001)(59766001)(80976001)(93136001)(77982001)(76796001)(50466002)(54316002)(56776001)(76482001)(93886001)(94316002)(74706001)(47976001)(4396001)(50986001)(47736001)(93516002)(49866001)(81816001)(81686001)(47776003)(20776003)(63696002)(1511001)(74876001)(79102001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:ACD2F8DE.AFF25886.B1F35928.8AE02971.20347;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0104247462
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: KY Srinivasan
> Sent: Monday, January 20, 2014 5:11 PM
> To: Haiyang Zhang; David Miller
> Cc: netdev@vger.kernel.org; olaf@aepfle.de; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org
> Subject: RE: [PATCH net-next] hyperv: Add support for physically discontinuous
> receive buffer
> 
> 
> 
> > -----Original Message-----
> > From: Haiyang Zhang
> > Sent: Monday, January 20, 2014 2:06 PM
> > To: David Miller
> > Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> > jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> > devel@linuxdriverproject.org
> > Subject: RE: [PATCH net-next] hyperv: Add support for physically
> > discontinuous receive buffer
> >
> >
> >
> > > -----Original Message-----
> > > From: David Miller [mailto:davem@davemloft.net]
> > > Sent: Tuesday, January 14, 2014 5:32 PM
> > > To: Haiyang Zhang
> > > Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> > > jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> > > devel@linuxdriverproject.org
> > > Subject: Re: [PATCH net-next] hyperv: Add support for physically
> > > discontinuous receive buffer
> > >
> > > From: Haiyang Zhang <haiyangz@microsoft.com>
> > > Date: Thu,  9 Jan 2014 14:24:47 -0800
> > >
> > > > This will allow us to use bigger receive buffer, and prevent
> > > > allocation failure due to fragmented memory.
> > > >
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > >
> > > Not until you start using paged SKBs in netvsc_recv_callback.
> > >
> > > Whatever fragmention you think you're avoiding in the hyperv layer,
> > > you're still going to get from the:
> > >
> > > skb = netdev_alloc_skb_ip_align(net, packet->total_data_buflen);
> > >
> > > call there.
> > >
> > > This change makes no sense in isolation, therefore I'm not applying
> > > it until you also include the appropriate changes to avoid the same
> > > exact fragmentation issue in netvsc_drv.c as stated above.
> >
> > The receive buffer currently requires multiple MB of physically
> > continuous memory, and may fail to be allocated when memory is
> > fragmented. The patch is created for this issue.
> >
> > The SKB buffer is usually less than 1500 bytes or up to several KB
> > with jumbo frame, so it's much less sensitive to fragmented memory. I
> > will work on another patch to use SKB buffer with discontinuous pages.
> >
> > Could you accept this patch separately?
> 
> Today, if we try to unload and load the network driver, the load may fail
> because we may not be able to allocate the receive buffers if memory is
> fragmented. This patch specifically addresses this problem.
> 
> Regards,
> 
> K. Y

Dave,

So, could this patch be taken first?

Thanks,
- Haiyang

