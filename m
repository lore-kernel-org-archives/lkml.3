Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165AbaEKWg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 18:36:28 -0400
Received: from mail-sn2on0223.outbound.o365filtering.com ([157.56.87.223]:7068
	"EHLO na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750741AbaEKWgZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 18:36:25 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v2] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Topic: [PATCH net-next,v2] Add support for netvsc build without
 CONFIG_SYSFS flag
Thread-Index: AQHPavY3Dri7j1SZlEG37cKge/6wwZs3nCwA//+Lt3CABKtZgIAAIHd4
Date: Sun, 11 May 2014 22:35:40 +0000
Message-ID: <3fd83bc0e76c452386c15516a32c9cb3@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1399581693-25050-1-git-send-email-haiyangz@microsoft.com>
	 <20140508.164458.157597820665207475.davem@davemloft.net>
	 <b641d25465f44cae8c7c9a680a31594d@DFM-DB3MBX15-06.exchange.corp.microsoft.com>,<1399813625.11946.138.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1399813625.11946.138.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(377454003)(164054003)(51704005)(64706001)(74706001)(50466002)(74876001)(94946001)(93886001)(93136001)(23726002)(93516002)(94316002)(92566001)(90146001)(74366001)(20776003)(81342001)(47776003)(76796001)(79102001)(76786001)(85306002)(19580395003)(84676001)(81816001)(44976005)(83322001)(19580405001)(68736004)(81542001)(46406003)(2009001)(97736001)(98676001)(77982001)(81686001)(97756001)(97336001)(95416001)(86612001)(97186001)(56816006)(47976003)(65816002)(63696004)(56776002)(59766002)(80022001)(99396002)(47736002)(51856002)(31966008)(47446003)(95666003)(66066001)(69226001)(53806002)(49866002)(54356002)(4396001)(54316003)(50986002)(76482001)(21056001)(74502001)(74662001)(46102001)(6806004)(83072002)(85852003)(2656002)(87266001)(87936001)(33646001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB595;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 020877E0CB
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ________________________________________
> From: Ben Hutchings <ben@decadent.org.uk>
> Sent: Sunday, May 11, 2014 9:07 AM
> To: Haiyang Zhang
> I think most other drivers have a 1-1 mapping between hardware RX queues
> and the RX queue indices reported to Linux.  It appears that in this
> case sub_channel_index is the 'hardware' queue number, but you think
> there is not a 1-1 mapping.  Why is that?

Actually, it is 1-1 mapping. The number of channels equals to the number of
queues. In my updated patch (v3) the unnecessary "% ndev->real_num_rx_queues"
has been removed.

Thanks,
- Haiyang