Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaHSVaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 17:30:00 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.27]:4647 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbaHSV37 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 17:29:59 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>, KY Srinivasan <kys@microsoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Thread-Topic: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Thread-Index: AQHPu6pLRTtWHSK0fUa2cFRSCNYsCZvYb1iA
Date: Tue, 19 Aug 2014 21:29:44 +0000
Message-ID: <8dcf334714c44eeda54ecb129479719b@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20140819123655.GC12160@sucs.org>
In-Reply-To: <20140819123655.GC12160@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019006)(377454003)(164054003)(189002)(51914003)(13464003)(51704005)(199003)(92566001)(2656002)(6806004)(54356999)(50466002)(74662001)(31966008)(99396002)(76176999)(50986999)(4396001)(106116001)(77096999)(46102001)(107046002)(85852003)(74502001)(87936001)(97736001)(83072002)(86612001)(84676001)(108616004)(83322001)(68736004)(19580395003)(21056001)(80022001)(66066001)(81342001)(79102001)(46406003)(85306004)(20776003)(81542001)(2009001)(23726002)(19580405001)(44976005)(97756001)(64706001)(106466001)(33646002)(77982001)(1511001)(76482001)(2421001)(47776003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:CH1SR01MB599;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
Authentication-Results: spf=pass (sender IP is 131.107.159.99)
 smtp.mailfrom=haiyangz@microsoft.com; 
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Tuesday, August 19, 2014 8:37 AM
> To: KY Srinivasan
> Cc: Greg Kroah-Hartman; Haiyang Zhang; devel@linuxdriverproject.org;
> linux-kernel@vger.kernel.org; Jason Wang; Daniel Borkmann; David S.
> Miller; netdev@vger.kernel.org
> Subject: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
> 
> Now we get to the issue I've been meaning to report: changing the MTU of
> a Hyper-V network interface while traffic is flowing through it triggers
> a BUG. I've seen this happen on a variety of kernels but the trace below
> is from 3.17.0-rc1.
> 
> Steps to reproduce:
> (Guests were customised Fedora 20 cloud images)
> 1.On Hyper-V VM 1 run
> iperf -s
> 2. On Hyper-V VM 2 run
> iperf -c <Hyper-V VM 1 host address> -t 200
> 3. On Hyper-V VM 2 run
> ip link set dev eth0 mtu 9000
> 
> Expected results:
> MTU of eth0 to be changed, packets to keep flowing or stop, interface to
> be at alive enough to be reconfigured.
> 
> Actual results:
> Error messages on the console, eth0 winds up dead.
> 

Thanks for the report.
I tried changing mtu while iperf is running, but unable to reproduce it.
I repeated the changing MTU test 10+ times, the link is stable, and passing 
traffic at ~8Gbps.

Could you try a Distro without customization?
I just want to narrow down the possible causes for it.

Thanks,
- Haiyang

