Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbaEHUll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:41:41 -0400
Received: from mail-by1on0154.outbound.o365filtering.com ([207.46.101.154]:10390
	"EHLO na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754314AbaEHUlk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:41:40 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, v2] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Topic: [PATCH net-next, v2] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Index: AQHPavi6SPN64RxBPU+/TqpUUEIPj5s3JGWg
Date: Thu, 8 May 2014 20:41:32 +0000
Message-ID: <416d12ac27914bb98baa1891509d641c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1399581693-25050-1-git-send-email-haiyangz@microsoft.com>
 <20140508200352.GB8847@kroah.com>
In-Reply-To: <20140508200352.GB8847@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(24454002)(164054003)(377454003)(189002)(199002)(13464003)(64706001)(93516002)(94946001)(87266001)(2656002)(85852003)(74876001)(23726002)(47776003)(83072002)(74662001)(77982001)(74502001)(76796001)(76786001)(31966008)(4396001)(66066001)(74366001)(93136001)(80022001)(92566001)(79102001)(20776003)(87936001)(2009001)(97756001)(51856002)(21056001)(81342001)(46406003)(97336001)(46102001)(69226001)(99396002)(97186001)(76482001)(97736001)(98676001)(84676001)(81686001)(68736004)(44976005)(50986002)(56816006)(50466002)(63696004)(49866002)(47736002)(85306002)(94316002)(81542001)(86612001)(95666003)(33646001)(74706001)(95416001)(81816001)(6806004)(65816002)(53806002)(47446003)(59766002)(56776002)(54356002)(19580405001)(47976003)(19580395003)(54316003)(90146001)(83322001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB602;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0205EDCD76
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Thursday, May 8, 2014 4:04 PM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, v2] Add support for netvsc build without
> CONFIG_SYSFS flag
> 
> On Thu, May 08, 2014 at 01:41:33PM -0700, Haiyang Zhang wrote:
> > This change ensures the driver can be built successfully without the
> > CONFIG_SYSFS flag.
> > MS-TFS: 182270
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/net/hyperv/hyperv_net.h   |   28 ++++++++++++++++++++++++++++
> >  drivers/net/hyperv/netvsc_drv.c   |   13 +++++++------
> >  drivers/net/hyperv/rndis_filter.c |    4 ++--
> >  3 files changed, 37 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/hyperv_net.h
> > b/drivers/net/hyperv/hyperv_net.h index 4b7df5a..02358cb 100644
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
> > @@ -178,6 +180,32 @@ struct rndis_device {
> >  	unsigned char hw_mac_adr[ETH_ALEN];
> >  };
> >
> > +static inline void netvsc_record_rx_queue(struct sk_buff *skb,
> > +					  struct hv_netvsc_packet *packet,
> > +					  struct net_device *ndev)
> > +{
> > +#ifdef CONFIG_SYSFS
> > +	skb_record_rx_queue(skb, packet->channel->
> > +			    offermsg.offer.sub_channel_index %
> > +			    ndev->real_num_rx_queues);
> > +#endif
> 
> Really?  Do all other wireless drivers have this type of #ifdef needed?
> 
> > +}
> > +
> > +static inline void netvsc_show_num_queue(struct device *dev,
> > +					 struct net_device *ndev)
> > +{
> > +#ifdef CONFIG_SYSFS
> > +	dev_info(dev, "real num tx,rx queues:%u, %u\n",
> > +		 ndev->real_num_tx_queues, ndev->real_num_rx_queues);
> #endif
> 
> Do network drivers really spam the kernel log with this type of thing?
> If you have sysfs, why is this needed in the kernel log?
> 
> > +}
> > +
> > +static inline void netvsc_set_num_queue(unsigned int *nq) { #ifdef
> > +CONFIG_SYSFS
> > +	*nq = num_online_cpus();
> > +#endif
> > +}
> 
> I really feel that something is odd here...

I looked around the other drivers, and the netif_set_real_num_rx_queues() 
function. It's already switched to no-op without CONFIG_SYSFS flag. So I will 
rely on this, and don't have to handle the flag in my code. 

Also, the dev_info can be removed.

Thanks,
- Haiyang

