Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaFWQKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:10:22 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.29]:55257 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755008AbaFWQKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:10:20 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Olaf Hering <olaf@aepfle.de>
CC: Greg KH <greg@kroah.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Topic: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt55UEAgAAEPICAADyUMIAEqgwA///ZfgCAAH5ugP//tltA
Date: Mon, 23 Jun 2014 16:09:59 +0000
Message-ID: <5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de> <20140620051213.GA9960@kroah.com>
 <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623080242.GA16924@aepfle.de>
 <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623131723.GA7026@aepfle.de>
In-Reply-To: <20140623131723.GA7026@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(164054003)(24454002)(13464003)(51704005)(199002)(189002)(377454003)(84676001)(46102001)(81342001)(64706001)(83072002)(93886003)(74502001)(31966008)(87936001)(23676002)(76176999)(68736004)(106116001)(77096999)(50986999)(86612001)(99396002)(6806004)(79102001)(74662001)(85852003)(2656002)(92566001)(47776003)(20776003)(97736001)(85326001)(44976005)(19580405001)(19580395003)(83322001)(80022001)(50466002)(66066001)(2009001)(21056001)(106466001)(54356999)(4396001)(77982001)(81542001)(76482001)(33646001)(24736002)(106276001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB606;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5NGARNZ020646



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, June 23, 2014 9:17 AM
> To: Haiyang Zhang
> Cc: Greg KH; netdev@vger.kernel.org; jasowang@redhat.com; driverdev-
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> On Mon, Jun 23, Haiyang Zhang wrote:
> 
> > > I think its reasonable to expect guest config changes on this new
> > > kind of host. Would a link-down/link-up event work? I'm sure it
> > > will, there is enough code floating around in the guests which handles cable
> unplug.
> >
> > Do you mean netif_carrier_off() / netif_carrier_on()? They are already
> > called in the code before this patch, but DHCP renew is not triggered
> > by them.
> 
> I do not know how to simulate a cable unplug. The point is that calling
> /etc/init.d/network will fail, at least in SLES12.
> Maybe some sort of "DHCP refresh required" event is required?
> Maybe the DHCP clients need to renew on cable unplug?
> No idea what the solution to the issue really is.

Yes, it will be great if there is such a "DHCP refresh required" event, or DHCP clients
are triggered when netif_carrier_off() then netif_carrier_on().

I have tried some possibilities, like IF_OPER_DORMANT then IF_OPER_UP with 
netdev_state_change() etc. but not able to trigger DHCP review. I will look at this
further...

So, what's the equivalent or similar command to "network restart" on SLES12? Could
you update the command line for the usermodehelper when porting this patch to SLES
12?

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
