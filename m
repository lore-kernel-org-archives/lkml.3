Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaCUTOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 15:14:36 -0400
Received: from [64.4.22.91] ([64.4.22.91]:50053 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750785AbaCUTOb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 15:14:31 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Topic: [PATCH net-next,v4] hyperv: Add support for virtual Receive
 Side Scaling (vRSS)
Thread-Index: AQHPRIRp2+tv4l9QfEGdVn3+gbBu6prsWQWAgAABaoD//459QA==
Date: Fri, 21 Mar 2014 19:12:43 +0000
Message-ID: <84837c9e73f24bcd8f652a24f616ff1e@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1395354521-12632-1-git-send-email-haiyangz@microsoft.com>
	<20140321.144957.550032279989990583.davem@davemloft.net>
 <20140321.145501.2003616654661701935.davem@davemloft.net>
In-Reply-To: <20140321.145501.2003616654661701935.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="iso-8859-7"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(199002)(189002)(51704005)(13464003)(164054003)(377454003)(33646001)(74502001)(47446002)(31966008)(53806001)(81816001)(74662001)(65816001)(74366001)(49866001)(54356001)(50986001)(47976001)(76786001)(47736001)(76796001)(97336001)(15202345003)(2656002)(87936001)(76482001)(95666003)(95416001)(93516002)(6806004)(80022001)(81686001)(66066001)(2009001)(97736001)(86612001)(97186001)(81542001)(93136001)(46102001)(51856001)(69226001)(74706001)(94316002)(63696002)(20776003)(85306002)(85852003)(80976001)(575784001)(79102001)(90146001)(56816005)(92566001)(94946001)(81342001)(47776003)(50466002)(19580395003)(59766001)(77982001)(15975445006)(4396001)(84676001)(87266001)(74876001)(54316002)(83072002)(83322001)(98676001)(56776001)(44976005)(19580405001)(142933001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB606;H:hybrid.exchange.microsoft.com;FPR:7D52C69E.3CC2978A.4BF43F5F.A2E5EB8D.202DF;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BULK:None;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:(2001)
X-Forefront-PRVS: 0157DEB61B
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Friday, March 21, 2014 2:55 PM
> To: Haiyang Zhang
> Cc: netdev@vger.kernel.org; KY Srinivasan; olaf@aepfle.de;
> jasowang@redhat.com; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next,v4] hyperv: Add support for virtual Receive
> Side Scaling (vRSS)
> 
> From: David Miller <davem@davemloft.net>
> Date: Fri, 21 Mar 2014 14:49:57 -0400 (EDT)
> 
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> > Date: Thu, 20 Mar 2014 15:28:41 -0700
> >
> >> This feature allows multiple channels to be used by each virtual NIC.
> >> It is available on Hyper-V host 2012 R2.
> >>
> >> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> >> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> >
> > Applied, thanks.
> 
> Actually I had to revert, this doesn't even compile.
> 
> drivers/net/hyperv/netvsc.c: In function ¡netvsc_channel_cb¢:
> drivers/net/hyperv/netvsc.c:891:2: error: implicit declaration of
> function ¡get_per_channel_state¢ [-Werror=implicit-function-declaration]
> drivers/net/hyperv/netvsc.c:891:9: warning: assignment makes pointer
> from integer without a cast [enabled by default]
> drivers/net/hyperv/netvsc.c: In function ¡netvsc_device_add¢:
> drivers/net/hyperv/netvsc.c:998:2: error: implicit declaration of
> function ¡set_per_channel_state¢ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/net/hyperv/netvsc.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> drivers/net/hyperv/rndis_filter.c: In function ¡netvsc_sc_open¢:
> drivers/net/hyperv/rndis_filter.c:988:2: error: implicit declaration of
> function ¡set_per_channel_state¢ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[3]: *** [drivers/net/hyperv/rndis_filter.o] Error 1
> make[2]: *** [drivers/net/hyperv] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2

The per channel state variable and functions are defined by this patch,
which has been applied on 2/07:
Drivers: hv: vmbus: Support per-channel driver state
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=8a7206a89f85c8439561b0eff85bb9440a2e97a9

Could it be merged into net-next tree?

Thanks,
- Haiyang

