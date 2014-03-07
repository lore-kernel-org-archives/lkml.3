Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaCGTYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:24:12 -0500
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:49444
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751988AbaCGTYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:24:10 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH] input: Use platform-provided devices as i8042 serio
 parents
Thread-Topic: [PATCH] input: Use platform-provided devices as i8042 serio
 parents
Thread-Index: AQHPMLktl1/t9sNuKUC/+2JKKORVk5rV+xAAgAAZFQA=
Date: Fri, 7 Mar 2014 19:24:03 +0000
Message-ID: <1394220242.31116.2.camel@x230>
References: <1393174996-27764-1-git-send-email-matthew.garrett@nebula.com>
	 <20140307175415.GB25283@core.coreip.homeip.net>
In-Reply-To: <20140307175415.GB25283@core.coreip.homeip.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.56.22.105]
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(377424004)(51704005)(189002)(199002)(92726001)(77096001)(69226001)(74706001)(80976001)(90146001)(76796001)(87936001)(76786001)(51856001)(81342001)(46102001)(77982001)(59766001)(95416001)(79102001)(74366001)(81542001)(53806001)(93516002)(81686001)(74662001)(31966008)(85852003)(47976001)(74502001)(65816001)(2656002)(47446002)(83072002)(54316002)(49866001)(47736001)(97186001)(66066001)(95666003)(56776001)(80022001)(19580405001)(83322001)(19580395003)(50986001)(81816001)(94316002)(85306002)(86362001)(87266001)(56816005)(33716001)(97336001)(4396001)(76482001)(54356001)(94946001)(63696002)(33646001)(74876001)(93136001)(92566001);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR05MB762;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:172.56.22.105;FPR:A6F4F019.17175F93.71CC1DCE.40E4E989.2020B;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CDF9E349BE7E640B10F02A27ABD5E04@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s27JOPJc004075

On Fri, 2014-03-07 at 09:54 -0800, Dmitry Torokhov wrote:
> Hi Matthew,
> 
> On Sun, Feb 23, 2014 at 12:03:16PM -0500, Matthew Garrett wrote:
> > i8042 devices exposed via platform firmware interfaces such as ACPI or
> > Device Tree may provide additional information of use to userspace. Right
> > now we don't associate the serio devices with the firmware device, and so
> > there's no straightforward way for userspace to make use of that
> > information. This patch simply moves the serio parent device to the firmware
> > provided device.
> 
> Hmm, are we sure it will not mess up power management now that children
> serio ports are disconnected from i8042 device?

Urh. Yeah, that's a point - we probably no longer guarantee that the
i8042 resume code runs before any driver resume code. That's
inconvenient. We could probably add resume callbacks to the PNP devices,
but then we need to ensure that they only run once. I think we can do
that without too much trouble, but it's not going to be beautiful.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
