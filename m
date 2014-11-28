Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbaK1RHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 12:07:16 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:52839 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaK1RHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 12:07:14 -0500
Date: Fri, 28 Nov 2014 17:07:12 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sandeep Nair <sandeep_n@ti.com>, linux-soc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] MIPS: BCM47XX: Move NVRAM driver to the
 drivers/soc/
In-Reply-To: <CACna6rwMjOfmnA-926udNx7jQHQ2JMnmiutQZkTxtJ85qmUw8A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1411281659190.1406@utopia.booyaka.com>
References: <1416736241-12723-1-git-send-email-zajec5@gmail.com> <1416778509-31502-1-git-send-email-zajec5@gmail.com> <alpine.DEB.2.02.1411240910100.16047@utopia.booyaka.com> <CACna6rxwwn5_e86278TAiOFZ3sVu_Exfm2x94vN2KiTJfsFujQ@mail.gmail.com>
 <alpine.DEB.2.02.1411251407290.16047@utopia.booyaka.com> <CACna6rxj8=V8me1_L8SxhV3=kgYRyKeBHkxShSMZa4kbcHimLg@mail.gmail.com> <alpine.DEB.2.02.1411271926560.1406@utopia.booyaka.com> <CACna6rwMjOfmnA-926udNx7jQHQ2JMnmiutQZkTxtJ85qmUw8A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-105837066-1417194432=:1406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-105837066-1417194432=:1406
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Rafa=C5=82,

On Thu, 27 Nov 2014, Rafa=C5=82 Mi=C5=82ecki wrote:

> On 27 November 2014 at 20:56, Paul Walmsley <paul@pwsan.com> wrote:
> > On Tue, 25 Nov 2014, Rafa=C5=82 Mi=C5=82ecki wrote:
> >> I understand your arguments against drivers/soc/, but on the other han=
d
> >> I have no idea where else this driver could go.
> >
> > After looking around the tree to find out where similar code is located=
,
> > it looks like drivers/firmware is the right place.  These days,
> > drivers/firmware is mainly used for drivers that parse EFI bootloader
> > data, DMI data, that sort of thing.  Quite similar to the CFE-provided
> > data that the bcm47xx-nvram code deals with.  So, by functional analogy=
,
> > drivers/firmware appears to be the right place to stash this device
> > data-probing code.
> >
> >> I guess DT is older than CFE, but Broadcom decided to invent own
> >> solution called NVRAM anyway. This is a bit messy, because it actually
> >> stores hardware details (CPU, RAM, switch) as well as user settings
> >> (e.g. LEDs behavior). I can't say why Broadcom decided to implement it
> >> this way.
> >
> > Yep, based on what the other drivers in drivers/firmware are used for, =
I
> > think drivers/firmware is the right place for the CFE parsing code.
>=20
> The problem is I can't find MAINTAINER of the drivers/firmware/. Is
> there someone responsible for that? Some mailing list maybe? Who could
> give us an ACK to move bcm47xx_nvram there?

The list of folks who have committed patches that touch drivers/firmware=20
is large.  I did this as a first-order approximation:

