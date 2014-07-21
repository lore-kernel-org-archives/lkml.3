Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaGUIIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:08:30 -0400
Received: from [207.46.163.212] ([207.46.163.212]:34335 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210AbaGUII1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:08:27 -0400
From: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
To: Richard Weinberger <richard@nod.at>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, Thomas Shao <huishao@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPom6EfguQ5YHfv0qQpfdXjiDiFZul1uyAgAP9BeCAAEiTAIAAENsg
Date: Mon, 21 Jul 2014 08:05:29 +0000
Message-ID: <DC7803B42427924284F2D5252E076A3B4476A363@SINEX14MBXC416.southpacific.corp.microsoft.com>
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
 <CAFLxGvxQU_z+mChHsNSu9VZEdXrU+RU75k6H18uKbdAj2TKD5g@mail.gmail.com>
 <DC7803B42427924284F2D5252E076A3B44769DCA@SINEX14MBXC416.southpacific.corp.microsoft.com>
 <53CCB944.8090709@nod.at>
In-Reply-To: <53CCB944.8090709@nod.at>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(51704005)(377454003)(164054003)(81342001)(95666004)(46102001)(76176999)(21056001)(50986999)(99396002)(76482001)(83072002)(85852003)(2656002)(87936001)(92726001)(92566001)(16796002)(106116001)(47776003)(31966008)(110136001)(85306003)(20776003)(106466001)(81156004)(64706001)(81542001)(77982001)(80022001)(77096002)(55846006)(74662001)(74502001)(54356999)(86362001)(23676002)(4396001)(69596002)(68736004)(79102001)(107046002)(6806004)(93886003)(19580395003)(19580405001)(83322001)(44976005)(33656002)(26826002)(84676001)(97736001)(86612001)(50466002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB085;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0279B3DD0D
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=yuezha@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6L88awB028434

> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Monday, July 21, 2014 2:55 PM
> 
> Yue,
> 
> Am 21.07.2014 04:44, schrieb Yue Zhang (OSTC DEV):
> >> From: Richard Weinberger [mailto:richard.weinberger@gmail.com]
> >> Why 10? Is this a random number which works by accident for ifplugd?
> >> What about other networking implementations, is 10 also ok for them?
> >> --
> >> Thanks,
> >> //richard
> >
> > Hi, Richard
> >
> > I checked ifplugd's code. The deferring time is 5 seconds. That's how
> comes
> > the "10s". I agree with you this is a magic number and should be avoid.
> However,
> > this is the only feasible solution right now. If there is a better solution, I will
> be
> > glad to switch to it.
> >
> > I tested the fix in Redhat, Ubuntu and SUSE and it works in all of them.
> 
> The problem I see is that there is no good way to trigger a DHCP renew from
> a network device drivers. You're on the wrong layer.
> 10 seconds may work but this is IMHO a hack which can easily break.
> There are also more networking implementations than ifplugd.
> Specially the systemd implementation looks promising.
> 
> Can't you propagate the RNDIS_STATUS_NETWORK_CHANGE event to
> userspace?
> IIRC on HyperV guests already have a guest daemon. Let the daemon handle
> the event such that distros can install their own hooks...
> 
> Thanks,
> //richard

Hi, Richard

The problem of systemd implementation is that in different distros, the ways to 
restart service are different. Propagating the event to userspace also doesn't help
for this issue. 

The advantage of current solution is that it simulates a cable plugging in/out event.
IMHO, in all the distros, this simulated event has already been well handled. It is a
dup effect to implement new hooks.

Thanks
----
Yue
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
