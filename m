Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965192Ab3DPUYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:24:11 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.90]:11292 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767Ab3DPUYK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:24:10 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Topic: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Index: AQHOOtDW1pnjd9tR6kuWeKoviY/WAZjZrCqA//+LioCAAH7yAP//kVtA
Date: Tue, 16 Apr 2013 20:18:05 +0000
Message-ID: <b5d9b49f46ab434eb38a24e34f0b984b@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1366139031-12518-1-git-send-email-haiyangz@microsoft.com>
	<20130416.151141.1928940532005718606.davem@davemloft.net>
	<57e8f99081a94575a57cae5e93705c22@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20130416.154912.896506198616355113.davem@davemloft.net>
In-Reply-To: <20130416.154912.896506198616355113.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(189002)(13464002)(377454001)(164054002)(199002)(51704004)(54316002)(69226001)(47776003)(49866001)(79102001)(4396001)(65816001)(23726002)(56816002)(77982001)(59766001)(50466001)(66066001)(6806003)(20776003)(56776001)(46102001)(81342001)(47976001)(47736001)(50986001)(5343635001)(51856001)(46406003)(5343655001)(53806001)(74502001)(47446002)(76482001)(33646001)(74662001)(44976003)(54356001)(81542001)(31966008)(80022001)(63696002)(16406001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2SR01MB607;H:hybrid.exchange.microsoft.com;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0818724663
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net] 
> Sent: Tuesday, April 16, 2013 3:49 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
>
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 16 Apr 2013 19:34:52 +0000
>
> > The Hyper-V hosts always use 64 bit request id. The guests can have
> > 32 or 64 bit pointers which equal to the ulong type size. So we cast 
> > it to ulong type. And, assigning 32bit integer to 64 bit variable 
> > works fine.
>
> It works fine, but it's unclean.
>
> Keep the req_id type as "u64", because that's what it is, a 64-bit request ID.

I will make this update and submit a new patch, with the added comments.

Thanks,
- Haiyang
