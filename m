Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaGUIov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:44:51 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:30997
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753895AbaGUIot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:44:49 -0400
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
Thread-Index: AQHPom6EfguQ5YHfv0qQpfdXjiDiFZul1uyAgAP9BeCAAEiTAIAAENsggAAGSICAAAJi4A==
Date: Mon, 21 Jul 2014 08:44:01 +0000
Message-ID: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
 <CAFLxGvxQU_z+mChHsNSu9VZEdXrU+RU75k6H18uKbdAj2TKD5g@mail.gmail.com>
 <DC7803B42427924284F2D5252E076A3B44769DCA@SINEX14MBXC416.southpacific.corp.microsoft.com>
 <53CCB944.8090709@nod.at>
 <DC7803B42427924284F2D5252E076A3B4476A363@SINEX14MBXC416.southpacific.corp.microsoft.com>
 <53CCCCAD.7080906@nod.at>
In-Reply-To: <53CCCCAD.7080906@nod.at>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(438002)(189002)(199002)(51704005)(377454003)(164054003)(23676002)(92566001)(92726001)(74502001)(83072002)(85852003)(99396002)(77096002)(95666004)(85306003)(81156004)(106466001)(4396001)(106116001)(19580395003)(19580405001)(50466002)(83322001)(84676001)(74662001)(46102001)(69596002)(68736004)(76482001)(33656002)(44976005)(6806004)(86362001)(26826002)(81542001)(110136001)(93886003)(81342001)(64706001)(97736001)(20776003)(47776003)(80022001)(77982001)(16796002)(87936001)(31966008)(79102001)(55846006)(107046002)(86612001)(21056001)(54356999)(50986999)(76176999)(2656002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB253;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6L8ivF9028677

> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Monday, July 21, 2014 4:18 PM
> 
> Yue,
> 
> Am 21.07.2014 10:05, schrieb Yue Zhang (OSTC DEV):
> > The problem of systemd implementation is that in different distros, the ways 
> > to restart service are different. Propagating the event to userspace also doesn't 
> > help for this issue.
> 
> This way each distro can provide their own restart script.
> Same as every distro has custom start scripts, etc...
> 
> > The advantage of current solution is that it simulates a cable plugging 
> > in/out event. IMHO, in all the distros, this simulated event has already been well 
> > handled. It is a dup effect to implement new hooks.
> 
> Iff the current solution works for _all_ networking implementations.
> 
> Thanks,
> //richard

Hi, Richard

IMHO, all networking implementations should handle the cable offline event. Consider
this situation. I unplugged the network cable and connect it to a new network switch
after 10 seconds. If the DHCP renew is not triggered, the network will break. I think in 
normal cases, it should already been handled properly. Unless there is a strong 
justification for not doing this. In that case, we shouldn't renew DHCP anyway.

Thanks
----
Yue
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
