Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbaGHSwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:52:05 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.26]:2770 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753405AbaGHSwC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:52:02 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Richard Weinberger <richard@nod.at>, KY Srinivasan <kys@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] hyperv: Add netpoll support
Thread-Topic: [PATCH] hyperv: Add netpoll support
Thread-Index: AQHPmo+Uu3DOvIv0yEyW/qveONVAPJuWdd5QgACChgD//41OoA==
Date: Tue, 8 Jul 2014 18:51:35 +0000
Message-ID: <70a31f9c525b4e12af19ed0189aa2fce@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1404811947-5174-1-git-send-email-richard@nod.at>
 <6869a7dec43b4ba6b38692874f67279a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <53BC3B1A.4000009@nod.at>
In-Reply-To: <53BC3B1A.4000009@nod.at>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(164054003)(377454003)(13464003)(189002)(199002)(51704005)(74662001)(76482001)(21056001)(33646001)(74502001)(92566001)(23726002)(87936001)(4396001)(46406003)(31966008)(81342001)(86612001)(1511001)(64706001)(47776003)(20776003)(79102001)(97736001)(2009001)(97756001)(99396002)(80022001)(46102001)(66066001)(50466002)(84676001)(6806004)(44976005)(83322001)(19580405001)(19580395003)(68736004)(77982001)(106116001)(83072002)(85852003)(2656002)(77096999)(50986999)(106466001)(81542001)(107046002)(54356999)(76176999)(108616002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0266491E90
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Tuesday, July 8, 2014 2:40 PM
> To: Haiyang Zhang; KY Srinivasan
> Cc: devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] hyperv: Add netpoll support
> 
> Am 08.07.2014 19:55, schrieb Haiyang Zhang:
> >
> >
> >> -----Original Message-----
> >> From: Richard Weinberger [mailto:richard@nod.at]
> >> Sent: Tuesday, July 8, 2014 5:32 AM
> >> To: KY Srinivasan; Haiyang Zhang
> >> Cc: devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; Richard Weinberger
> >> Subject: [PATCH] hyperv: Add netpoll support
> >>
> >> In order to have at least a netconsole to debug kernel issues on
> >> Windows Azure this patch implements netpoll support.
> >> Sending packets is easy, netvsc_start_xmit() does already everything
> >> needed.
> >> To receive we need to trigger the channel callback which is usally
> >> called via tasklet_schedule().
> >>
> >> Signed-off-by: Richard Weinberger <richard@nod.at>
> >> ---
> >>  drivers/net/hyperv/netvsc_drv.c | 14 ++++++++++++++
> >>  1 file changed, 14 insertions(+)
> >>
> >> diff --git a/drivers/net/hyperv/netvsc_drv.c
> >> b/drivers/net/hyperv/netvsc_drv.c
> >> index 4fd71b7..367b71e 100644
> >> --- a/drivers/net/hyperv/netvsc_drv.c
> >> +++ b/drivers/net/hyperv/netvsc_drv.c
> >> @@ -736,6 +736,17 @@ static int netvsc_set_mac_addr(struct net_device
> >> *ndev, void *p)
> >>  	return err;
> >>  }
> >>
> >> +#ifdef CONFIG_NET_POLL_CONTROLLER
> >> +static void netvsc_poll_controller(struct net_device *net)
> >> +{
> >> +	struct net_device_context *net_device_ctx = netdev_priv(net);
> >> +	struct hv_device *dev = net_device_ctx->device_ctx;
> >> +
> >> +	local_bh_disable();
> >> +	netvsc_channel_cb(dev->channel);
> >
> > This can only poll the primary channel not the sub channels.
> 
> Sub channels in terms of one channel per VCPU as KY said?
> 
> *confused*,

Since it's used only for debugging, polling the subchannels may not be
necessary.

Regarding the CPU binding, KY will reply you in another email.

Thanks,
- Haiyang

