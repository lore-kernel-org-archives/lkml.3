Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbbA0Ocb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 09:32:31 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57090 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbbA0Oc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 09:32:28 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Tue, 27 Jan 2015 15:32:25 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <20150127132127.GA869@amd> <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
In-Reply-To: <CAL_JsqKM+2PtX_EpWXyOQHVXwf=jqVj8SroUGPO1Y2=Zj8_kMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2150640.LEvnQNdQbm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501271532.25540@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2150640.LEvnQNdQbm
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 27 January 2015 15:16:45 Rob Herring wrote:
> On Tue, Jan 27, 2015 at 7:21 AM, Pavel Machek <pavel@ucw.cz>=20
wrote:
> > On Mon 2015-01-26 14:33:21, Rob Herring wrote:
> >> On Mon, Jan 26, 2015 at 1:16 PM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> >> > This patch will cause that decompressor store full ATAG
> >> > structure into DT tree ("/atags"):
> >> >=20
> >> >=20
> >> > +       /* include the terminating ATAG_NONE */
> >> > +       atag_size =3D (char *)atag - (char *)atag_list +
> >> > sizeof(struct tag_header); +       setprop(fdt, "/",
> >> > "atags", atag_list, atag_size); +
> >> >=20
> >> >         if (memcount) {
> >> >        =20
> >> >                 setprop(fdt, "/memory", "reg",
> >> >                 mem_reg_property,
> >> >                =20
> >> >                         4 * memcount * memsize);
> >> >=20
> >> > And this patch will export ATAG structure from DT tree=20
("/atags") into /proc/atags file:
> >> Please properly send your patches.
> >=20
> > Actually, when sending patches for discussion, this is
> > format easier to read.
>=20
> Some people might prefer them as attachments too...
>=20
> >> > Some userspace applications needs access to ATAG
> >> > structure where can be stored some information passed
> >> > from bootloader to kernel. Example is Nokia N900 device
> >> > and NOLO bootloader which provides information about
> >> > bootreason (device was started by power button or by
> >> > alarm or restarted...) and bootmode (normal mode or
> >> > device update mode).
> >>=20
> >> This goes in the commit message.
> >>=20
> >> These would be non-standard fields which are not upstream.
> >> I don't know that we care in that case...
> >=20
> > Other devices are going to care about boot reason, too, and
> > we might as well be compatible...
>=20
> What other devices? Where is bootreason in the list of ATAGS:
>=20
> #define ATAG_MEM        0x54410002
> #define ATAG_VIDEOTEXT  0x54410003
> #define ATAG_RAMDISK    0x54410004
> #define ATAG_INITRD     0x54410005
> #define ATAG_INITRD2    0x54420005
> #define ATAG_SERIAL     0x54410006
> #define ATAG_REVISION   0x54410007
> #define ATAG_VIDEOLFB   0x54410008
> #define ATAG_CMDLINE    0x54410009
> #define ATAG_ACORN      0x41000101
> #define ATAG_MEMCLK     0x41000402
>=20
> Rob

Each device is using own proprietary atag (or other information)=20
to pass bootreason from bootloader to kernel. No standard way :-(

I think Pavel mean to introduce some standard way how *new*=20
version of bootloaders can pass boot reason to kernel and how=20
kernel tell it to userspace...

E.g. NOLO -- bootloader for Nokia N900 -- pass this information=20
in ATAG_OMAP (0x414f4d50) and Nokia kernel exports it via procfs=20
file /proc/bootreason.

Also NOLO pass some other information via ATAGs, but those are=20
static and now part of n900 DT file. But bootreason is not static=20
information so cannot be hardcoded into static DT file which is=20
part of kernel.

I think this kind of information (how was board/computer started)=20
can be useful also for other architectures. E.g. on laptop you=20
would like to know if if was started by RTC, power button,=20
WakeOnLan, another ACPI event, rebooted machine, watchdog, etc...=20
And scripts can act depending on this event (when by RTC, you=20
need to run some planned job, when by watchdog reset you should=20
check what caused that reason...).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2150640.LEvnQNdQbm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTHoXkACgkQi/DJPQPkQ1K5NQCeLS8hXKA735hXZx+E5CYTSnWp
7WEAnRQefw3DlUlAXC7F6mWV6rWXVmdV
=cQRX
-----END PGP SIGNATURE-----

--nextPart2150640.LEvnQNdQbm--
