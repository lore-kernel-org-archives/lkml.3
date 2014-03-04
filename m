Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaCDTi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:38:28 -0500
Received: from [157.55.158.30] ([157.55.158.30]:27932 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754490AbaCDTi0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:38:26 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Move state setting for link query
Thread-Topic: [PATCH net-next] hyperv: Move state setting for link query
Thread-Index: AQHPNzS1MjMVTcnutkixH59RjUyzbprQxhqAgACM1eA=
Date: Tue, 4 Mar 2014 19:36:04 +0000
Message-ID: <2f61f102bf3d4185b31c5020caab5464@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1393890875-1420-1-git-send-email-haiyangz@microsoft.com>
 <531543FD.7090907@redhat.com>
In-Reply-To: <531543FD.7090907@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(164054003)(51704005)(13464003)(24454002)(189002)(199002)(479174003)(377454003)(87936001)(74366001)(83322001)(81686001)(56776001)(44976005)(19580395003)(19580405001)(94316002)(80976001)(76796001)(94946001)(77982001)(69226001)(76786001)(59766001)(54316002)(95416001)(23726002)(86612001)(6806004)(92566001)(93136001)(54356001)(2201001)(81542001)(56816005)(81342001)(76482001)(53806001)(51856001)(85852003)(74876001)(50466002)(50986001)(4396001)(84676001)(31966008)(95666003)(49866001)(46406003)(20776003)(47446002)(47776003)(80022001)(83072002)(87266001)(65816001)(66066001)(63696002)(81816001)(33646001)(2656002)(79102001)(93516002)(46102001)(47976001)(74706001)(85306002)(74502001)(90146001)(74662001)(47736001)(97186001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB596;H:hybrid.exchange.microsoft.com;FPR:B60E783E.3E639DEA.417ABB94.40E3E9EB.20234;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 01401330D1
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Monday, March 3, 2014 10:10 PM
> To: Haiyang Zhang; davem@davemloft.net; netdev@vger.kernel.org
> Cc: KY Srinivasan; olaf@aepfle.de; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Move state setting for link query
> 
> On 03/04/2014 07:54 AM, Haiyang Zhang wrote:
> > It moves the state setting for query into rndis_filter_receive_response().
> > All callbacks including query-complete and status-callback are
> > synchronized by channel->inbound_lock. This prevents pentential race
> between them.
> 
> This still looks racy to me. The problem is workqueue is not synchronized with
> those here.
> 
> Consider the following case in netvsc_link_change():
> 
>     if (rdev->link_state) {
>     ... receive interrupt ...
>     rndis_filter_receice_response() which changes rdev->link_state
>     ...
>         netif_carrier_off()
>     }
> 
> And also it need to schedule a work otherwise the link status is out of sync.

I will update this patch to schedule a work by the end of probe function.

Thanks,
- Haiyang

