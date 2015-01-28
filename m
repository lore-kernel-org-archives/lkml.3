Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802AbbA2CZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:25:39 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39727 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761773AbbA2CZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:25:31 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Wed, 28 Jan 2015 18:18:12 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr> <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+rESm8q44ABRbh9hqMsfcMNx0kcXJ5ONbn1=ue-RvHFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1640279.tHQtxVtTCh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501281818.12121@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1640279.tHQtxVtTCh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 28 January 2015 16:57:18 Rob Herring wrote:
> On Wed, Jan 28, 2015 at 8:33 AM, Nicolas Pitre=20
<nico@fluxnic.net> wrote:
> > On Wed, 28 Jan 2015, Pali Roh=C3=A1r wrote:
> >> On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
> >> > On omaps, the bootrom passes the bootreason in r1 to the
> >> > bootloader that can do whatever it wants with it. We
> >> > could maybe pass it in the kernel cmdline to the
> >> > watchdog driver for user space?
> >>=20
> >> Not truth for N900. Bootreason depends on PRM_RSTST omap
> >> register, state of vbat charger pins, time how long was
> >> power key pressed, R&D data stored in CAL partition and
> >> other undocumented registers for omap HS devices. I
> >> already tried to implement at least some subset of it in
> >> userspace (or kernel), but it is impossible because NOLO
> >> bootloader clear status of PRM_RSTST register.
> >>=20
> >> There is also copy of PRM_RSTST register stored at address
> >> 0x4020FFB8 (tracing data) but that address is rewritten
> >> (probably by kernel), so we really cannot implement
> >> reading bootreason in kernel.
> >>=20
> >> But in early stage in uboot it is possible to read
> >> 0x4020FFB8 address and get some part of bootreason. But
> >> still PRM_RSTST is not enough!
> >>=20
> >> I would be happy if DT kernel can export /proc/atags file
> >> with ATAGs passed by bootloader. It would be enough for
> >> me. In userspace I can parse content and do what is
> >> needed.
> >=20
> > What about defining a DT boot reason property instead?
> > Maybe it already exists?  If not, it's something that could
> > certainly be generically used on other platforms too.
>=20
> I'm fine with that, but we just need to have a standard kernel
> userspace interface in addition to something like
> /proc/device-tree/bootreason. Perhaps this can be the default
> implementation for the watchdog dev. Someday when we decide DT
> is crap and have a new boot interface, we'll have people
> relying on /proc/device-tree. I hope to be retired when that
> happens...
>=20
> Rob

Then what about exporting bootreason as /proc/bootreason?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1640279.tHQtxVtTCh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTJGdQACgkQi/DJPQPkQ1IBhACfcmmkfQJrRWhyw7o2mOEtdHjc
cToAniI+Vcfbus+6lrT+iQnnQSpp7/2R
=mHFo
-----END PGP SIGNATURE-----

--nextPart1640279.tHQtxVtTCh--
