Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3D2Sbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:31:50 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.92]:38210 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758372Ab3D2Sbt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:31:49 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Fix a compiler warning in netvsc_send()
Thread-Topic: [PATCH net-next] hyperv: Fix a compiler warning in
 netvsc_send()
Thread-Index: AQHOQqcXwPHi6RS5mUyvoQeajCPT8pjt+W8A//+P3PA=
Date: Mon, 29 Apr 2013 18:30:53 +0000
Message-ID: <2bef79e083dd4b14adc5e6d3549f8a05@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1367000755-2571-1-git-send-email-haiyangz@microsoft.com>
 <20130429.140932.1477434738582260564.davem@davemloft.net>
In-Reply-To: <20130429.140932.1477434738582260564.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.59.235.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.1.17;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(52604004)(189002)(199002)(51704004)(377454001)(164054002)(13464002)(31966008)(63696002)(65816001)(47776003)(23726002)(20776003)(79102001)(33646001)(50466002)(74662001)(53806001)(47446002)(74502001)(56776001)(44976003)(16406001)(81542001)(6806003)(46406003)(80022001)(54356001)(69226001)(81342001)(56816002)(77982001)(47976001)(46102001)(51856001)(50986001)(49866001)(74366001)(47736001)(4396001)(59766001)(76482001)(54316002)(66066001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2SR01MB593;H:hybrid.exchange.microsoft.com;RD:mail1.exchange.microsoft.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0831C25939
X-OriginatorOrg: DuplicateDomain-b1291ffc-369c-4c2a-9225-e2908f70a426.microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, April 29, 2013 2:10 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Fix a compiler warning in
> netvsc_send()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Fri, 26 Apr 2013 11:25:55 -0700
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
> Applied, but:
> 
> > -		req_id = (u64)packet;
> > +		req_id = (ulong)packet;
> 
> I really do not like these shorthands for fundamental C types, we generally
> do not use "ulong", "uint" etc.  Please expand them out explicitly to
> "unsigned long", "unsigned int", etc.

Thanks for applying it. 

Going forward, I will use the long format, like "unsigned long", instead of "ulong", etc.

Thanks,
- Haiyang

