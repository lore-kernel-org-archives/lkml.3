Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab3DSU6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:58:05 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.88]:49841 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932301Ab3DSU6D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:58:03 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Topic: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
Thread-Index: AQHOOu0XxWIw/Ln6o02/aZYcK+XlL5jefnAA//+L/AA=
Date: Fri, 19 Apr 2013 20:57:24 +0000
Message-ID: <81a2f14c2a3d4436b713bc4ca4a79cfa@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1366151150-14859-1-git-send-email-haiyangz@microsoft.com>
 <20130419.165006.1200833792933507239.davem@davemloft.net>
In-Reply-To: <20130419.165006.1200833792933507239.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(164054002)(377454001)(13464002)(51704004)(189002)(199002)(81342001)(46102001)(54316002)(56776001)(50986001)(56816002)(46406003)(47736001)(81542001)(53806001)(47976001)(77982001)(44976003)(69226001)(59766001)(6806003)(31966008)(74662001)(76482001)(50466001)(20776003)(47776003)(63696002)(51856001)(23726002)(79102001)(66066001)(65816001)(80022001)(47446002)(74502001)(16406001)(54356001)(49866001)(4396001)(33646001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:CH1SR01MB612;H:hybrid.exchange.microsoft.com;RD:mail1.exchange.microsoft.com;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 08213D42D3
X-OriginatorOrg: DuplicateDomain-7923a859-03c9-4312-a77c-440aa45aaf52.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, April 19, 2013 4:50 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net] hyperv: Fix a compiler warning in netvsc_send()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 16 Apr 2013 15:25:50 -0700
> 
> > Fixed: warning: cast from pointer to integer of different size
> >
> > The Hyper-V hosts always use 64 bit request id. The guests can have 32
> > or 64 bit pointers which equal to the ulong type size. So we cast it to ulong
> type.
> > And, assigning 32bit integer to 64 bit variable works fine.
> >
> > The VMBus returns the same id in the completion packet. But the value
> > has no effect on the host side.
> >
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Such build warning fixes are not appropriate for 'net' at this time, and this
> patch does not apply to 'net-next', so I'm dropping this entirely.

OK. I will re-submit it to net-next after the recent patch causing the warning
is merged into the net-next tree.

Thanks,
- Haiyang

