Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaBJP6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:58:12 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.87]:59295 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744AbaBJP6F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:58:05 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net] hyperv: Fix the carrier status setting
Thread-Topic: [PATCH net] hyperv: Fix the carrier status setting
Thread-Index: AQHPJfV8J3DMjAE27Umhag/05LGOWpqvAkiA//+jWlA=
Date: Mon, 10 Feb 2014 15:57:55 +0000
Message-ID: <6fdabe9acd3d458c895746a049c6d066@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1391994478-25809-1-git-send-email-haiyangz@microsoft.com>
 <52F8D417.6020302@cogentembedded.com>
In-Reply-To: <52F8D417.6020302@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(51704005)(24454002)(164054003)(377454003)(377424004)(189002)(199002)(79102001)(23726002)(44976005)(49866001)(4396001)(47736001)(20776003)(50986001)(81816001)(19580395003)(74366001)(50466002)(74706001)(51856001)(69226001)(53806001)(54356001)(19580405001)(31966008)(74662001)(94946001)(6806004)(80976001)(59766001)(83322001)(63696002)(74876001)(46406003)(77982001)(76482001)(47446002)(85306002)(81542001)(47776003)(33646001)(80022001)(65816001)(66066001)(81342001)(46102001)(87936001)(56776001)(54316002)(2656002)(87266001)(76796001)(74502001)(85852003)(47976001)(90146001)(2201001)(81686001)(92566001)(56816005)(83072002)(95416001)(93516002)(94316002)(86612001)(93136001)(76786001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;CLIP:131.107.147.100;FPR:FE1E586E.3C30E225.69731A1F.607A62.201EF;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0118CD8765
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sergei Shtylyov [mailto:sergei.shtylyov@cogentembedded.com]
> Sent: Monday, February 10, 2014 8:29 AM
> To: Haiyang Zhang; davem@davemloft.net; netdev@vger.kernel.org
> Cc: KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-
> kernel@vger.kernel.org; driverdev-devel@linuxdriverproject.org
> Subject: Re: [PATCH net] hyperv: Fix the carrier status setting
> 
> Hello.
> 
> On 10-02-2014 5:07, Haiyang Zhang wrote:
> 
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >   drivers/net/hyperv/netvsc_drv.c |   24 +++++++++++++++---------
> >   1 files changed, 15 insertions(+), 9 deletions(-)
> 
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c index 7756118..836211c 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> [...]
> > @@ -229,15 +238,17 @@ void netvsc_linkstatus_callback(struct hv_device
> *device_obj,
> >   	struct net_device *net;
> >   	struct net_device_context *ndev_ctx;
> >   	struct netvsc_device *net_device;
> > +	struct rndis_device *rdev;
> >
> >   	net_device = hv_get_drvdata(device_obj);
> > +	rdev = net_device->extension;
> > +
> > +	rdev->link_state = !(status == 1);
> 
>     Why not just 'status != 1'?

I will simplify it.
Thanks,
- Haiyang
