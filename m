Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbaJNWVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:21:10 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.92]:11460 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536AbaJNWVG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:21:06 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2014 18:21:05 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v2] hyperv: Add handling of IP header with option
 field in netvsc_set_hash()
Thread-Topic: [PATCH net-next,v2] hyperv: Add handling of IP header with
 option field in netvsc_set_hash()
Thread-Index: AQHP5/M7qLpafzYgIkqP3nQ3CZfSI5wwk3+A//+NOkA=
Date: Tue, 14 Oct 2014 21:47:33 +0000
Message-ID: <e660408eec9a48f088ae8a99036e223e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1413324988-8863-1-git-send-email-haiyangz@microsoft.com>
 <20141014.173717.1412701736631211553.davem@davemloft.net>
In-Reply-To: <20141014.173717.1412701736631211553.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(377454003)(199003)(13464003)(189002)(51704005)(85306004)(80022003)(76482002)(50986999)(77096999)(106116001)(54356999)(2009001)(97756001)(108616004)(107046002)(99396003)(46406003)(64706001)(33646002)(97736003)(19580405001)(584604001)(76176999)(46102003)(110136001)(120916001)(47776003)(106466001)(44976005)(20776003)(4396001)(2656002)(6806004)(19580395003)(23726002)(50466002)(92566001)(85852003)(86612001)(68736004)(84676001)(31966008)(66066001)(87936001)(21056001)(142933001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH1SR01MB599;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CH1SR01MB599;
X-Forefront-PRVS: 03648EFF89
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Tuesday, October 14, 2014 5:37 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v2] hyperv: Add handling of IP header with option
> field in netvsc_set_hash()
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 14 Oct 2014 15:16:28 -0700
> 
> > In case that the IP header has optional field at the end, this patch
> > will get the port numbers after that field, and compute the hash.
> >
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> Instead of adding hack after hack after hack to your internal header parser, just
> use the generic flow dissector we already have in the kernel to fetch out the
> values you need.
> 
> __skb_flow_get_ports() etc.

Thanks. I will update the patch.

- Haiyang

