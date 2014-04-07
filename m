Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaDGJKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:10:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46755 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754182AbaDGJKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:10:13 -0400
Date: Mon, 7 Apr 2014 11:09:08 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Curt Brune <curt@cumulusnetworks.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Laszlo Papp <lpapp@kde.org>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] Create eeprom_dev hardware class for EEPROM
 devices
Message-ID: <20140407090908.GE3926@lukather>
References: <1390504562-20333-1-git-send-email-curt@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PPYy/fEw/8QCHSq3"
Content-Disposition: inline
In-Reply-To: <1390504562-20333-1-git-send-email-curt@cumulusnetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PPYy/fEw/8QCHSq3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 23, 2014 at 11:16:01AM -0800, Curt Brune wrote:
> Create a new hardware class under /sys/class/eeprom_dev
>=20
> EEPROM drivers can register their devices with the eeprom_dev class
> during instantiation.
>=20
> The registered devices show up as:
>=20
>   /sys/class/eeprom_dev/eeprom0
>   /sys/class/eeprom_dev/eeprom1
>   ...
>   /sys/class/eeprom_dev/eeprom[N]
>=20
> Each member of the eeprom class exports a sysfs file called "label",
> containing the label property from the corresponding device tree node.
>=20
> Example:
>=20
>   /sys/class/eeprom_dev/eeprom0/label
>=20
> If the device tree node property "label" does not exist the value
> "unknown" is used.
>=20
> Note: The class cannot be called 'eeprom' as that is the name of the
> I/O file created by the driver.  The class name appears as a
> sub-directory within the main device directory.  Hence the class name
> 'eeprom_dev'.
>=20
> Userspace can use the label to identify what the EEPROM is for.
>=20
> The real device is available from the class device via the "device"
> link:
>=20
>   /sys/class/eeprom_dev/eeprom0/device

Sorry for stepping up this late, but I've been working on an eeprom
framework recently to move all the duplication that exists in the
eeprom drivers (such as sysfs file creation, in kernel accessors) to
common code. And part of that work was to create a eeprom class.

The only feature that's missing from your code is the label, but I
guess it can easily be added, and makes sense.

I'm not quite fond of some of the API yet, particularly on the in
kernel side, but I guess I can post what I have so far as an RFC and
get the discussion started.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--PPYy/fEw/8QCHSq3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTQms0AAoJEBx+YmzsjxAg030P/iWxVceoF4i9h61X+ck5R32z
9bVs1tiXc7DcN9FGjtREQErtlEG6PmAvCfcJ+No+Mdj/FbIajBZFLI3qva4NtQ3f
yIX6I0KxWiFkzZ7yLYtQ76+nAoCC4Z2vL3PeYWNADYVMfodCyGBVVUGNi82pLl/5
tYPnKNgHxajIkh3j4UV3FGzqQCfOOKA7D4DewacQ6wgFh4dDPhxr8pdc8LX7jEnZ
y8xG96PS1Xb8YZnFmczYOmcH/Ig32PYeoMubfThfLhnfHuaqNZoiW5BBPI15323E
ScjnRHeGOQNKoI5UPI5fIr442eKctp00bhOMxzNs+R/8yP63JEnzYSXlvhblhVXe
Q0SbJvGWZgsbwTYO6aixbG/rA/BkhqfXOz2b49/R3p9JfNunSQ4wdwzJtu4toy6g
Z8rxsDmsj1EaEco1T4+OeeAqIcdMtyWCgYusX7SLvQJadM4hbOVNMT14gE5/UUHs
MM/OLcyUZkV/8P8TR0h6ZE88KmKVWbD/DsWeKeOomSoLUS9+HfaPlADKvWXo0jk6
v6bdhuiBYsY4EjZepvgSycKP+4Jkl9kWuDxiQw4JrOlLisonBzcAP1DHKQkF0O+9
7RScc/qFI0PBR6lCKKMRUKM55kp3qThG0ItQNZ29ERT8qFs5e71I/9DGcqtmQI9F
5WdRRxzXt997C+tZOICI
=AqjK
-----END PGP SIGNATURE-----

--PPYy/fEw/8QCHSq3--
