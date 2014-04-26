Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaDZCXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 22:23:43 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:44140
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaDZCXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 22:23:41 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Stephen Hemminger <stephen@networkplumber.org>
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
Thread-Index: AQHPYK69zRY2bKGNPUekzRg75l4abpsjD68AgAAbp+A=
Date: Sat, 26 Apr 2014 02:23:37 +0000
Message-ID: <a0635751695144d2a9fee5c9feb8cf5a@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1398451514-25593-1-git-send-email-kys@microsoft.com>
 <20140425174322.589ed9f1@samsung-9>
In-Reply-To: <20140425174322.589ed9f1@samsung-9>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2601:8:9b00:402:7d9e:a813:4d30:6320]
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(13464003)(24454002)(377454003)(51704005)(80022001)(74662001)(83072002)(50986999)(76176999)(76576001)(76482001)(74502001)(77096999)(31966008)(20776003)(2656002)(101416001)(83322001)(79102001)(87936001)(74316001)(86362001)(99286001)(81542001)(19580395003)(46102001)(80976001)(33646001)(99396002)(77982001)(92566001)(81342001)(4396001)(54356999)(86612001)(85852003)(19580405001)(24736002)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:8B9F4116.B1C387AA.33D393DC.90E5ABF8.201CD;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Stephen Hemminger [mailto:stephen@networkplumber.org]
> Sent: Friday, April 25, 2014 5:43 PM
> To: KY Srinivasan
> Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com; stable@kernel.org
> Subject: Re: [PATCH net-next 1/1] hyperv: Properly handle checksum offload
> 
> On Fri, 25 Apr 2014 11:45:14 -0700
> "K. Y. Srinivasan" <kys@microsoft.com> wrote:
> 
> > @@ -474,6 +477,9 @@ static int netvsc_start_xmit(struct sk_buff *skb,
> struct net_device *net)
> >  	csum_info = (struct ndis_tcp_ip_checksum_info *)((void *)ppi +
> >  			ppi->ppi_offset);
> >
> > +	ip_hdr(skb)->check = 0;
> > +	csum_info->transmit.ip_header_checksum = 1;
> > +
> >  	if (net_trans_info & (INFO_IPV4 << 16))
> >  		csum_info->transmit.is_ipv4 = 1;
> >  	else
> 
> Linux doesn't need or want IP checksum offload.
> It will not have any performance gain.

Thanks Stephen; I will  re-spin the patch and re-submit.

K. Y
