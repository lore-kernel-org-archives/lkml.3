Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaKLUC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:02:29 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.26]:9886 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbaKLUC1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:02:27 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Add processing of MTU reduced by the
 host
Thread-Topic: [PATCH net-next] hyperv: Add processing of MTU reduced by the
 host
Thread-Index: AQHP/f2e9z8vhEln9EShH6jS5e5RMpxd7OIA//977iA=
Date: Wed, 12 Nov 2014 20:02:11 +0000
Message-ID: <ecc2fd8e646147fabb30d3120c889431@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1415748472-27463-1-git-send-email-haiyangz@microsoft.com>
 <20141112.144640.703336197189868183.davem@davemloft.net>
In-Reply-To: <20141112.144640.703336197189868183.davem@davemloft.net>
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
Authentication-Results: spf=pass (sender IP is 131.107.159.99)
 smtp.mailfrom=haiyangz@microsoft.com; aepfle.de; dkim=none (message not
 signed) header.d=none;aepfle.de; dmarc=pass action=none
 header.from=microsoft.com;
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(51704005)(189002)(13464003)(199003)(377454003)(164054003)(19580395003)(87936001)(19580405001)(6806004)(20776003)(47776003)(44976005)(68736004)(4396001)(46102003)(84676001)(76176999)(50986999)(46406003)(54356999)(23726002)(106116001)(97756001)(107046002)(86612001)(92566001)(106466001)(31966008)(120916001)(97736003)(584604001)(21056001)(66066001)(99396003)(77096003)(77156002)(62966003)(2656002)(50466002)(64706001)(108616004)(33646002)(110136001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;FPR:;SPF:Pass;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2SR01MB594;
X-DmarcAction: None
X-DmarcStatus: Passed
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03932714EB
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, November 12, 2014 2:47 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add processing of MTU reduced by
> the host
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Tue, 11 Nov 2014 15:27:52 -0800
> 
> > -	if (mtu < 68 || mtu > limit)
> > +	if (mtu < ETH_DATA_LEN || mtu > limit)
> >  		return -EINVAL;
> 
> This is not correct.
> 
> The test is against the minimally supported MTU, which should
> be 68 not ETH_DATA_LEN which is 1500.

The Hyper-V host doesn't support MTU below 1500. If we try setting MTU to a 
value < 1500, the host will use 1500 automatically and return 1500 in the 
RNDIS_OID_GEN_MAXIMUM_FRAME_SIZE query and guest will also use it. That's 
why I set the lower limit to ETH_DATA_LEN.

Are you suggesting that we keep the 68 as the lower limit, and let the host 
auto-reset it to 1500 when we trying to set an MTU < 1500?

Thanks,
- Haiyang

