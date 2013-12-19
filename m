Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3LSX00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:26:26 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.23]:31203 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756443Ab3LSX0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:26:24 -0500
X-Greylist: delayed 14665 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 18:26:24 EST
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Tom Herbert <therbert@google.com>
CC: Daniel Borkmann <dborkman@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
Thread-Topic: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
Thread-Index: AQHO/DjpLyfIXxkiYUqDQo2oHD6XuZpcUhsA//+GhuCAAIn5gP//g6IggACQ8YD//4UPEAATARIAAA2nPlA=
Date: Thu, 19 Dec 2013 23:15:25 +0000
Message-ID: <3eb3eb6885704b6098c39fad1fdfc443@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
	<1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
	<ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<52B33EC1.5040901@redhat.com>
	<6ee28c6a94e74c958ee96c3547741fb9@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<CA+mtBx-BBBQjVTOrnaow=GNc7VM5D2Zj8xr=fPM4b4f_xT7qkQ@mail.gmail.com>
	<05be4f23ff784e56b710dd02eb88358a@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
 <CA+mtBx_SSPd6s5519dWCyPGmFvO=kE+Fh3ZQ9w9oo=pJraRAFQ@mail.gmail.com>
In-Reply-To: <CA+mtBx_SSPd6s5519dWCyPGmFvO=kE+Fh3ZQ9w9oo=pJraRAFQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(164054003)(51704005)(377454003)(13464003)(199002)(189002)(47776003)(20776003)(63696002)(74706001)(87936001)(46102001)(79102001)(66066001)(49866001)(74366001)(87266001)(50466002)(80022001)(65816001)(50986001)(47736001)(47976001)(77982001)(85306002)(2656002)(76482001)(33646001)(6806004)(59766001)(80976001)(85852003)(81342001)(90146001)(56816005)(83072002)(74662001)(4396001)(23676002)(69226001)(31966008)(47446002)(74502001)(81686001)(51856001)(83322001)(81816001)(74876001)(54316002)(81542001)(76786001)(56776001)(44976005)(19580405001)(76796001)(19580395003)(54356001)(53806001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB599;H:hybrid.exchange.microsoft.com;CLIP:131.107.159.100;FPR:;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 006546F32A
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJNQUlM008684

> -----Original Message-----
> From: Tom Herbert [mailto:therbert@google.com]
> Sent: Thursday, December 19, 2013 4:43 PM
> To: Haiyang Zhang
> Cc: Daniel Borkmann; Ben Hutchings; davem@davemloft.net;
> netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
> Scaling (vRSS)
> 
> Patch is below. This version did most pre-computation of the variants I built,
> but results in largest table (40*256*4 bytes), This gives performance roughly
> comparable with jhash (roughly same as jhash for IPv4, about 30% more
> cycles for IPv6). I have the simpler less memory intensive versions also if
> you're interested, these are 10x worse cycles so I wouldn't want those in
> critical path.
> ----

Thank you for the code. We like the fast implementation even it uses a bit more
memory. Are you going to address the comments and re-submit the code soon?

Thanks,
- Haiyang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
