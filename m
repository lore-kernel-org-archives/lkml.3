Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaLDJzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:55:42 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:35183 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaLDJzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:55:36 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
Date: Thu, 4 Dec 2014 10:55:32 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.1; x86_64; ; )
Cc: Darren Hart <dvhart@infradead.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com> <201412020942.47091@pali> <CAJ=jqua+xpXyhkjiLrxZ9Cy9D-kwXXP=hB1az+kC+RUn1PN0Bw@mail.gmail.com>
In-Reply-To: <CAJ=jqua+xpXyhkjiLrxZ9Cy9D-kwXXP=hB1az+kC+RUn1PN0Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9849332.ijRrVR8qXx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412041055.32689@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9849332.ijRrVR8qXx
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 04 December 2014 09:16:25 Alex Hung wrote:
> HI Darren and Pali,
>=20
> It was great that we had a lot of discussion but it seems Dell
> BIOS implementation varies from one series to another. Both
> work looks good either one is fine with me.
>=20

Alex, am I right that your dell-wireless.c do nothing for laptops=20
with HW switch (when CRBT returns 2 or 3)?

If yes, then for these laptops we do not need dell-wireless.c and=20
my dell-rbtn.c is better.

> But I think I can do a little more: I am collecting a number
> of systems to try out these patches. This should help us
> determine which one work better and probably we can
> integrate.
>=20

Yes, sure.

> Currently I have found four systems (including two Latitude,
> an Inspiron and a XPS with working method(ARBT) that Gabriele
> suggested). I can get other, ex. a Vostro, if needed.
>=20

Do you know what should ARBT method do?

> I will test dell-wireless.c with Gabriele's suggestion and
> Pali's dell-rbtn.c (btw, will there be updates?). However, I
> will need a few days to do the comparison.
>=20

Until we would know how to *properly* set soft rfkill state and=20
what ARBT is doing on more machines, I'm not going to update my=20
dell-rbtn.c (as it is for now complete).

Darren, I think that if we do not solve problem with duplicate=20
key events (in dell-wireless.c) we should postpone these patches=20
to later kernel version. It is better to not have such regression=20
as it confuse software like NetworkManager which is widely used.

> Any suggested test cases?
>=20

Check if wlan key is reported via WMI or AT Keyboard also without=20
dell-wireless.c.

Check if dell-rbtn.c show correct hard rfkill state (on all=20
tested machines) when pressing wlan key more times (or switching=20
HW-slide switch).

> Cheers,
> Alex Hung
>=20
> On Tue, Dec 2, 2014 at 4:42 PM, Pali Roh=C3=A1r=20
<pali.rohar@gmail.com> wrote:
> > On Wednesday 26 November 2014 00:05:28 Darren Hart wrote:
> >> On Sun, Nov 23, 2014 at 04:09:18PM +0100, Pali Roh=C3=A1r wrote:
> >> > This patch series add new acpi Dell Airplane Mode Switch
> >> > driver (DELLABCE and DELRBTN acpi devices). It provides
> >> > radio HW switch events (together with current state of
> >> > radio devices) and export them via rfkill interface.
> >> > These events are also used in dell-laptop driver instead
> >> > i8042 filter hook function (when acpi device is
> >> > available).
> >> >=20
> >> > Pali Roh=C3=A1r (3):
> >> >   platform: x86: dell-rbtn: Dell Airplane Mode Switch
> >> >   driver platform: x86: dell-rbtn: Export notifier for
> >> >   other kernel modules platform: x86: dell-laptop: Use
> >> >   dell-rbtn instead i8042 filter when
> >> >  =20
> >> >     possible
> >> > =20
> >> >  drivers/platform/x86/Kconfig       |   14 ++
> >> >  drivers/platform/x86/Makefile      |    1 +
> >> >  drivers/platform/x86/dell-laptop.c |   67 +++++++++-
> >> >  drivers/platform/x86/dell-rbtn.c   |  260
> >> >  ++++++++++++++++++++++++++++++++++++
> >> >  drivers/platform/x86/dell-rbtn.h   |   35 +++++
> >> >  5 files changed, 372 insertions(+), 5 deletions(-)
> >> >  create mode 100644 drivers/platform/x86/dell-rbtn.c
> >> >  create mode 100644 drivers/platform/x86/dell-rbtn.h
> >>=20
> >> Alex, it is my understanding that this solution from Pali
> >> is a more complete solution to dealing with the variety of
> >> dell wireless buttons and rfkill mechanisms in the world
> >> today.
> >>=20
> >> I currently have:
> >> 7c4d961 dell-wireless: new driver for dell wireless button
> >> for Windows 8 queued in for-next. If I have read your
> >> responses on this correctly, are we all in agreement that
> >> I should drop the above patch, and apply these?
> >=20
> > Darren, it it truth that some laptops does not send keypress
> > event when Fn+wifi key is pressed (but only send ACPI
> > event), then really Alex's patch for input device is
> > needed. But it could be integrated into my driver. Also
> > Alex wrote something about ACPI events for laptops which
> > have wifi key instead HW switch. So before including this
> > patch into tree, I would like to hear what is problem with
> > my patch for laptops which have wifi key...
> >=20
> > --
> > Pali Roh=C3=A1r
> > pali.rohar@gmail.com

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart9849332.ijRrVR8qXx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSAL5QACgkQi/DJPQPkQ1KI0ACdGEmgmlOiSzjiekrpzQK7ljLq
+VEAnjmUoqyNy81oxHCNhuZq4TkgBxyP
=e+mO
-----END PGP SIGNATURE-----

--nextPart9849332.ijRrVR8qXx--
