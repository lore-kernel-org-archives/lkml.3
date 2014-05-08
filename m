Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaEHPNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:13:32 -0400
Received: from mail-by1on0157.outbound.o365filtering.com ([207.46.101.157]:8662
	"EHLO na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751625AbaEHPNa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:13:30 -0400
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
Thread-Index: AQHPaj4uOIq583GIwU2cUnDyRPubYps23EsA///pvlA=
Date: Thu, 8 May 2014 15:13:19 +0000
Message-ID: <67b9b573b20f4cc2b6fe75fe84ee48e1@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1399502704-18495-1-git-send-email-haiyangz@microsoft.com>
 <20140508091304.GB24820@kroah.com>
In-Reply-To: <20140508091304.GB24820@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(51704005)(377454003)(164054003)(24454002)(189002)(199002)(19580405001)(84676001)(83322001)(86612001)(4396001)(76482001)(44976005)(83072002)(2656002)(97336001)(95416001)(85852003)(46102001)(68736004)(90146001)(81686001)(74366001)(87936001)(19580395003)(81816001)(79102001)(97736001)(2009001)(6806004)(97756001)(97186001)(20776003)(46406003)(21056001)(94316002)(50466002)(95666003)(92566001)(81342001)(81542001)(66066001)(76786001)(80022001)(64706001)(94946001)(85306002)(74706001)(47776003)(87266001)(77982001)(69226001)(74502001)(74662001)(49866002)(47736002)(56816006)(59766002)(56776002)(54356002)(53806002)(76796001)(65816002)(74876001)(63696004)(47976003)(47446003)(31966008)(54316003)(98676001)(93516002)(51856002)(23726002)(33646001)(93136001)(99396002)(50986002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0205EDCD76
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, May 8, 2014 5:13 AM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] Add support for netvsc build without
> CONFIG_SYSFS flag
> 
> On Wed, May 07, 2014 at 03:45:04PM -0700, Haiyang Zhang wrote:
> > This change ensures the driver can be built successfully without the
> > CONFIG_SYSFS flag.
> > MS-TFS: 182270
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/net/hyperv/hyperv_net.h   |    2 ++
> >  drivers/net/hyperv/netvsc_drv.c   |   12 +++++++++++-
> >  drivers/net/hyperv/rndis_filter.c |    4 ++--
> >  3 files changed, 15 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/hyperv_net.h
> > b/drivers/net/hyperv/hyperv_net.h index 4b7df5a..23b96bc 100644
> > --- a/drivers/net/hyperv/hyperv_net.h
> > +++ b/drivers/net/hyperv/hyperv_net.h
> > @@ -87,6 +87,8 @@ struct ndis_recv_scale_cap { /*
> > NDIS_RECEIVE_SCALE_CAPABILITIES */  #define HASH_KEYLEN
> > NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2
> >  extern u8 netvsc_hash_key[];
> >
> > +extern unsigned int netvsc_num_queue;
> > +
> >  struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS */
> >  	struct ndis_obj_header hdr;
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> > b/drivers/net/hyperv/netvsc_drv.c index 939e3af..07896f3 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -52,6 +52,8 @@ static int ring_size = 128;  module_param(ring_size,
> > int, S_IRUGO);  MODULE_PARM_DESC(ring_size, "Ring buffer size (# of
> > pages)");
> >
> > +unsigned int netvsc_num_queue = 1;
> > +
> >  static void do_set_multicast(struct work_struct *w)  {
> >  	struct net_device_context *ndevctx = @@ -639,9 +641,11 @@ int
> > netvsc_recv_callback(struct hv_device *device_obj,
> >  		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
> >  				       packet->vlan_tci);
> >
> > +#ifdef CONFIG_SYSFS
> >  	skb_record_rx_queue(skb, packet->channel->
> >  			    offermsg.offer.sub_channel_index %
> >  			    net->real_num_rx_queues);
> > +#endif
> 
> Why is this a sysfs-only function?  It should have nothing to do with sysfs, right?
> So why would the driver care?

Without CONFIG_SYSFS the multi-receive queues are not allocated, see below, and 
the variable real_num_rx_queues is not defined, so we skip this function.

In alloc_netdev_mqs(), file "net/core/dev.c":
#ifdef CONFIG_SYSFS
        dev->num_rx_queues = rxqs;
        dev->real_num_rx_queues = rxqs;
        if (netif_alloc_rx_queues(dev))
                goto free_all;
#endif

> Don't put #ifdef in drivers, it's unmaintainable over time, if this really is a sysfs-
> only function, this should already be handled automatically in a .h file
> somewhere.

OK, I will move the #ifdef into hyperv_net.h.

Thanks,
- Haiyang

