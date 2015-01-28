Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964781AbbA2C2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:28:31 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:55507 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbbA2C22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:28:28 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: /proc/atags: Export also for DT
Date: Wed, 28 Jan 2015 16:47:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com> <alpine.LFD.2.11.1501280925400.1322@knanqh.ubzr> <20150128153912.GL28663@atomide.com>
In-Reply-To: <20150128153912.GL28663@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3104303.ZTbsPZbygC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201501281647.34477@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3104303.ZTbsPZbygC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 28 January 2015 16:39:13 Tony Lindgren wrote:
> * Nicolas Pitre <nico@fluxnic.net> [150128 06:37]:
> > On Wed, 28 Jan 2015, Pali Roh=C3=A1r wrote:
> > > On Wednesday 28 January 2015 01:50:33 Tony Lindgren wrote:
> > > > On omaps, the bootrom passes the bootreason in r1 to the
> > > > bootloader that can do whatever it wants with it. We
> > > > could maybe pass it in the kernel cmdline to the
> > > > watchdog driver for user space?
> > >=20
> > > Not truth for N900. Bootreason depends on PRM_RSTST omap
> > > register, state of vbat charger pins, time how long was
> > > power key pressed, R&D data stored in CAL partition and
> > > other undocumented registers for omap HS devices. I
> > > already tried to implement at least some subset of it in
> > > userspace (or kernel), but it is impossible because NOLO
> > > bootloader clear status of PRM_RSTST register.
> > >=20
> > > There is also copy of PRM_RSTST register stored at address
> > > 0x4020FFB8 (tracing data) but that address is rewritten
> > > (probably by kernel), so we really cannot implement
> > > reading bootreason in kernel.
> > >=20
> > > But in early stage in uboot it is possible to read
> > > 0x4020FFB8 address and get some part of bootreason. But
> > > still PRM_RSTST is not enough!
> > >=20
> > > I would be happy if DT kernel can export /proc/atags file
> > > with ATAGs passed by bootloader. It would be enough for
> > > me. In userspace I can parse content and do what is
> > > needed.
> >=20
> > What about defining a DT boot reason property instead?
> > Maybe it already exists?  If not, it's something that could
> > certainly be generically used on other platforms too.
> >=20
> > Converting the special ATAG into its standard DT equivalent
> > would then be trivial and much cleaner overall.
>=20
> Sounds good to me as then we don't have to add any legacy
> custom Nokia specific atag. And it won't prevent us from
> adding a generic ATAG_BOOTREASON if really needed.
>=20
> Regards,
>=20
> Tony

And what would new atag ATAG_BOOTREASON solve for Nokia N900?=20
Nothing.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3104303.ZTbsPZbygC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTJBJYACgkQi/DJPQPkQ1LLzgCfVnuePMyFGXbrEd/mS/EyetT5
/ecAnRAVs7t3LjLFJ2ArZYTCPMz56G9Q
=U8ek
-----END PGP SIGNATURE-----

--nextPart3104303.ZTbsPZbygC--
