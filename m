Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbaDUVBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:01:34 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.24]:16434 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730AbaDUVB2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:01:28 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,1/2] hyperv: Remove recv_pkt_list and lock
Thread-Topic: [PATCH net-next,1/2] hyperv: Remove recv_pkt_list and lock
Thread-Index: AQHPXY/xumFvj3QrMEaEA/ZrEiw1oZsc4TmA//+s6xA=
Date: Mon, 21 Apr 2014 21:00:52 +0000
Message-ID: <2deafebb39844bc49b22695ae2c9df86@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1398108376-4857-1-git-send-email-haiyangz@microsoft.com>
 <20140421.145711.1903592201158395025.davem@davemloft.net>
In-Reply-To: <20140421.145711.1903592201158395025.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(377454003)(51704005)(13464003)(199002)(189002)(164054003)(54316003)(49866002)(47446003)(76796001)(93516002)(54356002)(51856002)(79102001)(93136001)(92566001)(65816002)(47976003)(63696004)(56776002)(56816006)(4396001)(47736002)(59766002)(69226001)(86612001)(94946001)(76786001)(95416001)(94316002)(47776003)(20776003)(46102001)(33646001)(66066001)(80022001)(74366001)(80976001)(81686001)(81816001)(74876001)(74706001)(50466002)(46406003)(6806004)(19580405001)(19580395003)(83322001)(44976005)(87936001)(87266001)(2656002)(85852003)(83072002)(77982001)(90146001)(81342001)(85306002)(81542001)(84676001)(74662001)(31966008)(74502001)(97186001)(76482001)(23726002)(98676001)(95666003)(99396002)(53806002)(50986002)(97736001)(2009001)(97756001)(97336001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB601;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0188D66E61
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Monday, April 21, 2014 2:57 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,1/2] hyperv: Remove recv_pkt_list and lock
> 
> From: Haiyang Zhang <haiyangz@microsoft.com>
> Date: Mon, 21 Apr 2014 12:26:15 -0700
> 
> > @@ -401,8 +401,6 @@ static void rndis_filter_receive_data(struct
> rndis_device *dev,
> >  	pkt->total_data_buflen = rndis_pkt->data_len;
> >  	pkt->data = (void *)((unsigned long)pkt->data + data_offset);
> >
> > -	pkt->is_data_pkt = true;
> > -
> >  	vlan = rndis_get_ppi(rndis_pkt, IEEE_8021Q_INFO);
> >  	if (vlan) {
> >  		pkt->vlan_tci = VLAN_TAG_PRESENT | vlan->vlanid |
> 
> This part of your change is not explained at all in your commit message.
> 
> Please resubmit this series with this hunk properly described and accounted for.

I have updated the description and re-send them.

Thanks,
- Haiyang
