Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaLEVD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:03:29 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40448 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaLEVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:03:28 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
Date: Fri, 5 Dec 2014 22:03:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Darren Hart <dvhart@infradead.org>, Alex Hung <alex.hung@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com> <201412052138.17092@pali> <3160202.BXgrhrDjJo@xps13>
In-Reply-To: <3160202.BXgrhrDjJo@xps13>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4042801.SVanky5oWb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412052203.25016@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4042801.SVanky5oWb
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 05 December 2014 21:53:10 Gabriele Mazzotta wrote:
> On Friday 05 December 2014 21:38:17 Pali Roh=C3=A1r wrote:
> > On Wednesday 03 December 2014 14:00:23 Darren Hart wrote:
> > > On Thu, Dec 04, 2014 at 10:55:32AM +0100, Pali Roh=C3=A1r wrote:
> > > > Darren, I think that if we do not solve problem with
> > > > duplicate key events (in dell-wireless.c) we should
> > > > postpone these patches to later kernel version. It is
> > > > better to not have such regression as it confuse
> > > > software like NetworkManager which is widely used.
> > >=20
> > > OK, that's what I needed. Thanks. Ignore my previous
> > > request, you answered it here. I will drop
> > > dell-wireless.c and look for a combined solution from you
> > > and Alex for the next release.
> > >=20
> > > Thanks,
> >=20
> > And according to discussion about Side effect of pressing
> > special keys at [1] [2] we should not report this wireless
> > key event (as input device) to userspace. And Alex's driver
> > is doing that.
> >=20
> > [1] -
> > http://www.spinics.net/lists/platform-driver-x86/msg05922.h
> > tml [2] -
> > http://www.spinics.net/lists/platform-driver-x86/msg05924.h
> > tml
>=20
> Alex's patch is for those laptop whose BIOS only sends a
> notification to DELLABCE when Fn keys are pressed. His patch
> simply translates these ACPI notifications to KEY_RFKILL
> keypresses.
>=20

Yes, and your last patch disables sending such KEY events to=20
userspace (in dell-wmi driver). BIOS already handle changes, so=20
key press should not be reported to userspace... [1] (from=20
previous email).

> Correct if I'm wrong, but shouldn't his patch have no effects
> on your laptop? If I'm not wrong, CRBT returns 2 on your
> laptop, so the input device is not even created. Am I missing
> something?
>=20
> Gabriele

Yes, it has no effect for my laptop.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4042801.SVanky5oWb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSCHZ0ACgkQi/DJPQPkQ1K6SgCglpOP8Ul65XIa8k1XjULg0Q6y
1s0An24e0B3LZQZRgiRtwArQOHG0xq5S
=kXrB
-----END PGP SIGNATURE-----

--nextPart4042801.SVanky5oWb--
