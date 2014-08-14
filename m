Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaHNVc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:32:57 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:39149 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932180AbaHNVcy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:32:54 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v2] hyperv: Increase the buffer length for
 netvsc_channel_cb()
Thread-Topic: [PATCH net-next,v2] hyperv: Increase the buffer length for
 netvsc_channel_cb()
Thread-Index: AQHPtyEABrnwbY+AyESxBlxt+dQx0ZvRFJgA//+LRMA=
Date: Thu, 14 Aug 2014 21:32:38 +0000
Message-ID: <bbf016f1772245a6a08f92ea8346b8ff@DFM-DB3MBX15-08.exchange.corp.microsoft.com>
References: <1407953024-35191-1-git-send-email-haiyangz@microsoft.com>
 <20140814.142856.1220870703473741209.davem@redhat.com>
In-Reply-To: <20140814.142856.1220870703473741209.davem@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454003)(164054003)(13464003)(51704005)(189002)(199003)(85306004)(106116001)(106466001)(86612001)(107046002)(110136001)(50986999)(99396002)(54356999)(76176999)(2656002)(81542001)(97756001)(92566001)(21056001)(97736001)(85852003)(83072002)(2009001)(83322001)(19580405001)(50466002)(46102001)(19580395003)(68736004)(6806004)(44976005)(46406003)(77982001)(87936001)(76482001)(84676001)(79102001)(81342001)(74502001)(80022001)(64706001)(4396001)(23726002)(33646002)(20776003)(584604001)(108616004)(74662001)(31966008)(66066001)(47776003)(142933001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=pass (sender IP is 131.107.147.100)
 smtp.mailfrom=haiyangz@microsoft.com; 
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@redhat.com]
> Sent: Thursday, August 14, 2014 5:29 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v2] hyperv: Increase the buffer length for
> netvsc_channel_cb()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Wed, 13 Aug 2014 18:03:44 +0000
> 
> > When the buffer is too small for a packet from VMBus, a bigger buffer
> will be
> > allocated in netvsc_channel_cb() and retry reading the packet from
> VMBus.
> > Increasing this buffer size will reduce the retry overhead.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: Dexuan Cui <decui@microsoft.com>
> ...
> > -	net_device = kzalloc(sizeof(struct netvsc_device), GFP_KERNEL);
> > +	net_device = vzalloc(sizeof(*net_device));
> 
> This isn't what I suggested that you do.
> 
> I said that the buffer inside of netvsc_device should be made an
> indirect pointer and thus allocated seperately.
> 
> Thus you're still kzalloc() net_device, but net_device->cb_buffer
> becomes "unsigned char *" and another allocation is made for it.

I will change the patch to this way.
Thanks,

- Haiyang

