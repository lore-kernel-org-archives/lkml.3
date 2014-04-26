Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaDZCYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 22:24:48 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:18186
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaDZCYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 22:24:17 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stable@kernel.org" <stable@kernel.org>
Subject: RE: [PATCH net-next 1/1]  hyperv: Properly handle checksum offload
Thread-Topic: [PATCH net-next 1/1]  hyperv: Properly handle checksum offload
Thread-Index: AQHPYK69zRY2bKGNPUekzRg75l4abpsjD68AgAAI94CAABMRYA==
Date: Sat, 26 Apr 2014 02:24:14 +0000
Message-ID: <ab8c51e4f124498486104a4a25514dea@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1398451514-25593-1-git-send-email-kys@microsoft.com>
	 <20140425174322.589ed9f1@samsung-9>
 <1398474927.29914.100.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1398474927.29914.100.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:7d9e:a813:4d30:6320]
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(24454002)(13464003)(377424004)(377454003)(199002)(189002)(86362001)(92566001)(77982001)(76482001)(86612001)(83322001)(19580395003)(19580405001)(20776003)(87936001)(80976001)(74316001)(99286001)(33646001)(81542001)(46102001)(101416001)(99396002)(83072002)(85852003)(81342001)(4396001)(54356999)(31966008)(74502001)(74662001)(77096999)(76576001)(2656002)(79102001)(80022001)(76176999)(50986999)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:BF9F4216.B182E72A.33D3939C.82E5ABF8.201FA;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3Q2PJRl011843



> -----Original Message-----
> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
> Sent: Friday, April 25, 2014 6:15 PM
> To: Stephen Hemminger
> Cc: KY Srinivasan; davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; stable@kernel.org
> Subject: Re: [PATCH net-next 1/1] hyperv: Properly handle checksum offload
> 
> On Fri, 2014-04-25 at 17:43 -0700, Stephen Hemminger wrote:
> > On Fri, 25 Apr 2014 11:45:14 -0700
> > "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> >
> > > @@ -474,6 +477,9 @@ static int netvsc_start_xmit(struct sk_buff *skb,
> struct net_device *net)
> > >  	csum_info = (struct ndis_tcp_ip_checksum_info *)((void *)ppi +
> > >  			ppi->ppi_offset);
> > >
> > > +	ip_hdr(skb)->check = 0;
> > > +	csum_info->transmit.ip_header_checksum = 1;
> > > +
> > >  	if (net_trans_info & (INFO_IPV4 << 16))
> > >  		csum_info->transmit.is_ipv4 = 1;
> > >  	else
> >
> > Linux doesn't need or want IP checksum offload.
> > It will not have any performance gain.
> 
> 
> BTW, was this patch even tested with IPv6 packets ???

No; I only tested this on ipv4.

K. Y
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
