Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaEHTsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:48:20 -0400
Received: from mail-by1on0160.outbound.o365filtering.com ([207.46.101.160]:62723
	"EHLO na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755228AbaEHTsT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:48:19 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Topic: [PATCH net-next] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Index: AQHPaj4uOIq583GIwU2cUnDyRPubYps23EsA///pvlCAALxCAP//laxA
Date: Thu, 8 May 2014 19:47:52 +0000
Message-ID: <ec503f90e3914e2786e0f0d0f7dc0796@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1399502704-18495-1-git-send-email-haiyangz@microsoft.com>
 <20140508091304.GB24820@kroah.com>
 <67b9b573b20f4cc2b6fe75fe84ee48e1@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140508190712.GB6766@kroah.com>
In-Reply-To: <20140508190712.GB6766@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(164054003)(24454002)(13464003)(377454003)(51704005)(81816001)(46406003)(93886001)(68736004)(87936001)(90146001)(44976005)(2656002)(86612001)(23726002)(93516002)(94316002)(95416001)(87266001)(21056001)(74876001)(85306002)(19580395003)(92566001)(81686001)(50466002)(93136001)(19580405001)(83322001)(74706001)(33646001)(50986002)(97186001)(2009001)(99396002)(97336001)(54356002)(47446003)(53806002)(76786001)(76796001)(6806004)(66066001)(80022001)(69226001)(65816002)(59766002)(49866002)(63696004)(54316003)(56776002)(97736001)(97756001)(51856002)(56816006)(47736002)(47976003)(4396001)(81542001)(79102001)(85852003)(83072002)(77982001)(84676001)(64706001)(81342001)(98676001)(95666003)(74662001)(94946001)(31966008)(74502001)(46102001)(76482001)(20776003)(47776003)(74366001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0205EDCD76
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, May 8, 2014 3:07 PM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] Add support for netvsc build without
> CONFIG_SYSFS flag
> 
> On Thu, May 08, 2014 at 03:13:19PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH [mailto:greg@kroah.com]
> > > Sent: Thursday, May 8, 2014 5:13 AM
> > > To: Haiyang Zhang
> > > Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> > > jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> > > kernel@vger.kernel.org
> > > Subject: Re: [PATCH net-next] Add support for netvsc build without
> > > CONFIG_SYSFS flag
> > >
> > > On Wed, May 07, 2014 at 03:45:04PM -0700, Haiyang Zhang wrote:
> > > > This change ensures the driver can be built successfully without
> > > > the CONFIG_SYSFS flag.
> > > > MS-TFS: 182270
> > > >
> > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > ---
> > > >  drivers/net/hyperv/hyperv_net.h   |    2 ++
> > > >  drivers/net/hyperv/netvsc_drv.c   |   12 +++++++++++-
> > > >  drivers/net/hyperv/rndis_filter.c |    4 ++--
> > > >  3 files changed, 15 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/hyperv/hyperv_net.h
> > > > b/drivers/net/hyperv/hyperv_net.h index 4b7df5a..23b96bc 100644
> > > > --- a/drivers/net/hyperv/hyperv_net.h
> > > > +++ b/drivers/net/hyperv/hyperv_net.h
> > > > @@ -87,6 +87,8 @@ struct ndis_recv_scale_cap { /*
> > > > NDIS_RECEIVE_SCALE_CAPABILITIES */  #define HASH_KEYLEN
> > > > NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2
> > > >  extern u8 netvsc_hash_key[];
> > > >
> > > > +extern unsigned int netvsc_num_queue;
> > > > +
> > > >  struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS
> */
> > > >  	struct ndis_obj_header hdr;
> > > >
> > > > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > > > b/drivers/net/hyperv/netvsc_drv.c index 939e3af..07896f3 100644
> > > > --- a/drivers/net/hyperv/netvsc_drv.c
> > > > +++ b/drivers/net/hyperv/netvsc_drv.c
> > > > @@ -52,6 +52,8 @@ static int ring_size = 128;
> > > > module_param(ring_size, int, S_IRUGO);
> > > > MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
> > > >
> > > > +unsigned int netvsc_num_queue = 1;
> > > > +
> > > >  static void do_set_multicast(struct work_struct *w)  {
> > > >  	struct net_device_context *ndevctx = @@ -639,9 +641,11 @@ int
> > > > netvsc_recv_callback(struct hv_device *device_obj,
> > > >  		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
> > > >  				       packet->vlan_tci);
> > > >
> > > > +#ifdef CONFIG_SYSFS
> > > >  	skb_record_rx_queue(skb, packet->channel->
> > > >  			    offermsg.offer.sub_channel_index %
> > > >  			    net->real_num_rx_queues);
> > > > +#endif
> > >
> > > Why is this a sysfs-only function?  It should have nothing to do with sysfs,
> right?
> > > So why would the driver care?
> >
> > Without CONFIG_SYSFS the multi-receive queues are not allocated, see
> > below, and the variable real_num_rx_queues is not defined, so we skip this
> function.
> >
> > In alloc_netdev_mqs(), file "net/core/dev.c":
> > #ifdef CONFIG_SYSFS
> >         dev->num_rx_queues = rxqs;
> >         dev->real_num_rx_queues = rxqs;
> >         if (netif_alloc_rx_queues(dev))
> >                 goto free_all;
> > #endif
> 
> Then you need to structure your driver better :)

I have submitted an update patch.

Thanks,
- Haiyang

