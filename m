Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaCSVgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:36:35 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.89]:18432 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754769AbaCSVgd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:36:33 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v3] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v3] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Index: AQHPQvA3i6jhPyi/W0GqyTDg4sVVHZrpVkmA//+ZWUA=
Date: Wed, 19 Mar 2014 21:36:24 +0000
Message-ID: <96538481deb64ee0a7fd511bedfa1d55@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1395180922-2776-1-git-send-email-haiyangz@microsoft.com>
 <20140319.164005.1815461875771862691.davem@davemloft.net>
In-Reply-To: <20140319.164005.1815461875771862691.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(199002)(189002)(164054003)(13464003)(54356001)(76482001)(46406003)(53806001)(69226001)(81686001)(87266001)(44976005)(83322001)(87936001)(50466002)(6806004)(81816001)(2656002)(74706001)(74876001)(23726002)(81342001)(81542001)(80976001)(74662001)(95666003)(90146001)(56816005)(85852003)(92566001)(83072002)(93136001)(65816001)(79102001)(51856001)(93516002)(97756001)(97736001)(2009001)(20776003)(47776003)(63696002)(76786001)(76796001)(97186001)(97336001)(77982001)(46102001)(54316002)(80022001)(59766001)(56776001)(74366001)(31966008)(74502001)(47446002)(33646001)(95416001)(50986001)(4396001)(94316002)(66066001)(85306002)(47976001)(47736001)(49866001)(86612001)(94946001)(84676001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2SR01MB596;H:hybrid.exchange.microsoft.com;FPR:BC197825.CB018C6.C960AFCC.82E0EF70.20137;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 01559F388D
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> > +
> > +
> > +/* ndis_recv_scale_cap/cap_flag */
> 
> One empty line is sufficient, we don't need two of them here.

I will fix this and other formats you pointed out below, also check the whole patch 
for similar issues.

> > -	net = alloc_etherdev(sizeof(struct net_device_context));
> > +	net = alloc_etherdev_mq(sizeof(struct net_device_context),
> > +				num_online_cpus());
> >  	if (!net)
> >  		return -ENOMEM;
> >
> 
> num_online_cpus() can change, will your driver accomodate this?

HyperV currently doesn't support hot-add/remove cpu, so this is constant for 
this driver.

Thanks,
- Haiyang
