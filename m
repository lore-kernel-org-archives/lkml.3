Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171AbbA1U16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:27:58 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37157 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056AbbA1U14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:27:56 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Wed, 28 Jan 2015 20:33:53 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com> <0ED606B9-34EB-4FEC-BCC1-19BC60BCF768@jcrosoft.com>
In-Reply-To: <0ED606B9-34EB-4FEC-BCC1-19BC60BCF768@jcrosoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1655463.n3zj3Ha6pd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501282033.53144@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1655463.n3zj3Ha6pd
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 28 January 2015 19:00:25 Jean-Christophe PLAGNIOL-
VILLARD wrote:
> > On Jan 28, 2015, at 11:57 PM, Rob Herring
> > <robherring2@gmail.com> wrote:
> >=20
> > On Wed, Jan 28, 2015 at 8:33 AM, Nicolas Pitre=20
<nico@fluxnic.net> wrote:
> >> On Wed, 28 Jan 2015, Pali Roh=C3=A1r wrote:
> >>> On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
> >>>> On omaps, the bootrom passes the bootreason in r1 to the
> >>>> bootloader that can do whatever it wants with it. We
> >>>> could maybe pass it in the kernel cmdline to the
> >>>> watchdog driver for user space?
> >>>=20
> >>> Not truth for N900. Bootreason depends on PRM_RSTST omap
> >>> register, state of vbat charger pins, time how long was
> >>> power key pressed, R&D data stored in CAL partition and
> >>> other undocumented registers for omap HS devices. I
> >>> already tried to implement at least some subset of it in
> >>> userspace (or kernel), but it is impossible because NOLO
> >>> bootloader clear status of PRM_RSTST register.
> >>>=20
> >>> There is also copy of PRM_RSTST register stored at address
> >>> 0x4020FFB8 (tracing data) but that address is rewritten
> >>> (probably by kernel), so we really cannot implement
> >>> reading bootreason in kernel.
> >>>=20
> >>> But in early stage in uboot it is possible to read
> >>> 0x4020FFB8 address and get some part of bootreason. But
> >>> still PRM_RSTST is not enough!
> >>>=20
> >>> I would be happy if DT kernel can export /proc/atags file
> >>> with ATAGs passed by bootloader. It would be enough for
> >>> me. In userspace I can parse content and do what is
> >>> needed.
> >>=20
> >> What about defining a DT boot reason property instead?
> >> Maybe it already exists?  If not, it's something that could
> >> certainly be generically used on other platforms too.
> >=20
> > I'm fine with that, but we just need to have a standard
> > kernel userspace interface in addition to something like
> > /proc/device-tree/bootreason. Perhaps this can be the
> > default implementation for the watchdog dev. Someday when
> > we decide DT is crap and have a new boot interface, we'll
> > have people relying on /proc/device-tree. I hope to be
> > retired when that happens=E2=80=A6
>=20
> but if we try to do this generic, where will you store the
> boot mode
>=20
> I mean where the SoC boot from
>=20
> useful to for the Userspace to known where is the bootloader
> in case of multi boot mode
>=20
> Best Regards,
> J.
>=20
> > Rob
> >=20

I think in this discussion we are mixing two parts which should=20
be designed & solved separately.

1) How should bootloader tell to kernel what is bootreason

2) How should kernel export bootreason to userspace

In modern x86 laptop world bootreason can be requested from=20
BIOS/WMI/firmware by special proprietary vendor specific command.

So we should not lock bootreason to DT or ATAG only. Or only=20
bootloader --> kernel transition. For other platforms, board or=20
even architectures (x86) there can runtime way (for kernel) how=20
to read bootreason...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1655463.n3zj3Ha6pd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTJOaEACgkQi/DJPQPkQ1Jg3wCeNVejofKXe0mpmaoymaI0wtDA
y0wAniohOlrtT4LKIBDKfhrvM0DOSEBr
=kgH+
-----END PGP SIGNATURE-----

--nextPart1655463.n3zj3Ha6pd--
