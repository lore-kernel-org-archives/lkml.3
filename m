Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaFWMsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:48:05 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.87]:51063 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbaFWMsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:48:03 -0400
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
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt55UEAgAAEPICAADyUMIAEqgwA///ZfgA=
Date: Mon, 23 Jun 2014 12:47:52 +0000
Message-ID: <06b508cbb6b949f4b3e13e7797948e56@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620045704.GA4850@aepfle.de> <20140620051213.GA9960@kroah.com>
 <ff458d1b896d4a70a32fa7709911274c@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140623080242.GA16924@aepfle.de>
In-Reply-To: <20140623080242.GA16924@aepfle.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(24454002)(164054003)(51704005)(189002)(199002)(377454003)(13464003)(77982001)(46102001)(31966008)(74662001)(23676002)(93886003)(84676001)(2656002)(85852003)(83072002)(87936001)(86612001)(81342001)(68736004)(81542001)(33646001)(44976005)(19580405001)(83322001)(19580395003)(6806004)(76482001)(99396002)(97736001)(47776003)(20776003)(2009001)(21056001)(4396001)(64706001)(77096999)(92566001)(106116001)(74502001)(50986999)(54356999)(76176999)(79102001)(66066001)(106466001)(85326001)(50466002)(80022001)(24736002)(106276001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB596;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5NCmA6m018440



> -----Original Message-----
> From: Olaf Hering [mailto:olaf@aepfle.de]
> Sent: Monday, June 23, 2014 4:03 AM
> To: Haiyang Zhang
> Cc: Greg KH; netdev@vger.kernel.org; jasowang@redhat.com; driverdev-
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org;
> davem@davemloft.net
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> On Fri, Jun 20, Haiyang Zhang wrote:
> 
> > This command ("/etc/init.d/network restart") exists on our supported
> distros
> > currently. We will also look into some better ways to refresh the
> network for
> > the distros without this command. I have tried setting IF_OPER_DORMANT
> then
> > IF_OPER_UP, but not working. I will look into the suspend/resume cycle
> as
> > well.
> 
> I think its reasonable to expect guest config changes on this new kind
> of host. Would a link-down/link-up event work? I'm sure it will, there
> is enough code floating around in the guests which handles cable unplug.

Do you mean netif_carrier_off() / netif_carrier_on()? They are already 
called in the code before this patch, but DHCP renew is not triggered by
them.

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
