Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaKZMrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:47:35 -0500
Received: from sauhun.de ([89.238.76.85]:41623 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaKZMrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:47:33 -0500
Date: Wed, 26 Nov 2014 13:49:01 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Stijn Devriendt <highguy@gmail.com>, linux-i2c@vger.kernel.org,
        linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 2/3] i2c: slave-eeprom: add eeprom simulator driver
Message-ID: <20141126124901.GB4397@katana>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
 <1416326695-13083-3-git-send-email-wsa@the-dreams.de>
 <CAOY=C6FSXWn2AKn9gp0oU69U8VkkyJAE7MMUTZsToy0P_Tf6AA@mail.gmail.com>
 <20141122181229.GB9698@katana>
 <2A7C987F-15E0-46FD-A711-E7F5BA9893FC@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <2A7C987F-15E0-46FD-A711-E7F5BA9893FC@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 26, 2014 at 03:25:29PM +0300, Alexander Kochetkov wrote:
>=20
> 22 =D0=BD=D0=BE=D1=8F=D0=B1. 2014 =D0=B3., =D0=B2 21:12, Wolfram Sang <ws=
a@the-dreams.de> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> > IMO a repeated start is to ensure that two messages arrive at the slave
> > without interruption from another master. I can't think why a slave
> > should know which type of start that was. In fact, if it does that would
> > raise an eyebrow for me. Do you have an example?
>=20
> It is used to implement Device ID reading.

Yes and no, I'd say :) Technically, it needs repeated start. But really,
the hardware should handle this (and I know one IP core which has
support for it). One could try to simulate the behaviour in the bus
driver IF a second slave address AND detection of repeated start is
available, but I doubt this combination exists.

Still, all the _slave driver_ needs to handle is an
I2C_SLAVE_EVENT_DEVICE_ID which should return the apropriate value.

That being said, I have never seen querying Device ID in action.

> Not sure, that the feature is really needed for the first release.

I am sure it is not :D

Thanks,

   Wolfram


--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdcw9AAoJEBQN5MwUoCm2qxoQAIl08hAkuy5kOMxeI4dU/Q6y
hi1BQhXGh0dkdmFYChU5czJKLlN0OJNLxSJOE5RWV4w1n4XxoOTQn8i9uDhRrj3F
yfYe7achb8kPbRUl//VeV1oo9isAY7hEbCe0V0vNlsjoxKac8/Xceg1Fs0qA4vOE
hoQA+cZsXvJtfzj4axmMFOYpwUtoVomF1XF6OgrV/Bs0d595w28CwGeeiWQvn1Bo
daY2adI7VwfPt3xu39YdjFlOdyfmZY4s7UmjDu63nF5lgwmDTPBnJSXsKhvYa61Q
+CLZORfua/0HhUKGH+NFMIhgg5+2XnqWW7z+tW+n7oNX05oMmmEWuFLZWdWjHJua
atMLHRjIeMXXxeD+JC9F/aDnw5TnvnNSFbm737QbZ2rJLvEr/0P2YIkL8h7W9ejk
iTFpbqPQGEONowq3+kSYIcb22YPaPyG5U0K+DdRfX46LJahAkiey7Cq4eOi9WbjD
fZgDDvIQUT55LrpBjrf0RfhkqZlL64C2wmlUFP6Ia8NIM3rnq1R6ZKicpToNmlRu
NdLfV+YRL4fIwgLs6i4oLtGc/rWTDqFz7T1PbF6RVXpXddNL3R3AoWqQI6ZYx8+7
s8sIbO2cytAnJRZu7hYptJIF99QY1zdiJRLKP76YxKKq72syfN/XO/IUUtXCnX4L
zuCs7DtbhsO1MpDbZWVd
=DsTe
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
