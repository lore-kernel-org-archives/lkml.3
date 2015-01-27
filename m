Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951AbbA0Veu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:34:50 -0500
Received: from relais.videotron.ca ([24.201.245.36]:21160 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759308AbbA0Vet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:34:49 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_alOGAoUSb248j7BmcnY3MA)"
Date: Tue, 27 Jan 2015 16:34:47 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?ISO-8859-15?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Rob Herring <robherring2@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
In-reply-to: <20150127210943.GN26493@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.11.1501271614280.1322@knanqh.ubzr>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <20150127132127.GA869@amd>
 <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
 <201501271532.25540@pali> <20150127174818.GM26493@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501271446330.1322@knanqh.ubzr>
 <20150127210943.GN26493@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_alOGAoUSb248j7BmcnY3MA)
Content-type: TEXT/PLAIN; charset=iso-8859-1
Content-transfer-encoding: 8BIT

On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:

> On Tue, Jan 27, 2015 at 03:03:23PM -0500, Nicolas Pitre wrote:
> > On Tue, 27 Jan 2015, Russell King - ARM Linux wrote:
> > 
> > > On Tue, Jan 27, 2015 at 03:32:25PM +0100, Pali Rohár wrote:
> > > > On Tuesday 27 January 2015 15:16:45 Rob Herring wrote:
> > > > > What other devices? Where is bootreason in the list of ATAGS:
> > > > > 
> > > > > #define ATAG_MEM        0x54410002
> > > > > #define ATAG_VIDEOTEXT  0x54410003
> > > > > #define ATAG_RAMDISK    0x54410004
> > > > > #define ATAG_INITRD     0x54410005
> > > > > #define ATAG_INITRD2    0x54420005
> > > > > #define ATAG_SERIAL     0x54410006
> > > > > #define ATAG_REVISION   0x54410007
> > > > > #define ATAG_VIDEOLFB   0x54410008
> > > > > #define ATAG_CMDLINE    0x54410009
> > > > > #define ATAG_ACORN      0x41000101
> > > > > #define ATAG_MEMCLK     0x41000402
> > > > > 
> > > > > Rob
> > > > 
> > > > Each device is using own proprietary atag (or other information) 
> > > > to pass bootreason from bootloader to kernel. No standard way :-(
> > 
> > So that's what Pavel was alluding to.
> > 
> > > The reason that happens is because people refuse to discuss their
> > > requirements here - just like people refuse to report userspace API
> > > regressions to kernel people.  This rather pisses me off, because
> > > it creates all sorts of horrid per-platform yuck.
> > > 
> > > We _could_ (and have in the past) turned round and refused to support
> > > these kinds of hacks - which IMHO is quite a reasonable stance to
> > > take: the message we should be sending is "if you wish to design
> > > new methods without discussing it with us, we reserve the right not
> > > to support them in mainline kernels; please discuss with us your
> > > requirements."
> > > 
> > > Each time that we accept one of these hacks, we're sending a message
> > > that says "it's okay to work in this crappy way".
> > > 
> > > Yes, I realise that the N900 has little in the way of support, and we
> > > can't exert that kind of back pressure (since there's no one to direct
> > > that onto to effect any change) so I guess we just have to live with it.
> > 
> > If the method is: "let's pass non-standard ATAGs around and have ad-hoc 
> > user space code interpret it in some arbitrary way" then it's a complete 
> > abomination.
> > 
> > > > I think this kind of information (how was board/computer started) 
> > > > can be useful also for other architectures. E.g. on laptop you 
> > > > would like to know if if was started by RTC, power button, 
> > > > WakeOnLan, another ACPI event, rebooted machine, watchdog, etc... 
> > > > And scripts can act depending on this event (when by RTC, you 
> > > > need to run some planned job, when by watchdog reset you should 
> > > > check what caused that reason...).
> > 
> > Useful when properly designed and generic enough to be shared.
> > 
> > I'd suggest a DT property be proposed for that purpose if it doesn't 
> > already exist.  That at least has a chance to be generically useful.
> 
> What this means is that we have to further augment the atags-to-dt code
> in the decompressor with the platform specific ATAGs to parse this
> information and merge it into the appended DT before passing the
> resulting DT blob to the kernel.

That would be only 2 new lines of code in the best case.

Still, I opposed such platform specific hacks in the past, suggesting 
that a separate shim be used instead, which was done successfully.

> Or we pass both the ATAGs and wrapped DT to the kernel when both exist,
> and let the kernel deal with it in a much saner environment than the
> restricted decompressor environment.

... which would be a step backward in the context of the transition to 
DT we accepted.  People will have even less of an incentive to fix their 
stuff.

> Or we /could/ say that mainline never supported it, and we aren't going
> to add support for "new" tags to the mainline kernel.  It wouldn't be
> a regression, because mainline hasn't ever supported them (that's been
> said before about such things on other platforms.)

That would be my stance.

> However, there's another consideration to be had here before we can say
> that: how many people out there want to run a mainline (or even an
> updated kernel derived from mainline) on this device?  If there's a
> sizable following for the device wanting updated support, then it's
> something we really need to consider supporting inspite of our
> disappointment with Nokia inventing these "proprietary" tags.

If there is indeed a sizable following for the device then someone 
should figure out how to cope with upstream kernels, either through the 
installation of some intermediate bootloader that can talk FDT directly, 
or via a shim layer.  None of that has to be performed by nor linked 
with the kernel binary, nor maintained in the kernel tree. And it's not 
even that hard to do: we have precedents on other platforms with crappy 
bootloaders where this just works.


Nicolas

--Boundary_(ID_alOGAoUSb248j7BmcnY3MA)--
