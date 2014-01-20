Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaATWHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:07:33 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.88]:56094 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbaATWH3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:07:29 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
Thread-Topic: [PATCH net-next] hyperv: Add support for physically
 discontinuous receive buffer
Thread-Index: AQHPDYLf/ncyAhKSa0a/KsTaDpfeiJqFW9eAgAjb6EA=
Date: Mon, 20 Jan 2014 22:06:19 +0000
Message-ID: <5f60b6bd1ea84eadbb730c7ea9d3d4d5@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1389306287-20057-1-git-send-email-haiyangz@microsoft.com>
 <20140114.143133.1863157816134006560.davem@davemloft.net>
In-Reply-To: <20140114.143133.1863157816134006560.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(377454003)(51704005)(189002)(199002)(164054003)(74662001)(74502001)(47446002)(56816005)(53806001)(93136001)(63696002)(50466002)(20776003)(87266001)(93516002)(85852003)(81542001)(31966008)(83072002)(90146001)(81816001)(81342001)(81686001)(59766001)(69226001)(74366001)(74706001)(76786001)(76796001)(2656002)(79102001)(74876001)(87936001)(65816001)(80022001)(66066001)(47976001)(49866001)(47736001)(50986001)(92566001)(4396001)(80976001)(19580405001)(83322001)(44976005)(33646001)(56776001)(54356001)(76482001)(77982001)(46406003)(23726002)(54316002)(19580395003)(85306002)(46102001)(47776003)(6806004)(51856001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.99;FPR:AC5AF8DE.AFF25486.B1F35923.8AE02931.202D6;InfoDomainNonexistentMX:1;A:1;LANG:en;
X-Forefront-PRVS: 00979FCB3A
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, January 14, 2014 5:32 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add support for physically discontinuous
> receive buffer
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Thu,  9 Jan 2014 14:24:47 -0800
> 
> > This will allow us to use bigger receive buffer, and prevent
> > allocation failure due to fragmented memory.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Not until you start using paged SKBs in netvsc_recv_callback.
> 
> Whatever fragmention you think you're avoiding in the hyperv layer, you're still
> going to get from the:
> 
> 	skb = netdev_alloc_skb_ip_align(net, packet->total_data_buflen);
> 
> call there.
> 
> This change makes no sense in isolation, therefore I'm not applying it until you
> also include the appropriate changes to avoid the same exact fragmentation
> issue in netvsc_drv.c as stated above.

The receive buffer currently requires multiple MB of physically continuous memory,
and may fail to be allocated when memory is fragmented. The patch is created for
this issue.

The SKB buffer is usually less than 1500 bytes or up to several KB with jumbo frame, 
so it's much less sensitive to fragmented memory. I will work on another patch to use 
SKB buffer with discontinuous pages. 

Could you accept this patch separately?

Thanks,
- Haiyang

