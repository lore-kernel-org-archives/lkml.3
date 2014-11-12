Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaKLUbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 15:31:39 -0500
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.94]:48476 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbaKLUbh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 15:31:37 -0500
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
Thread-Index: AQHP/f2e9z8vhEln9EShH6jS5e5RMpxd7OIA//977iCAAIkFgP//gSIg
Date: Wed, 12 Nov 2014 20:31:17 +0000
Message-ID: <c01728acfd564d779c1612539c65839e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1415748472-27463-1-git-send-email-haiyangz@microsoft.com>
	<20141112.144640.703336197189868183.davem@davemloft.net>
	<ecc2fd8e646147fabb30d3120c889431@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20141112.150423.1660890641226643870.davem@davemloft.net>
In-Reply-To: <20141112.150423.1660890641226643870.davem@davemloft.net>
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
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(189002)(51704005)(199003)(377454003)(164054003)(13464003)(107046002)(6806004)(84676001)(106116001)(87936001)(92566001)(50466002)(106466001)(76176999)(54356999)(50986999)(68736004)(97756001)(31966008)(66066001)(44976005)(19580405001)(19580395003)(86612001)(20776003)(47776003)(21056001)(64706001)(46102003)(584604001)(93886004)(99396003)(77096003)(110136001)(77156002)(46406003)(2656002)(62966003)(97736003)(4396001)(120916001)(108616004)(23726002)(33646002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;FPR:;SPF:Pass;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2SR01MB592;
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
> Sent: Wednesday, November 12, 2014 3:04 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Add processing of MTU reduced by
> the host
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Wed, 12 Nov 2014 20:02:11 +0000
> 
> > The Hyper-V host doesn't support MTU below 1500. If we try setting MTU
> to a
> > value < 1500, the host will use 1500 automatically and return 1500 in
> the
> > RNDIS_OID_GEN_MAXIMUM_FRAME_SIZE query and guest will also use it.
> That's
> > why I set the lower limit to ETH_DATA_LEN.
> >
> > Are you suggesting that we keep the 68 as the lower limit, and let the
> host
> > auto-reset it to 1500 when we trying to set an MTU < 1500?
> 
> Then you need to add a comment, because without any information or
> context that change looks wrong.

I will add a comment.
Thanks,
- Haiyang
