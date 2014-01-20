Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaATWKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:10:46 -0500
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:14718
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751825AbaATWKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:10:44 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>, David Miller <davem@davemloft.net>
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
Thread-Index: AQHPDYLQyB5hy1ACYE2kEKNLoqdfyZqE1buAgAlm8ICAAACykA==
Date: Mon, 20 Jan 2014 22:10:40 +0000
Message-ID: <18b9150b090043b7b296593af994f8ee@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389306287-20057-1-git-send-email-haiyangz@microsoft.com>
 <20140114.143133.1863157816134006560.davem@davemloft.net>
 <5f60b6bd1ea84eadbb730c7ea9d3d4d5@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
In-Reply-To: <5f60b6bd1ea84eadbb730c7ea9d3d4d5@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.159.229]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(164054003)(51704005)(377454003)(189002)(199002)(13464003)(87266001)(63696002)(1511001)(79102001)(81816001)(76576001)(31966008)(74502001)(47446002)(74662001)(85306002)(81542001)(81342001)(76786001)(76796001)(69226001)(77982001)(59766001)(54316002)(56776001)(83072002)(65816001)(49866001)(47976001)(47736001)(4396001)(85852003)(80022001)(19580395003)(53806001)(54356001)(46102001)(74706001)(51856001)(33646001)(50986001)(19580405001)(83322001)(86362001)(66066001)(80976001)(93516002)(87936001)(76482001)(2656002)(56816005)(74316001)(81686001)(93136001)(74876001)(92566001)(90146001)(74366001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.159.229;FPR:;InfoNoRecordsMX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Haiyang Zhang
> Sent: Monday, January 20, 2014 2:06 PM
> To: David Miller
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: RE: [PATCH net-next] hyperv: Add support for physically discontinuous
> receive buffer
> 
> 
> 
> > -----Original Message-----
> > From: David Miller [mailto:davem@davemloft.net]
> > Sent: Tuesday, January 14, 2014 5:32 PM
> > To: Haiyang Zhang
> > Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> > jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> > devel@linuxdriverproject.org
> > Subject: Re: [PATCH net-next] hyperv: Add support for physically discontinuous
> > receive buffer
> >
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> > Date: Thu,  9 Jan 2014 14:24:47 -0800
> >
> > > This will allow us to use bigger receive buffer, and prevent
> > > allocation failure due to fragmented memory.
> > >
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> >
> > Not until you start using paged SKBs in netvsc_recv_callback.
> >
> > Whatever fragmention you think you're avoiding in the hyperv layer, you're still
> > going to get from the:
> >
> > skb = netdev_alloc_skb_ip_align(net, packet->total_data_buflen);
> >
> > call there.
> >
> > This change makes no sense in isolation, therefore I'm not applying it until you
> > also include the appropriate changes to avoid the same exact fragmentation
> > issue in netvsc_drv.c as stated above.
> 
> The receive buffer currently requires multiple MB of physically continuous
> memory,
> and may fail to be allocated when memory is fragmented. The patch is created
> for
> this issue.
> 
> The SKB buffer is usually less than 1500 bytes or up to several KB with jumbo
> frame,
> so it's much less sensitive to fragmented memory. I will work on another patch to
> use
> SKB buffer with discontinuous pages.
> 
> Could you accept this patch separately?

Today, if we try to unload and load the network driver, the load may fail because we may 
not be able to allocate the receive buffers if memory is fragmented. This patch specifically addresses
this problem.

Regards,

K. Y
> 
> Thanks,
> - Haiyang
> 

