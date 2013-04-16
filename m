Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935798Ab3DPTgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 15:36:53 -0400
Received: from [64.4.22.87] ([64.4.22.87]:55130 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935301Ab3DPTgv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 15:36:51 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Topic: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Index: AQHOOtDW1pnjd9tR6kuWeKoviY/WAZjZrCqA//+LioA=
Date: Tue, 16 Apr 2013 19:34:52 +0000
Message-ID: <57e8f99081a94575a57cae5e93705c22@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1366139031-12518-1-git-send-email-haiyangz@microsoft.com>
 <20130416.151141.1928940532005718606.davem@davemloft.net>
In-Reply-To: <20130416.151141.1928940532005718606.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.27;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(377454001)(164054002)(189002)(13464002)(51704004)(47736001)(69226001)(5343635001)(50986001)(44976003)(81542001)(50466001)(23726002)(53806001)(79102001)(54356001)(20776003)(63696002)(76482001)(49866001)(46102001)(33646001)(77982001)(56816002)(46406003)(59766001)(31966008)(47776003)(74502001)(65816001)(51856001)(47976001)(80022001)(74662001)(54316002)(16406001)(56776001)(66066001)(4396001)(47446002)(81342001)(5343655001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUSR01MB603;H:hybrid.exchange.microsoft.com;RD:mail7.exchange.microsoft.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0818724663
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net] 
> Sent: Tuesday, April 16, 2013 3:12 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de; jasowang@redhat.com; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
>
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 16 Apr 2013 12:03:51 -0700
>
> > Fixed: warning: cast from pointer to integer of different size
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
>
> If you're coding pointers into request IDs you better make that explicit and add lots of comments explaining 
> why that's OK and why it's going to work  fine in these circumstances.

> I'm not applying this patch, it just makes a bad situation even worse.  Either your request IDs are 64-bit or they are not, it can't be both.

The Hyper-V hosts always use 64 bit request id. The guests can have 32 or 64 bit pointers which equal to
the ulong type size. So we cast it to ulong type. And, assigning 32bit integer to 64 bit variable works fine.

Actually, before the recent patch (f1ea3cd7011), the packet pointer was casted to ulong. And this patch
restore the same type casting as the old code.

The VMBus returns the same id in the completion packet. But the value has no effect on the host side.

Does these comments sound good?

Thanks,
- Haiyang

