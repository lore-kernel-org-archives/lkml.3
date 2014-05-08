Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbaEHUuj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:50:39 -0400
Received: from mail-by1on0152.outbound.o365filtering.com ([207.46.101.152]:12050
	"EHLO na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755129AbaEHUuh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:50:37 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v2] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Topic: [PATCH net-next,v2] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Index: AQHPavY3Dri7j1SZlEG37cKge/6wwZs3nCwA//+Lt3A=
Date: Thu, 8 May 2014 20:50:06 +0000
Message-ID: <b641d25465f44cae8c7c9a680a31594d@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1399581693-25050-1-git-send-email-haiyangz@microsoft.com>
 <20140508.164458.157597820665207475.davem@davemloft.net>
In-Reply-To: <20140508.164458.157597820665207475.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(164054003)(51704005)(13464003)(377454003)(66066001)(64706001)(76786001)(80022001)(76796001)(65816002)(74876001)(94316002)(50466002)(21056001)(92566001)(81342001)(81542001)(95666003)(56776002)(56816006)(53806002)(59766002)(63696004)(54356002)(54316003)(31966008)(47976003)(49866002)(47446003)(47736002)(74662001)(74502001)(50986002)(99396002)(98676001)(33646001)(93136001)(23726002)(51856002)(93516002)(85306002)(74706001)(77982001)(94946001)(69226001)(47776003)(87266001)(85852003)(2656002)(95416001)(97336001)(90146001)(68736004)(46102001)(83322001)(84676001)(19580405001)(76482001)(83072002)(44976005)(86612001)(4396001)(97756001)(97186001)(20776003)(46406003)(81686001)(87936001)(74366001)(79102001)(97736001)(6806004)(2009001)(81816001)(19580395003)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0205EDCD76
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Thursday, May 8, 2014 4:45 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v2] Add support for netvsc build without
> CONFIG_SYSFS flag
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Thu,  8 May 2014 13:41:33 -0700
> 
> > +static inline void netvsc_record_rx_queue(struct sk_buff *skb,
> > +					  struct hv_netvsc_packet *packet,
> > +					  struct net_device *ndev)
> > +{
> > +#ifdef CONFIG_SYSFS
> > +	skb_record_rx_queue(skb, packet->channel->
> > +			    offermsg.offer.sub_channel_index %
> > +			    ndev->real_num_rx_queues);
> > +#endif
> > +}
> 
> This is still fantastically gross, what is so unique about your driver that it needs
> hacks like this?  No other driver to my knowledge does.
> 
> Figure out what it is that makes your driver so unique, and try to make it
> conform to how other drivers handle these features without SYSFS ifdef'ery
> instead.
> 

I looked around the other drivers, and the netif_set_real_num_rx_queues() function. 
It's already switched to no-op without CONFIG_SYSFS flag. So I will rely on this, and 
don't have to handle the flag in my code. 

Thanks,
- Haiyang

