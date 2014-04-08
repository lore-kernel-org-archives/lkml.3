Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbaDHPnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:43:37 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.27]:29369 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756944AbaDHPne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:43:34 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sharat Masetty <sharat04@gmail.com>, David Miller <davem@davemloft.net>
CC: Linux Netdev List <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Index: AQHPUo9hwVfmBzXAgEOnJHwk6QrgC5sG8p4AgAA6kICAAK1G4A==
Date: Tue, 8 Apr 2014 15:43:25 +0000
Message-ID: <44c82a884313465184d9a15a66248d3b@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1396898623-31667-1-git-send-email-haiyangz@microsoft.com>
	<20140407.144258.2113005286706932770.davem@davemloft.net>
 <CAJzFV36G7Qq1jc1nNkU2h19=c3-N-q9SEOmyMobCRwdirf0+vQ@mail.gmail.com>
In-Reply-To: <CAJzFV36G7Qq1jc1nNkU2h19=c3-N-q9SEOmyMobCRwdirf0+vQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(377454003)(164054003)(51704005)(199002)(189002)(23676002)(99396002)(2009001)(2656002)(47976001)(97736001)(46102001)(4396001)(51856001)(53806001)(47736001)(6806004)(81342001)(87266001)(74662001)(49866001)(50986002)(87936001)(74876001)(94946001)(33646001)(59766001)(77982001)(56776001)(31966008)(93516002)(80976001)(92566001)(95666003)(79102001)(97336001)(63696002)(94316002)(19580395003)(76796001)(85852003)(65816001)(80022001)(47776003)(76786001)(76482001)(83322001)(81542001)(97186001)(74706001)(54356001)(74366001)(56816005)(19580405001)(74502001)(86612001)(47446002)(90146001)(81816001)(83072002)(50466002)(69226001)(81686001)(84676001)(98676001)(85306002)(54316002)(44976005)(95416001)(20776003)(66066001)(93136001)(15975445006)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;FPR:687C411E.2CF3B7C1.71EB1F0F.44E4DA7B.20230;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Exchange-Organization-AntiSpam-Internal: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 017589626D
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s38Fhn1M012107



> -----Original Message-----
> From: Sharat Masetty [mailto:sharat04@gmail.com]
> Sent: Monday, April 7, 2014 6:13 PM
> To: David Miller
> Cc: Haiyang Zhang; Linux Netdev List; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive Side
> Scaling (vRSS)
> 
> Hi Zhang,
> 
> How is this beneficial when compared to RPS(receive packet steering)?
> Can you please provide more details on what this patch does?

This patch supports the virtual RSS feature provided by Hyper-V hosts. Currently,
the interrupts are received on only one CPU per vNIC. With this feature, we can 
receive interrupts from multiple CPUs and VMBus channels for one vNIC. Outgoing 
packets are put into multiple channels as well. So the network throughput can 
scale up with the number of CPUs for a VM.

RPS is basically a software implementation of RSS. This is an online doc about 
these features:
https://www.kernel.org/doc/Documentation/networking/scaling.txt

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
