Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaFWSVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:21:25 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.23]:36885 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbaFWSVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:21:23 -0400
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
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt55UEAgAAEPICAADyUMIAEqgwA///ZfgCAAH5ugP//tltAgAB+poD//6PcsA==
Date: Mon, 23 Jun 2014 18:21:13 +0000
Message-ID: <4ee8be5360a44b5abfa6df871ec45527@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de> <20140620051213.GA9960@kroah.com>
 <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623080242.GA16924@aepfle.de>
 <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623131723.GA7026@aepfle.de>
 <5fb9ddebb68d456ab87979b5cc3830ec@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623162705.GA5957@aepfle.de>
In-Reply-To: <20140623162705.GA5957@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(51704005)(24454002)(13464003)(51914003)(164054003)(199002)(189002)(76482001)(77982001)(64706001)(81342001)(79102001)(19580405001)(83322001)(20776003)(47776003)(46102001)(19580395003)(44976005)(6806004)(66066001)(80022001)(31966008)(23676002)(2009001)(4396001)(81542001)(74662001)(74502001)(97736001)(33646001)(99396002)(93886003)(50466002)(54356999)(106466001)(106116001)(50986999)(76176999)(21056001)(77096999)(83072002)(68736004)(86612001)(92566001)(85326001)(87936001)(2656002)(84676001)(85852003)(24736002)(106276001);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB612;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5NILT1n021438



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, June 23, 2014 12:27 PM
> To: Haiyang Zhang
> Cc: Greg KH; netdev@vger.kernel.org; jasowang@redhat.com; driverdev-
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> On Mon, Jun 23, Haiyang Zhang wrote:
> 
> > I have tried some possibilities, like IF_OPER_DORMANT then IF_OPER_UP
> > with
> > netdev_state_change() etc. but not able to trigger DHCP review. I will
> > look at this further...
> 
> Is there a link down/up event anyway?
> If the interface is configured to "on hotplug" or "on cable plugged in"
> or whatever the setting name is, the network scripts should do something. Even
> if its not a DHCP renew.

Yes, there is a link down/up event from the host, we currently call netif_carrier_off() 
/ netif_carrier_on() with these events. Will hotplug scripts be triggered by 
netif_carrier_off/on? Where are the scripts located at (SLES)?

> 
> > So, what's the equivalent or similar command to "network restart" on
> > SLES12? Could you update the command line for the usermodehelper when
> > porting this patch to SLES 12?
> 
> I see a /sbin/rcnetwork in SLES, which links either to '/etc/init.d/network' or
> 'service'. This could be used as a quick workaround.

Thanks for the info!

Thanks,
- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
