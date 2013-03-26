Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934605Ab3CZPCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:02:50 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:41014 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934581Ab3CZPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:02:45 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Date: Tue, 26 Mar 2013 16:02:39 +0100
User-Agent: KMail/1.13.7 (Linux/3.5.0-27-generic; KDE/4.10.1; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
References: <201302170046.26569@pali> <201303242345.00176@pali> <20130324230435.GE18316@opensource.wolfsonmicro.com>
In-Reply-To: <20130324230435.GE18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1383653.J21SygAyYt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201303261602.40219@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1383653.J21SygAyYt
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 25 March 2013 00:04:37 Mark Brown wrote:
> On Sun, Mar 24, 2013 at 11:44:59PM +0100, Pali Roh=C3=A1r wrote:
> > On Sunday 24 March 2013 23:14:46 Mark Brown wrote:
> > > Well, you should seek support from the board vendor then.
> >=20
> > Not possible. Nokia is already using Windows Phones and life
> > cycle for Nokia N900 phone is at the end. And Nokia never
> > released any HW documentations to community...
>=20
> There may well still be people with the required information,
> though in general this sort of thing is always going to be a
> hazard when working on undocumented hardware.
>=20
> > Another question: what was reason for that commit
> > ec400c9fab99d16a491cea17d27d0c6a5780b97c
> > "lis3lv02d: make regulator API usage unconditional" ?
>=20
> Failing to provide power to a device is typically a very
> serious problem for device operation but the code that was
> there handles such errors by ignoring them.  This isn't a
> robust way forwards and such code should never have been
> merged in the first place, as the changelog says the
> regulator core provides a number of facilities for stubbing
> itself out when it is not required which boards should use.
>=20
> Handling the possibility that supplies may not be there not
> only creates needless repetitive complexity in device drivers
> but also decreases the robustness of the system since error
> handling for access to powered down devices often isn't very
> pretty and other drivers or the core may disrupt the
> operation of the device by for example powering it down due
> to not thinking it's in use.
>=20
> > I think that for N900 support is reverting above commit
> > needed, I do not see other solution...
>=20
> If you're convinced that the regulator is kept on for some
> reason you could always just provide a fake supply, though
> obviously it would be better to hook up the real regulator
> since this may break if at some point the kernel decides that
> whatever is actually providing the supply is unused and can
> be turned off.

CCing Aaro and Tony. Look at this thread on:=20
https://lkml.org/lkml/2013/2/16/152

What do you think how to fix this problem? I do not know about any=20
HW regulator for n900 accelerometer and possible solutions could=20
be revert that commit or adding fake regulator to board code...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1383653.J21SygAyYt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlFRuJAACgkQi/DJPQPkQ1Km5wCgivKiRSSX4eJtNvfkL6MQHKMy
Z2UAn2igBT1dC52Vv0fek3x0b6cUgKq3
=VQlR
-----END PGP SIGNATURE-----

--nextPart1383653.J21SygAyYt--
