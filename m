Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaCFU3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:29:31 -0500
Received: from mail-bl2lp0208.outbound.protection.outlook.com ([207.46.163.208]:35250
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751645AbaCFU33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:29:29 -0500
From: KY Srinivasan <kys@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 5/6] Drivers: net: hyperv: Enable send side checksum
 offload
Thread-Topic: [PATCH 5/6] Drivers: net: hyperv: Enable send side checksum
 offload
Thread-Index: AQHPOSXAeuFZD13w702cUMpvVwQqYZrUc7kAgAAOQLA=
Date: Thu, 6 Mar 2014 20:29:13 +0000
Message-ID: <d51892af73814794972736463a686a09@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-1-git-send-email-kys@microsoft.com>
	<1394104390-23477-5-git-send-email-kys@microsoft.com>
 <20140306.143354.1296864763659469552.davem@davemloft.net>
In-Reply-To: <20140306.143354.1296864763659469552.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.192.117.251]
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(13464003)(377454003)(69226001)(4396001)(93516002)(575784001)(86362001)(53806001)(63696002)(83322001)(19580405001)(83072002)(74706001)(85852003)(33646001)(90146001)(19580395003)(50986001)(74662001)(74502001)(81342001)(47976001)(87936001)(94946001)(56776001)(74876001)(56816005)(49866001)(86612001)(95416001)(47736001)(97336001)(94316002)(54356001)(31966008)(85306002)(92566001)(74366001)(46102001)(47446002)(2656002)(51856001)(93136001)(76482001)(54316002)(87266001)(97186001)(59766001)(77982001)(95666003)(79102001)(74316001)(81816001)(81686001)(76576001)(66066001)(76786001)(81542001)(76796001)(80976001)(80022001)(65816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB597;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:117.192.117.251;FPR:B6DFC366.BC058F1A.89F07BBC.52D159C9.20203;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, March 7, 2014 1:04 AM
> To: KY Srinivasan
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 5/6] Drivers: net: hyperv: Enable send side checksum
> offload
> 
> From: "K. Y. Srinivasan" <kys@microsoft.com>
> Date: Thu,  6 Mar 2014 03:13:09 -0800
> 
> > +bool get_net_transport_info(struct sk_buff *skb, bool *is_v4,
> > +				bool *is_tcp, bool *is_udp, u32 *trans_off) {
> 
> Returning so many values like this is awkward, at best.
> 
> Why not return a well defined bitmask:
> 
> #define TRANSPORT_INFO_SUCCESS	0x00000001
> #define TRANSPORT_INFO_TCP	0x00000002
> #define TRANSPORT_INFO_UDP	0x00000004
> 
> Then the only value you have to return by reference is trans_off.

I also need information on the IP version as well. If it is ok with you, I will use the return
value to get information on the network protocol and return information on transport via
reference - protocol and the offset.
 
Regards,

K. Y
