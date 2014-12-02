Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaLBImv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:42:51 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:44224 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaLBImu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:42:50 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
Date: Tue, 2 Dec 2014 09:42:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com> <20141125230527.GC32102@vmdeb7>
In-Reply-To: <20141125230527.GC32102@vmdeb7>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1479229.hdbJjEJ0jK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412020942.47091@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1479229.hdbJjEJ0jK
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 26 November 2014 00:05:28 Darren Hart wrote:
> On Sun, Nov 23, 2014 at 04:09:18PM +0100, Pali Roh=C3=A1r wrote:
> > This patch series add new acpi Dell Airplane Mode Switch
> > driver (DELLABCE and DELRBTN acpi devices). It provides
> > radio HW switch events (together with current state of
> > radio devices) and export them via rfkill interface. These
> > events are also used in dell-laptop driver instead i8042
> > filter hook function (when acpi device is available).
> >=20
> > Pali Roh=C3=A1r (3):
> >   platform: x86: dell-rbtn: Dell Airplane Mode Switch driver
> >   platform: x86: dell-rbtn: Export notifier for other kernel
> >   modules platform: x86: dell-laptop: Use dell-rbtn instead
> >   i8042 filter when
> >  =20
> >     possible
> > =20
> >  drivers/platform/x86/Kconfig       |   14 ++
> >  drivers/platform/x86/Makefile      |    1 +
> >  drivers/platform/x86/dell-laptop.c |   67 +++++++++-
> >  drivers/platform/x86/dell-rbtn.c   |  260
> >  ++++++++++++++++++++++++++++++++++++
> >  drivers/platform/x86/dell-rbtn.h   |   35 +++++
> >  5 files changed, 372 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/platform/x86/dell-rbtn.c
> >  create mode 100644 drivers/platform/x86/dell-rbtn.h
>=20
> Alex, it is my understanding that this solution from Pali is a
> more complete solution to dealing with the variety of dell
> wireless buttons and rfkill mechanisms in the world today.
>=20
> I currently have:
> 7c4d961 dell-wireless: new driver for dell wireless button for
> Windows 8 queued in for-next. If I have read your responses
> on this correctly, are we all in agreement that I should drop
> the above patch, and apply these?

Darren, it it truth that some laptops does not send keypress=20
event when Fn+wifi key is pressed (but only send ACPI event),=20
then really Alex's patch for input device is needed. But it could=20
be integrated into my driver. Also Alex wrote something about=20
ACPI events for laptops which have wifi key instead HW switch. So=20
before including this patch into tree, I would like to hear what=20
is problem with my patch for laptops which have wifi key...

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1479229.hdbJjEJ0jK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlR9e4cACgkQi/DJPQPkQ1KqUwCfVzt+HgkHsPlzhzU7VcS6DOk2
XuoAnRZtlmOAl4Gskk+mFAID1MXTqhJt
=ozOO
-----END PGP SIGNATURE-----

--nextPart1479229.hdbJjEJ0jK--
