Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaJ1QII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:08:08 -0400
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:34048
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbaJ1QHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:07:38 -0400
X-WSS-ID: 0NE5WS8-08-B4R-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Michael Shell <list1@michaelshell.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David Airlie" <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Koenig, Christian" <Christian.Koenig@amd.com>
Subject: RE: Standard VGA console with DRI/DRM under X?
Thread-Topic: Standard VGA console with DRI/DRM under X?
Thread-Index: AQHP8satC4UtUTYtjkKoS5co3Ll70pxFqEZA
Date: Tue, 28 Oct 2014 16:07:25 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D059946C27@satlexdag05.amd.com>
References: <20141028023208.320b777b6ad97c7c9a815300@michaelshell.org>
 <CAErSpo4zDxhG08FjyV9BJ+=cJLGYkyocz87ZRWndw70ND3g6XA@mail.gmail.com>
In-Reply-To: <CAErSpo4zDxhG08FjyV9BJ+=cJLGYkyocz87ZRWndw70ND3g6XA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.180.168.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(24454002)(51704005)(199003)(13464003)(377454003)(189002)(106116001)(86362001)(2656002)(19580405001)(85852003)(15202345003)(76482002)(76176999)(120916001)(77096002)(44976005)(46102003)(31966008)(53416004)(92726001)(87936001)(80022003)(85306004)(20776003)(54356999)(50466002)(21056001)(68736004)(106466001)(55846006)(4396001)(101416001)(97736003)(84676001)(19580395003)(95666004)(15395725005)(15975445006)(64706001)(50986999)(47776003)(107046002)(92566001)(105586002)(33656002)(23676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB193;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB193;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Alexander.Deucher@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB228;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9SG8E4s026782

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Tuesday, October 28, 2014 11:48 AM
> To: Michael Shell
> Cc: linux-kernel@vger.kernel.org; David Airlie; DRI mailing list; Deucher,
> Alexander; Koenig, Christian
> Subject: Re: Standard VGA console with DRI/DRM under X?
> 
> [+cc David, Alex, Christian, dri-devel]
> 
> On Tue, Oct 28, 2014 at 12:32 AM, Michael Shell <list1@michaelshell.org>
> wrote:
> >
> >
> >   Greetings,
> >
> > Well, I want to be able to have my cake and eat it too. I want to be able to
> > have the standard VGA/"hardware" classic console (not the framebuffer)
> but
> > I still want the /dev/dri/cardX devices so that I can use DRI under Xorg.
> >
> > Is this possible and if not, why not?
> >
> >

It's not currently possible.  When the driver loads it needs to reprogram the GPU memory controller which requires disabling (or at least blanking the displays).  Additionally there is currently no code in the driver to setup the vga text mode emulation.  Moreover, there is no legacy vga text mode on UEFI systems when the GPU has a GOP driver.

> > (I do hope I'm not bring up an issue with an obvious fix, but my searching
> >  has not yielded an answer yet. For the record, I'm running modern kernel
> >  (3.16.3) with much older x86 hardware [r100 Radeon video card].)
> >
> >
> > If I boot with the kernel nomodeset option I can get the classic
> > VGA/"hardware" console, but then I lose support for DRI/DRM:
> >
> > Oct 27 15:11:09 X kernel: [drm] Initialized drm 1.1.0 20060810
> > Oct 27 15:11:09 X kernel: [drm] VGACON disable radeon kernel
> modesetting.
> > Oct 27 15:11:09 X kernel: [drm:radeon_init] *ERROR* No UMS support in
> radeon module
> >
> > and glxgears et al. turns slow. In more modern Xorg releases, DRI is
> > required for all hardware acceleration, so having /dev/dri/cardX is very
> > important:
> >
> > http://askubuntu.com/questions/463142/why-x-is-relying-on-software-
> instead-of-hardware-with-nomodeset-kernel-paramet
> >

UMS is deprecated in the kernel and support for UMS has been dropped from the X ddx and the mesa drivers. Moreover, UMS had a lot of limitations that make it much less useful for modern desktops (no DRI2 support, no display hotplug support, etc.).

> >
> > One reason I do not wish to use the framebuffer console is because of the
> > small font. 160 columns makes it difficult to tell which [OK] belongs with
> > which service. The selection of console fonts should always include a
> > set that gives us an 80 column screen and the docs should point this out.
> >
> > And I dislike any blanking or video mode changes during boot.
> >
> > Can't the kernel just declare that it is capable of setting the video mode,
> > provide the /dev/dri/cardX devices and leave the console alone, but still
> > allow Xorg to call for a new mode and use /dev/dri/cardX if/when it sees
> fit?
> >
> > In an ideal world, there would be some kernel option such as fbcon=no.
> >
> > In the kernel Documentation fbcon.txt it mentions "fbcon=map:1 tells
> fbcon not
> > to take over the console." But, IIRC, from my tests I wasn't able to use this
> > to get a VGA/"hardware" console and still be able to have /dev/dri/cardX
> devices.
> >

The driver disables the legacy vga text mode hardware when it loads.  I think configuring a different mode or font for the fb console would probably get you what you want.  See the Forcing Modes section of this page (http://nouveau.freedesktop.org/wiki/KernelModeSetting/) for how to select a custom mode for your display with KMS

Alex

> >
> >
> >     Cheers and thank you,
> >
> >     Mike Shell
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
