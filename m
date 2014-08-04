Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaHDWfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:35:11 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.28]:20941 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbaHDWfJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:35:09 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
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
Thread-Index: AQHPsBJfYkL6q23hfEu1qEkKi4J9ypvBdoEA//+R2/A=
Date: Mon, 4 Aug 2014 22:34:55 +0000
Message-ID: <14d84b7541894b16badd0513f581361a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1407180825-21832-1-git-send-email-haiyangz@microsoft.com>
 <20140804.150842.507300261765977637.davem@davemloft.net>
In-Reply-To: <20140804.150842.507300261765977637.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(199002)(189002)(164054003)(51704005)(13464003)(46406003)(31966008)(77982001)(74662001)(23726002)(74502001)(50466002)(86612001)(2009001)(97736001)(97756001)(4396001)(85852003)(83072002)(92566001)(99396002)(81342001)(64706001)(47776003)(20776003)(21056001)(79102001)(66066001)(80022001)(81542001)(84676001)(68736004)(87936001)(2656002)(44976005)(6806004)(19580405001)(83322001)(19580395003)(54356999)(77096999)(106466001)(85306004)(110136001)(76176999)(584604001)(33646002)(46102001)(107046002)(106116001)(76482001)(50986999)(24736002)(108616003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB589;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0293D40691
Authentication-Results: spf=pass (sender IP is 131.107.159.99)
 smtp.mailfrom=haiyangz@microsoft.com; 
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, August 4, 2014 6:09 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Increase the buffer length for
> netvsc_channel_cb()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon,  4 Aug 2014 12:33:45 -0700
> 
> > When the buffer is too small for a packet from VMBus, a bigger buffer
> > will be allocated in netvsc_channel_cb() and retry reading the packet from
> VMBus.
> > Increasing this buffer size will reduce the retry overhead.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: Dexuan Cui <decui@microsoft.com>
> 
> Now netvsc_device is significantly larger than a page, you should probably
> therefore allocate netvsc_device->cb_buffer indirectly instead of inlining it into
> the structure.

I will make this update.
Thanks,
- Haiyang

