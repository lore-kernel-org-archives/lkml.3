Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3LSUuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:50:25 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.87]:34257 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184Ab3LSUuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:50:23 -0500
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
Thread-Index: AQHO/DjpLyfIXxkiYUqDQo2oHD6XuZpcUhsA//+GhuCAAIn5gP//g6IggACQ8YD//4UPEA==
Date: Thu, 19 Dec 2013 20:49:42 +0000
Message-ID: <05be4f23ff784e56b710dd02eb88358a@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
	<1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
	<ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<52B33EC1.5040901@redhat.com>
	<6ee28c6a94e74c958ee96c3547741fb9@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <CA+mtBx-BBBQjVTOrnaow=GNc7VM5D2Zj8xr=fPM4b4f_xT7qkQ@mail.gmail.com>
In-Reply-To: <CA+mtBx-BBBQjVTOrnaow=GNc7VM5D2Zj8xr=fPM4b4f_xT7qkQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(13464003)(164054003)(51704005)(199002)(189002)(377454003)(81686001)(53806001)(54356001)(15202345003)(44976005)(76786001)(80976001)(74366001)(31966008)(74502001)(19580395003)(47446002)(83322001)(19580405001)(74662001)(90146001)(46102001)(76796001)(6806004)(87936001)(56816005)(2656002)(85852003)(4396001)(81816001)(83072002)(50466002)(81342001)(51856001)(81542001)(59766001)(80022001)(69226001)(20776003)(23676002)(47776003)(85306002)(66066001)(33646001)(47736001)(50986001)(79102001)(77982001)(74876001)(49866001)(15975445006)(65816001)(74706001)(54316002)(47976001)(56776001)(63696002)(87266001)(76482001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB600;H:hybrid.exchange.microsoft.com;CLIP:131.107.147.100;FPR:;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 006546F32A
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJKoS2D007967



> -----Original Message-----
> From: Tom Herbert [mailto:therbert@google.com]
> Sent: Thursday, December 19, 2013 2:59 PM
> To: Haiyang Zhang
> Cc: Daniel Borkmann; Ben Hutchings; davem@davemloft.net;
> netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
> Scaling (vRSS)
> 
> I posted an implementation of library functions for Toeplitz (see [PATCH 1/2]
> net: Toeplitz library functions).  This includes some pre-computation of the
> table to get reasonable performance in the host. Please take a look.
> 
> On the other hand, if you're computing a hash in the host, do you really need
> Toeplitz, flow_dissector already supports a good hash computation and can
> parse many more packets than just plain UDP/TCP.
> We probably only should be doing Toeplitz in the host if we need to match
> HW computed values.

The Hyper-V host requires the guest to select channel based on Toeplitz hash, so
we need to compute it on the guest. 

Regarding the Toeplitz function, do you mean this patch?
http://patchwork.ozlabs.org/patch/277344/
This doesn't contain the implementation. Could you point me to the actual code?

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
