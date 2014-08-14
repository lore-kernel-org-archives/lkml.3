Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaHNFTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:19:44 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:36697
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752397AbaHNFTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:19:42 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dan Williams <dcbw@redhat.com>, Tom Gundersen <teg@jklm.no>
CC: Greg KH <gregkh@linuxfoundation.org>, "olaf@aepfle.de" <olaf@aepfle.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Shao <huishao@microsoft.com>,
        "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>,
        "David Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPtvjIPhEL67KcgEyrC05hY1bPqZvOiMIAgAEG6aA=
Date: Thu, 14 Aug 2014 05:19:12 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99293C4@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
	 <53CCD6F2.6020909@nod.at> <20140721091851.GA28171@aepfle.de>
	 <20140721.143225.2040366896972949930.davem@davemloft.net>
	 <CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
	 <EE124450C0AAF944A40DD71E61F878C99149D0@SINEX14MBXC417.southpacific.corp.microsoft.com>
	 <20140808033220.GB10503@kroah.com>
	 <EE124450C0AAF944A40DD71E61F878C991569A@SINEX14MBXC417.southpacific.corp.microsoft.com>
	 <20140808134549.GD4427@kroah.com>
	 <EE124450C0AAF944A40DD71E61F878C991B653@SINEX14MBXC417.southpacific.corp.microsoft.com>
	 <CAG-2HqVE8Qk0pcW+36f44RkE-Kbp+qPqRT+vgg-v35W52bsKgg@mail.gmail.com>
	 <EE124450C0AAF944A40DD71E61F878C9921258@SINEX14MBXC417.southpacific.corp.microsoft.com>
	 <CAG-2HqWZtOk=mnsaAh5-zpWG-fv=Omq43GV9dMKHNfr1xEFQTw@mail.gmail.com>
 <1407936888.1825.0.camel@dcbw.local>
In-Reply-To: <1407936888.1825.0.camel@dcbw.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.91]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(51704005)(13464003)(164054003)(199003)(92726001)(106466001)(77982001)(2656002)(54356999)(99396002)(84676001)(95666004)(80022001)(55846006)(86362001)(87936001)(23676002)(76482001)(92566001)(81342001)(79102001)(85852003)(26826002)(4396001)(81542001)(68736004)(69596002)(85306004)(77096002)(93886004)(74502001)(50466002)(107046002)(81156004)(21056001)(6806004)(74662001)(44976005)(31966008)(106116001)(97736001)(85806002)(50986999)(83072002)(47776003)(46102001)(33656002)(76176999)(20776003)(64706001)(16796002)(86612001)(83322001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB618;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7E5JpnL025885

> -----Original Message-----
> From: Dan Williams
> > > e.g., on a bare metal host with Ubuntu 14.04, when I plug the RJ45 cable
> > > out of the network card and then plug the cable back into the network card
> > > quickly -- in ~3 seconds, networkd doesn't trigger DHCP renew request: in
> > > /var/log/syslog, we see
> > > Aug 12 11:07:07 decui-lin NetworkManager[828]: <info> (eth0): carrier
> now OFF (device state 100, deferring action for 4 seconds)
> > > Aug 12 11:07:07 decui-lin kernel: [  246.975453] e1000e: eth0 NIC Link is
> Down
> > > Aug 12 11:07:10 decui-lin NetworkManager[828]: <info> (eth0): carrier
> now ON (device state 100)
> > > Aug 12 11:07:10 decui-lin kernel: [  250.028533] e1000e: eth0 NIC Link is
> Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
> > >
> > > It looks there is a delay of 4s.
> > > I'm going to find out if there is a configurable parameter for this.
> >
> > Just to avoid any confusion: you are referring to "networkd" (and so
> > did my comments), but the above logs are from "NetworkManager".
> 
> And yes, NM does have a 4-second delay before processing a carrier down
> event, and NM currently does not renew DHCP on link changes, but that's
> certainly something we can/should change.
> 
> Dan

Hi Tom, Dan,
Thanks a lot for the clarification!
So the 4s delay comes from NM rather than networkd.

Thanks,
-- Dexuan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
