Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbbAKAXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 19:23:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56816 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750787AbbAKAXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 19:23:21 -0500
Message-ID: <1420935783.2327.28.camel@decadent.org.uk>
Subject: [3.2-stable] Suspend regression after "x86, mm: Set NX across
 entire PMD at boot"
From: Ben Hutchings <ben@decadent.org.uk>
To: Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Sun, 11 Jan 2015 00:23:03 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LedRT/hfiCSvPRO7X/qj"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LedRT/hfiCSvPRO7X/qj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit 45e2a9d4701d8c624d4a4bcdd1084eae31e92f58 ("x86, mm: Set NX across
entire PMD at boot") has been backported to many stable branches:

v3.10.62: 0b15c16c4f4a x86, mm: Set NX across entire PMD at boot
v3.12.35: 868b19cb0314 x86, mm: Set NX across entire PMD at boot
v3.14.26: 1a829c59816e x86, mm: Set NX across entire PMD at boot
v3.17.5: 6231385167e0 x86, mm: Set NX across entire PMD at boot
v3.2.65: a5c187d92d2c x86, mm: Set NX across entire PMD at boot
v3.13.11-ckt12: 3657489f7009 x86, mm: Set NX across entire PMD at boot
v3.16.7-ckt3: de32229b546e x86, mm: Set NX across entire PMD at boot

Unfortunately, in 3.2.65 suspend/resume stopped working on at least some
systems - specifically, the system would reboot when woken:

https://bugs.debian.org/774436 - Lenovo ThinkPad T530
https://bugs.debian.org/774461 - Lenovo ThinkPad X230
https://bugs.debian.org/774526 - ECS P4M900T-M2
https://bugs.debian.org/775059 - ASUS X201EP

I could reproduce this on my own ASUS P8Z68-V LX and was able to bisect
to the backport of this commit.

Assuming that this regression has not occurred on mainline or the other
branches, I will revert this patch for 3.2.y unless someone can point
out a missing dependency that I should apply.

Ben.

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-LedRT/hfiCSvPRO7X/qj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVLHCb+e/yOyVhhEJAQrBog/+M9UyK4Uz94fYGHjqlgRqlYhN+Q3VaCke
M1OTqvfALgNhO1FOQuxyk4HaATy4vBKwAX0QJtlbEQwx33QSB49vmccXiCgvTkpB
ndAqPZTZBTsUBY91yLU2YdblMwM3LOxRPt4ALmNCJhbg9dVKvcVkMZoQXif+ab29
tgvvPX/mAerYz/vC7Ml0TExbHlPwlaMBeEPSzq1CzV/QNL9Lseh67xbrt2HuELwT
Obm6k9wjM5N7mUVxsqjyhV6jJzdlzEdNZiKls5IXqa1A2GHuN3hGa85aJzEwQ/+K
JAnJqb+9Wtq4Z4XOZXZM5Fr22hVvD1di53OAwEp1KE8eHdWb4ewowF1txNrIPDOk
NQfCt+aJLrkBydxn2izoHZkti7QH0MSErvAcQEJSgqbZZ0WfOHSkqi/esihCSXMB
pF7HIzTVM8hlWBD9lRYY6vid+5eYwH3JwqhhLerB0H2S//e4rNnsFDUm8e3EH7mf
U9r+Hwzd9qKh5JONa2smVDDkMeWn1/f/tWLuIEfAYiiaC8JcKgSW9ZxkUPJnkd2B
cqllB8q5RFQg1erWiVRPbLBnCLWHSj8vTjQrxTNx0j5bbmEgcL+/TtFzIj56K5pb
Fz0khBmb3FNz2qzSLvtY6wS/KZIbgs+p0hoPz3gXCwHERr7WyTIiL1j39M/jlOLM
XFKFaEzCXgU=
=e/i1
-----END PGP SIGNATURE-----

--=-LedRT/hfiCSvPRO7X/qj--
