Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaHEUNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:13:31 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.28]:5301 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbaHEUM5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:12:57 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>,
        "thomas1206@gmail.com" <thomas1206@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Increase the buffer length for
 netvsc_channel_cb()
Thread-Topic: [PATCH net-next] hyperv: Increase the buffer length for
 netvsc_channel_cb()
Thread-Index: AQHPraEjItLxWQoaZUy0OnkN6ZFqBpvC6tAA//+MO4A=
Date: Tue, 5 Aug 2014 20:12:42 +0000
Message-ID: <8fc1fe81db1b450685921f9ea97f8477@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1406908530-22667-1-git-send-email-haiyangz@microsoft.com>
 <20140805.130346.2080401893280146356.davem@davemloft.net>
In-Reply-To: <20140805.130346.2080401893280146356.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(164054003)(51704005)(377454003)(13464003)(199002)(189002)(46102001)(76482001)(23726002)(85852003)(84676001)(77982001)(74662001)(80022001)(31966008)(74502001)(4396001)(50466002)(92566001)(87936001)(66066001)(81342001)(68736004)(99396002)(107046002)(46406003)(21056001)(106466001)(50986999)(76176999)(54356999)(77096999)(106116001)(2656002)(19580395003)(47776003)(20776003)(79102001)(86612001)(85306004)(83072002)(44976005)(81542001)(2009001)(97736001)(97756001)(64706001)(83322001)(19580405001)(6806004)(33646002)(24736002)(108616003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH1SR01MB600;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=pass (sender IP is 131.107.159.99)
 smtp.mailfrom=haiyangz@microsoft.com; 
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, August 5, 2014 4:04 PM
> To: thomas1206@gmail.com
> Cc: netdev@vger.kernel.org; Haiyang Zhang; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Increase the buffer length for
> netvsc_channel_cb()
> 
> From: Haiyang Zhang <thomas1206@gmail.com>
> Date: Fri,  1 Aug 2014 15:55:30 +0000
> 
> > When the buffer is too small for a packet from VMBus, a bigger buffer
> will be
> > allocated in netvsc_channel_cb() and retry reading the packet from
> VMBus.
> > Increasing this buffer size will reduce the retry overhead.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: Dexuan Cui <decui@microsoft.com>
> 
> I'm not applying this, sorry.
> 
> I said that because the structure that contains this buffer is now
> larger than a page, you should allocate the CB buffer externally
> via another kmalloc() or via the page allocator.

This must have been re-sent accidentally when we are updating our 
Email server... I will update the patch and re-submit it soon.

Thanks,
- Haiyang

