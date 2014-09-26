Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbaIZPOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:14:34 -0400
Received: from mail-bn1on0147.outbound.protection.outlook.com ([157.56.110.147]:30448
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754191AbaIZPOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:14:32 -0400
X-Greylist: delayed 9797 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2014 11:14:32 EDT
From: Thomas Shao <huishao@microsoft.com>
To: Mike Surcouf <mps.surcouf.lkml@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Olaf Hering <olaf@aepfle.de>, Robo Bot <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
Thread-Topic: [PATCH] Drivers: hv: util: Implement Time Synchronization
 using host time sample
Thread-Index: AQHP2XESGfKWnzoNvEy532a+Bg3JTpwTTgaAgAAIEqCAAAy5AIAADGuAgAAUy7A=
Date: Fri, 26 Sep 2014 15:13:24 +0000
Message-ID: <CD2CABCB2C0A0D4682C5F8AD84014154098BC7@HKXPRD3002MB006.064d.mgd.msft.net>
References: <1411725736-49225-1-git-send-email-huishao@microsoft.com>
	<CAL7Bo8HoYU1mbUbw-k0ufj7n8D=Z_hLtf268gKeyACcnZHH5rw@mail.gmail.com>
	<CD2CABCB2C0A0D4682C5F8AD8401415409846D@HKXPRD3002MB006.064d.mgd.msft.net>
	<CAL7Bo8G_7cOYxbtPR=JDxE8VJShbzs2+2Y=F9OOABgFZr=m29A@mail.gmail.com>
 <CAL7Bo8EocBnW28r-QtYU7AvSTyQNdMm39ns5WyM2++rbnJKxrg@mail.gmail.com>
In-Reply-To: <CAL7Bo8EocBnW28r-QtYU7AvSTyQNdMm39ns5WyM2++rbnJKxrg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.91.240.4]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(377454003)(199003)(51704005)(189002)(13464003)(31966008)(4396001)(33656002)(76482002)(85306004)(23676002)(50986999)(54356999)(106116001)(93886004)(76176999)(50466002)(26826002)(16796002)(87936001)(106466001)(86146001)(120916001)(83322001)(55846006)(83072002)(44976005)(84676001)(21056001)(99396003)(2656002)(10300001)(19580405001)(81156004)(6806004)(97736003)(92566001)(64706001)(92726001)(86612001)(66066001)(107046002)(47776003)(20776003)(86362001)(85852003)(81542003)(90102001)(80022003)(79102003)(69596002)(74662003)(77096002)(95666004)(19580395003)(77982003)(74502003)(68736004)(81342003)(46102003)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB274;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB274;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=huishao@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8QFEclr001350



> -----Original Message-----
> From: Mike Surcouf [mailto:mps.surcouf.lkml@gmail.com]
> Sent: Friday, September 26, 2014 9:52 PM
> To: Thomas Shao
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> driverdev-devel@linuxdriverproject.org; Olaf Hering; Robo Bot;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
> host time sample
> 
> In CENTOS and RHEL 6 and upwards the official way would be to use
> 
> /usr/sbin/tickadj
> 
> which is provided by ntp/chrony package
> 
> This dependency on user space packages that may or may not be installed is
> going to cause a lot of confusion in an already confused space.
> Are we sure theres no other way?

Thanks Mike.
I think another way is to expose the do_adjtimex to kernel module. I'm not sure if there is any concerns. I'll investigate that.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
