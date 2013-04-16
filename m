Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364Ab3DPUqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:46:44 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:22415 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964981Ab3DPUqn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:46:43 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Joe Perches <joe@perches.com>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Topic: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Index: AQHOOtDW1pnjd9tR6kuWeKoviY/WAZjZrCqA//+LioCAAH7yAP//kVtAgAB6WYD//4u9YA==
Date: Tue, 16 Apr 2013 20:45:12 +0000
Message-ID: <b7c7793f69d845e38825899a1500d47e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1366139031-12518-1-git-send-email-haiyangz@microsoft.com>
	 <20130416.151141.1928940532005718606.davem@davemloft.net>
	 <57e8f99081a94575a57cae5e93705c22@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	 <20130416.154912.896506198616355113.davem@davemloft.net>
	 <b5d9b49f46ab434eb38a24e34f0b984b@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <1366144265.28609.10.camel@joe-AO722>
In-Reply-To: <1366144265.28609.10.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(51704004)(189002)(164054002)(13464002)(199002)(377424002)(24454001)(20776003)(51856001)(76482001)(56776001)(59766001)(56816002)(81342001)(47976001)(33646001)(47776003)(6806003)(4396001)(74502001)(44976003)(66066001)(65816001)(50466001)(31966008)(5343655001)(80022001)(16406001)(63696002)(77982001)(46102001)(54316002)(49866001)(79102001)(74662001)(46406003)(69226001)(47736001)(50986001)(81542001)(47446002)(54356001)(23726002)(53806001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUSR01MB601;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0818724663
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Tuesday, April 16, 2013 4:31 PM
> To: Haiyang Zhang
> Cc: David Miller; netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
> 
> On Tue, 2013-04-16 at 20:18 +0000, Haiyang Zhang wrote:
> > > From: David Miller [mailto:davem@davemloft.net] It works fine, but
> > > it's unclean.
> > > Keep the req_id type as "u64", because that's what it is, a 64-bit request
> ID.
> > I will make this update and submit a new patch, with the added comments.
> 
> Do you mean you'll use this to avoid compiler warnings?
> 
> 	req_id = (u64)(unsigned long)packet;

I will use:
req_id = (ulong)packet;

Assigning 32 bit integer to 64 bit variable is fine.

Thanks,
- Haiyang
