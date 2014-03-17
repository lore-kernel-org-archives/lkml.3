Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaCQUyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:54:18 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:5150 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752105AbaCQUyN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:54:13 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v2,1/1] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v2,1/1] hyperv: Add support for virtual
 Receive Side Scaling (vRSS)
Thread-Index: AQHPQGtOCpW0rMAQ3kiLiwjAUkgWbJrmMQeA//+T/6A=
Date: Mon, 17 Mar 2014 20:54:00 +0000
Message-ID: <5af7efbf6690432da2ef54dcbc99df20@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1394903887-30421-1-git-send-email-haiyangz@microsoft.com>
	<1394903887-30421-2-git-send-email-haiyangz@microsoft.com>
 <20140317.161955.776021754942208577.davem@davemloft.net>
In-Reply-To: <20140317.161955.776021754942208577.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(189002)(199002)(377454003)(164054003)(51704005)(13464003)(47736001)(93136001)(87266001)(74366001)(50986001)(49866001)(44976005)(83322001)(85306002)(76786001)(76796001)(80976001)(2656002)(47976001)(6806004)(19580405001)(81816001)(81686001)(79102001)(19580395003)(33646001)(90146001)(92566001)(4396001)(46102001)(56816005)(85852003)(83072002)(54316002)(69226001)(51856001)(95666003)(81342001)(93516002)(76482001)(46406003)(56776001)(50466002)(54356001)(53806001)(81542001)(86612001)(97736001)(2009001)(97756001)(65816001)(80022001)(77982001)(74706001)(74876001)(95416001)(94316002)(66066001)(97336001)(97186001)(47776003)(20776003)(94946001)(63696002)(59766001)(74502001)(74662001)(47446002)(31966008)(87936001)(23726002)(84676001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB609;H:hybrid.exchange.microsoft.com;FPR:3876402A.3CE3AD29.31F5B526.60E15A98.201D3;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-Test: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 0153A8321A
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, March 17, 2014 4:20 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v2,1/1] hyperv: Add support for virtual Receive
> Side Scaling (vRSS)
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Sat, 15 Mar 2014 10:18:07 -0700
> 
> > -		if (netif_queue_stopped(ndev) && !net_device->start_remove
> &&
> > -			(hv_ringbuf_avail_percent(&device->channel-
> >outbound)
> > -			> RING_AVAIL_PERCENT_HIWATER ||
> > -			num_outstanding_sends < 1))
> > -				netif_wake_queue(ndev);
> > +		if (netif_tx_queue_stopped(netdev_get_tx_queue(ndev, q_idx))
> > +			&& !net_device->start_remove &&
> > +			(hv_ringbuf_avail_percent(&channel->outbound)
> > +			> RING_AVAIL_PERCENT_HIWATER || queue_sends <
> 1))
> > +				netif_tx_wake_queue(netdev_get_tx_queue(
> > +						    ndev, q_idx));
> 
> This is not indented properly, make it:
> 
> 	if (A && B &&
> 	    (C >
>              D || E < 1))
> 
> Never put operators at the beginning of a conditional line, always at the end.

I will do. 

Thanks,
- Haiyang
