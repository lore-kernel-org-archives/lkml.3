Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbbAVAzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:55:05 -0500
Received: from mail.kernel.org ([198.145.29.136]:44717 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbbAVAzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:55:00 -0500
Date: Thu, 22 Jan 2015 01:54:49 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        pavel@ucw.cz, jenny.tc@intel.com
Subject: Re: [RFC PATCH 0/3] power: Generic interface to get battery
 specification.
Message-ID: <20150122005448.GK13715@earth.universe>
References: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="F55Y67F01HNW3AgB"
Content-Disposition: inline
In-Reply-To: <1412679518-21499-1-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F55Y67F01HNW3AgB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jonghwa,

On Tue, Oct 07, 2014 at 07:58:35PM +0900, Jonghwa Lee wrote:
> This patches contains supporting generic interface to get battery specifi=
cation
> and of-based battery driver which use the interface.
>=20
> Up to now, power supply subsystem assumes that battery's charartric data =
is
> static and also often left as fuelgauge's role. However, fuelgauge driver=
 or
> any power_supply driver can be worked with different battery with differe=
nt
> implementation and battery also can be changed even in runtime.
> If so, it needs to notify its change to all related power_supply drivers =
not
> let them notice all with private way. Thus, it tries to introduce generic
> interface for management of the battery specification.
>=20
> In addition to, for the smart battery, this'll help to abstract battery
> interface which can be varied with different batteries. (SDQ, MIPI BIF..)

Sorry it took me so long. Here are my thoughts regarding this
patchset:

1. Please introduce drivers/power/battery/*

As far as I understand it we will get another driver for getting the
information dynamically via MIPI BIF, SDQ, ... and drivers/power is
already quite messy. Next step is moving battery gauges and battery
chargers into their own directories, but than can come after
cleaning up the core.

2. Please use "-" instead of "_" in DT property names

3. We should add a compatible string for the battery. Maybe
something like "simple-battery"

4. I suggest to rename charge_full/empty to current_full/empty, so
that its about generic battery metadata and not charging metadata.

5. I assume temperature_max/temperature_min is used for non-charging
related safety trips (e.g. battery over temperature_max starts an
emergency shutdown).

6. Temperature based charging is most likely something we need in
the future. There are at least 3 temperature zones normally (too
cold for charging [but ok for general use]), (normal mode) and (too
hot for charging [but ok for general use]). Having a slow charging
mode before complete turnoff seems logic to me :)

Since its kind of hard to keep working on big patchsets (and also
not very nice for reviewing) I suggest to start with the basic
battery stuff and add the charging information afterwards.

-- Sebastian

--F55Y67F01HNW3AgB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUwEpVAAoJENju1/PIO/qafX4P/02Ei6NQJM+Q4q6373WUiBdD
2J4L35O5eZI6okXV3LQH28L1b0IcbvV9MCJpICJzszg9KN0VslSlAQsEur7vp5iY
+KgBdUBi0dvP7BMohZ4Vse21aGqDauk/pS5nrCde3rNY8A2IyqZkMyTfJwVVyBEQ
A1mzk3kvEXMxPe9xa4uJCQsvFKe8PcTGCfAMY2MibwVmkZgnQ1bs9RP+w618wGmZ
/aj57VCCLoeyQIxAoqUdBVSrL/Fvcy2cmYqnUW5/664eWVKkxbJAkfBJA1OMZKtp
VMcCMLYfm4iOhzlYjDQmoWRWnkRt8BSnx/3WhLxGTAfr/+aaVUHilJwnlixGiVZn
ocaNpWr0omvcO5zZp4cIPbJ41i+XDGM5VAYHgPUnDhLLqtb9rjQS3BVCgabsicUq
wDmC+gSxf/+BT95dQOuTNtt9qLlcHf7cSZEOln1ZMLi7h2PfJ4JVnLubEyGsPAq8
8Zicpu6oRrxh2iqhabGr5v3oMqmAGj2/2nXyjA7AJQP2LDNn3J/nQ+HwVZ6LxwVH
WjJTUq+ohaVwsSu+fX53+FTUp7wMT9Ba+5LYKD00Yhh8duEhJfXPUDd4OYdmHA32
ZSK6GM+CzL386cXo3xy7THYwuTDd16lTcZdhNnYbSrCNUN5buLvXSukWu9wpQ20p
MteSB6qb6s1lD+031jeL
=aSQK
-----END PGP SIGNATURE-----

--F55Y67F01HNW3AgB--
