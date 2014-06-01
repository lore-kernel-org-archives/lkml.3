Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaFAQWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 12:22:20 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:49121
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752445AbaFAQWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 12:22:18 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "andreas.noever@gmail.com" <andreas.noever@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
Subject: Re: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Thread-Topic: [PATCH v4 00/15] Thunderbolt driver for Apple MacBooks
Thread-Index: AQHPfNyYVDcE17ZFH0KR3hCN8Vnny5tcCgKpgABjiYA=
Date: Sun, 1 Jun 2014 16:07:49 +0000
Message-ID: <1401638869.7663.21.camel@x230>
References: <1401546480-2071-1-git-send-email-andreas.noever@gmail.com>
	 <1401580281.7663.14.camel@x230>
	 <CAMxnaaURVhZ_SiJW7Qy1bsye1bcPE=J=vjL5MgTN5znP15WnXw@mail.gmail.com>
In-Reply-To: <CAMxnaaURVhZ_SiJW7Qy1bsye1bcPE=J=vjL5MgTN5znP15WnXw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-microsoft-antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(51704005)(377454003)(377424004)(24454002)(31966008)(33716001)(20776003)(77982001)(81342001)(4396001)(103116003)(81542001)(85852003)(83072002)(46102001)(2656002)(83322001)(80022001)(19580395003)(19580405001)(86362001)(76482001)(54356999)(74662001)(76176999)(101416001)(74502001)(64706001)(33646001)(87936001)(79102001)(50986999)(92726001)(21056001)(92566001)(99396002)(99286001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB423;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5BC7AFE9E9B4A4C9D83A32D09E75720@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s51GMVeT025181

On Sun, 2014-06-01 at 12:11 +0200, Andreas Noever wrote:
> On Sun, Jun 1, 2014 at 1:51 AM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > This seems to be working well on my MBP. It appears to broadly work on
> > my Mac Pro, which has Thunderbolt 2 hardware - I added the PCI ID, and
> > loading the thunderbolt driver after the device is plugged in works, but
> > it won't recognise hotplug events. I don't appear to get any interrupts
> > from the Thunderbolt controller. Any idea what might be happening there?
> So the communication with the controller works (dmesg dumps a list of
> ports etc.)? Do you get plug events ("resetting error on port ...")?
> You could try to play around with tb_plug_events_active, if you want
> to experiment. I can also take another look at what OS X does once I
> get back to my workstation (when I worked on this part falcon ridge
> was not jet released, so maybe they do things differently now).

Yeah, that was it. I'll mail the patch separately.


> > As far as the quirks go - perhaps something like this would be
> > reasonable, rather than maintaining a list of machines?
> I have obtained ACPI dumps from a late 2013 MBP and from a MacPro
> (both are falcon ridge devices) and these contain a few firmware
> changes. For example SXIO, SXIL and SXLV are gone so the shutdown
> quirk will fail. With some luck that means that the shutdown quirk is
> no longer required for falcon ridge hardware.

Yeah, it seems I don't need the suspend quirk - the NHI is still there
without it. I still think we should make the quirk general rather than
tying it to the machines, the worst case is that it'll just do nothing.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
