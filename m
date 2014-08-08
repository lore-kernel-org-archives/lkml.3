Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaHHDPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 23:15:05 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:58515
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755016AbaHHDPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 23:15:00 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Richard Weinberger <richard.weinberger@gmail.com>,
        David Miller <davem@davemloft.net>,
        "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, Thomas Shao <huishao@microsoft.com>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPspA/W9GLuVF6+E2lxD+S7UVRVpvF95oQ
Date: Fri, 8 Aug 2014 03:13:58 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C99149D0@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <DC7803B42427924284F2D5252E076A3B4476A479@SINEX14MBXC416.southpacific.corp.microsoft.com>
	<53CCD6F2.6020909@nod.at>	<20140721091851.GA28171@aepfle.de>
	<20140721.143225.2040366896972949930.davem@davemloft.net>
 <CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
In-Reply-To: <CAFLxGvyfy1UkxN6_-c_ST7f8n7DvqYsCPKChWmt9CerWb0dh7g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.93]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(13464003)(189002)(199002)(377454003)(24454002)(561944003)(95666004)(106116001)(50466002)(84676001)(50986999)(81156004)(93886004)(106466001)(87936001)(33656002)(64706001)(46102001)(107046002)(23676002)(97736001)(47776003)(85852003)(83072002)(1511001)(2421001)(79102001)(83322001)(6806004)(68736004)(26826002)(76482001)(69596002)(44976005)(80022001)(55846006)(19580405001)(92726001)(19580395003)(21056001)(4396001)(2656002)(81342001)(86612001)(85806002)(86362001)(85306004)(74502001)(54356999)(99396002)(81542001)(76176999)(16796002)(77096002)(74662001)(77982001)(92566001)(31966008)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0678;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s783FSvL021799

> -----Original Message-----
> From: Richard Weinberger [mailto:richard.weinberger@gmail.com]
> Sent: Friday, August 8, 2014 6:37 AM
> To: David Miller; Yue Zhang (OSTC DEV)
> Cc: olaf@aepfle.de; netdev@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; LKML; Greg KH; jasowang@redhat.com;
> Haiyang Zhang; KY Srinivasan; Thomas Shao; Dexuan Cui
> Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
> 
> On Mon, Jul 21, 2014 at 11:32 PM, David Miller <davem@davemloft.net>
> wrote:
> > From: Olaf Hering <olaf@aepfle.de>
> > Date: Mon, 21 Jul 2014 11:18:51 +0200
> >
> >> On Mon, Jul 21, Richard Weinberger wrote:
> >>
> >>> My concern is that 10 seconds is maybe not a the right choice.
> >>> (As we cannot know all implementations)
> >>
> >> Until someone reports an issue with it, 10 is fine. Just like 20 or 666.
> >
> > Wrong, this is policy and belongs in userspace.
> 
> The "/etc/init.d/network restart" nonsense now hit Linus' tree.
> Yue, what is your proposal to fix that?
> 
> //richard

Hi Richard and all,
Sorry for the late response -- actually we have been trying to
figure out a solution that's acceptable to all.

IMO the most feasible and need-the-least-change solution may be:
the hyperv network VSC driver passes the event
RNDIS_STATUS_NETWORK_CHANGE to the udev daemon?

In this way, every distro only needs to add a udev rule, which should
be simple.

Any comment?

-- Dexuan
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
