Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab3HGKgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:36:13 -0400
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:43593
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932354Ab3HGKgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:36:11 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: Borislav Petkov <bp@alien8.de>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>, "rjw@sisk.pl" <rjw@sisk.pl>,
        Aaron Lu <aaron.lu@intel.com>
Subject: Re: Backlight control only in the kernel?
Thread-Topic: Backlight control only in the kernel?
Thread-Index: AQHOk0HoKKUeq3BbmU2xXrV1E8eRKJmJjVQA
Date: Wed, 7 Aug 2013 10:36:08 +0000
Message-ID: <1375871766.10292.7.camel@x230.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <20130807074405.GA18272@pd.tnic>
In-Reply-To: <20130807074405.GA18272@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 0931CB1479
x-forefront-antispam-report: SFV:NSPM;SFS:(60444003)(377424004)(199002)(189002)(51704005)(24454002)(74876001)(59766001)(65816001)(54356001)(53806001)(74662001)(51856001)(80022001)(47446002)(33646001)(74502001)(76482001)(31966008)(81342001)(63696002)(83322001)(46102001)(19580405001)(80976001)(81542001)(83072001)(74366001)(56776001)(79102001)(56816003)(4396001)(16406001)(19580395003)(47976001)(76796001)(76786001)(50986001)(77982001)(69226001)(74706001)(54316002)(77096001)(49866001)(47736001)(36756003)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR05MB219;H:BN1PR05MB218.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0611798DC053D4793AA03A221FE323F@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r77AaHtw025627

On Wed, 2013-08-07 at 09:44 +0200, Borislav Petkov wrote:

> Background is that on my x230, I needed to connect the
> Fn-Fx backlight hotkey presses to a script to write to
> /sys/class/backlight/intel_backlight/brightness because Fluxbox doesn't
> do that (and maybe doesn't have to).
> 
> So, without presuming any ACPI or backlight knowledge, can we make the
> backlight control work only in the kernel by connecting the hotkey
> presses to some backlight controlling interface which backlight-capable
> devices implement so that it works regardless of userspace environment?
> Even if the machine is not running X?

Not really. The ACPI driver is able to do this because the events and
the backlight are associated with the same device. We could potentially
make something work with GPU backlight drivers since their PCI device
should also be associated with the backlight device, but things get
complicated quickly - once ddcci support is hooked up you'll also have
kernel backlight devices for some external monitors, and now you need to
make a policy decision about which display should be controlled in
response to the keypress. One reasonable choice would be whichever
display contains the currently focused window, which is obviously out of
scope for the kernel.

So if we're going to do this then we need a generalised mechanism
in-kernel for connecting input devices to backlight devices, and we need
a mechanism for disabling it when userspace knows better. This sounds
like a lot of work for something that should really just be handled by
userspace already.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