$ git log --format=3Dfuller drivers/firmware/* | grep Commit: | sort -u
Commit:     Adrian Bunk <bunk@kernel.org>
Commit:     Adrian Bunk <bunk@stusta.de>
Commit:     Al Viro <viro@zeniv.linux.org.uk>
Commit:     Andi Kleen <andi@basil.nowhere.org>
Commit:     Benjamin Herrenschmidt <benh@kernel.crashing.org>
Commit:     David S. Miller <davem@davemloft.net>
Commit:     David Woodhouse <David.Woodhouse@intel.com>
Commit:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Commit:     Greg Kroah-Hartman <gregkh@suse.de>
Commit:     H. Peter Anvin <hpa@linux.intel.com>
Commit:     H. Peter Anvin <hpa@zytor.com>
Commit:     Ingo Molnar <mingo@elte.hu>
Commit:     Ingo Molnar <mingo@kernel.org>
Commit:     James Bottomley <James.Bottomley@suse.de>
Commit:     James Bottomley <JBottomley@Parallels.com>
Commit:     Jean Delvare <khali@linux-fr.org>
Commit:     Jeff Garzik <jeff@garzik.org>
Commit:     Jeff Garzik <jgarzik@redhat.com>
Commit:     Jesse Barnes <jbarnes@virtuousgeek.org>
Commit:     Jiri Kosina <jkosina@suse.cz>
Commit:     Konrad Rzeszutek Wilk <konrad@kernel.org>
Commit:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Commit:     Len Brown <len.brown@intel.com>
Commit:     Linus Torvalds <torvalds@g5.osdl.org>
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
Commit:     Linus Torvalds <torvalds@ppc970.osdl.org>
Commit:     Linus Torvalds <torvalds@woody.linux-foundation.org>
Commit:     Linus Torvalds <torvalds@woody.osdl.org>
Commit:     Mark Brown <broonie@opensource.wolfsonmicro.com>
Commit:     Mark M. Hoffman <mhoffman@lightlink.com>
Commit:     Matt Fleming <matt.fleming@intel.com>
Commit:     Matthew Wilcox <willy@linux.intel.com>
Commit:     Paul Gortmaker <paul.gortmaker@windriver.com>
Commit:     Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Commit:     Russell King <rmk+kernel@arm.linux.org.uk>
Commit:     Tejun Heo <tj@kernel.org>
Commit:     Theodore Ts'o <tytso@mit.edu>
Commit:     Thomas Gleixner <tglx@linutronix.de>
Commit:     Tony Luck <tony.luck@intel.com>

If I were in your shoes, I would suggest either

1. asking Ralf to merge your patches that touch drivers/firmware, since=20
he'll also presumably be merging the parts that touch arch/mips

or=20

2. asking Greg KH to merge those patches

And of course it would not hurt to collect some Reviewed-By:s from other=20
folks.  (See below...)

> >> > It sounds to me like this code is a combination of three
> >> > pieces:
> >> >
> >> > 1. code that autoprobes the size of the "nvram" partition in the Bro=
adcom
> >> > platform flash, by reading various locations in the MMIO flash apert=
ure,
> >> > configured by some other system entity
> >>
> >> That's right, on MIPS we simply detect flash type (drivers/ssb &
> >> driver/bcma) and using that we init NVRAM passing memory offset where
> >> the flash is mapped.
> >
> > OK.
> >
> > So (as a side issue), I would suggest that when you move this code out =
of
> > arch/mips, the MIPS-isms in it should be removed, like KSEG1ADDR(), etc=
=2E,
> > and replaced by the standard ioremap()-type approach.  After all, Broad=
com
> > could build CFE for ARM, and then we'd want to use this same code to pa=
rse
> > the CFE-provided data.
> >
> > Also I would suggest getting rid of the #ifdefs for the flash type, and
> > probing it dynamically instead.  The flash setup code under drivers/ssb=
/
> > and drivers/bcma/ sets up platform_devices for the flash, right?  If so
> > then it would be best if this code could run after the bus setup code,
> > query the Linux device model for the type of platform flash in use, and
> > then extract the appropriate address space to probe from that data.
>=20
> I'm pretty sure you look at some old version of arch/bcm47xx/nvram.c.
> I wouldn't dare to move such a MIPS-focused driver to some common
> place ;)
>=20
> Please check for the version of nvram.c in Ralf's upstream-sfr tree. I
> think you'll like it much more. Hopefully you will even consider it
> ready for moving to the drivers/firmware/ or whatever :)

OK I will take a look at this, and will either send comments, or will=20
send a Reviewed-By:.


Thanks for all of the good discussion on this :-)

- Paul
--843723315-105837066-1417194432=:1406--
