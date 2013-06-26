Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab3FZEww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:52:52 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:20742
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750766Ab3FZEwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:52:50 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Darren Hart <dvhart@linux.intel.com>
CC: Olof Johansson <olof@lixom.net>, "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "peter.p.waskiewicz.jr@intel.com" <peter.p.waskiewicz.jr@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
	<andriy.shevchenko@linux.intel.com>,
        "danders@circuitco.com" <danders@circuitco.com>,
        "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Richard Purdie <richard.purdie@linuxfoundation.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
Thread-Topic: [PATCH 4/8] minnowboard: Add base platform driver for the
 MinnowBoard
Thread-Index: AQHOcg//k4Oo/fSkBUqc5+pwXHA5uZlHX0AAgAAMBgCAAAKYgA==
Date: Wed, 26 Jun 2013 04:52:46 +0000
Message-ID: <1372222365.9179.4.camel@x230>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <a459c0b97ea41148af901fc73dbeff98778c7419.1372211451.git.dvhart@linux.intel.com>
	 <20130626040026.GA23621@quad.lixom.net>
	 <1372221808.8177.52.camel@envy.home>
In-Reply-To: <1372221808.8177.52.camel@envy.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.84.4]
x-forefront-prvs: 08897B549D
x-forefront-antispam-report: SFV:NSPM;SFS:(199002)(189002)(377424004)(24454002)(74366001)(16406001)(81342001)(81542001)(79102001)(74502001)(53806001)(74662001)(47446002)(76796001)(76786001)(56816003)(77096001)(74706001)(33646001)(33716001)(31966008)(77982001)(74876001)(69226001)(59766001)(54356001)(4396001)(47976001)(50986001)(80022001)(51856001)(49866001)(47736001)(65816001)(76482001)(63696002)(54316002)(56776001)(46102001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <30F4A32BAC0FE4418AF8FC999672FD01@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5Q4rJNu003464

On Tue, 2013-06-25 at 21:43 -0700, Darren Hart wrote:

> 1) I need time, possibly a couple of months, to get proper ACPI support
> for these drivers into the firmware. Then I can rewrite these as ACPI
> drivers as is proper for an x86 board. I've already started down this
> path.

A couple of months pushes you back one kernel release. It's not a huge
deal. I think I side with Olof here - the kernel developers have pushed
back against hardcoded and NIHed ARM device descriptors, and given that
we have a perfectly reasonable standard in the X86 world (ie, ACPI), I'm
not enthusiastic about merging something that's (a) going to be
superseded in the near future and (b) may end up serving as an example
to others who think this is ok.

Do these boards currently boot any other OSes?

> See what happens when core kernel people are allowed to write driver
> code? How does this relate to converting this over to an ACPI device
> driver? I guess I would replace the above with
> MODULE_DEVICE_TABLE(acpi, ...) ? If I do the above.... is this still an
> evil board-file? What makes the acpi method of discover superior to
> setting up linux-hotplug via dmi?

MODULE_DEVICE_TABLE is invisible to the running driver, it just exports
metadata that udev will use to decide whether to load the driver. If a
driver is intended to deal with a specific board, DMI makes sense. If
it's intended to deal with a specific ACPI device (ie, something with a
_HID that defines the programming model), ACPI makes sense.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
