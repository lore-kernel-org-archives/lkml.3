Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaILJ6I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:58:08 -0400
Received: from sauhun.de ([89.238.76.85]:60480 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaILJ6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:58:06 -0400
Date: Fri, 12 Sep 2014 11:58:21 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Marc Dietrich <marvin24@gmx.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Andrey Danin <danindrey@mail.ru>, devicetree@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 4/4] ARM: shmobile: r8a7790: adapt DTS for I2C slave support
Message-ID: <20140912095821.GB1930@katana>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de>
 <9935938.eKOCvCAtLt@fb07-iapwap2>
 <20140912083348.GA1289@katana>
 <7627175.tG5quZH0VN@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <7627175.tG5quZH0VN@fb07-iapwap2>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> ok, take our embedded controller driver (in staging/nvec) as an example. =
It's=20
> basicly an MFD connecting keyboard, mouse, power, gpio, and some other st=
uff=20
> to the soc. The MFD operates in master mode while the SOC is the I2C slav=
e.=20
> Theoretically, these roles could also switch (but that's not defined in t=
he=20
> nvec protocol).

I see these cases currently:

1) my current case

The I2C slave is not needed for board bringup, mainly for development or
playing around. It can have this or that functionality on this or that
address. -> does not belong into DT, should be done in userspace

2) Slave mode is needed for board bringup

Some other components need a specific I2C slave to be present before
userspace is available, otherwise the system is unusable. This is IMO
then a hardware description and justifies DT entries:

DT pseudocode:

	i2c {
		compatible =3D "nvidia, tegra-i2c";

		ec-slave@42 {
			compatible =3D "nvidia, ax100-ec-slave";
			reg =3D <0x42>;
		};
	};

Of course, an MFD driver providing "nvidia, ax100-ec-slave" is needed
which uses the I2C slave mode of the tegra controller.

3) Master + slave mode is needed for board bringup:

Again, IMO a hardware description, so we could use:

	i2c {
		compatible =3D "nvidia, tegra-i2c";

		ec@64 {
			compatible =3D "nvidia, ax100-ec";
			reg =3D <0x64>;
		};
	};

This is a standard I2C device driver (using the MFD framework) where
i2c-tegra would act as a master on the client for 0x64. However, its
probe function can fill an i2c_board_device (the driver should know the
slave device address because of the protocol), get a new client using
i2c_new_device, and register that as a I2C slave client. It then has an
address where it listens and an address where it can send to. When to do
what is protocol implementation.


Am I missing something? Board properties can be encoded within the
compatible entries ("ax100-ec", "ax200-ec"...). I'd think this means
mostly different protocols, though.


--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEsO9AAoJEBQN5MwUoCm2CX8P/26YJnJi+R06TSHAzWpDOdH4
A21ApjwG4hruJDHfiXsI9cGoUku4uwnIErkIaWh5rHNFfmNRWmKqAxyVh7Lccv9Z
rPII8I17sSHEDPIdbg4nHdijrVpD9TPVIZiGiGSeMmFV+iYbaFCMJuajDxxfbMe7
JpXztCFp6buPAjYUAEbnlYEZpegvI1n3etsyvSkY/SgM5aTE9Ut6WSfa1S0Y9ERj
I5y7YGv9o30hYe5p+KfPqajFicasiybAfpzRgDpaXtGVORsicr+2NNA7PkLmTpS3
mOCtDaFNP7+QROgm6M5iK3Ki8gzHGDpC3J6r1eZknmIDLDJNaarXQPJ6dhHX2EEy
CiO7MsxgBHd0HMilgeApjbzCLt43QcztNurWNTicYtNx7X+t97jHBxXlWwEqXr1W
vAY9cDDBKIQ/NIrsg0MLoeRXebxkcJYBqx0WAVPLXj691p1+ZzfePfxTBEE8PjTq
60waT2owTSbE+yPuwjS4o/FmfIQM9DipBcfsn/uK5K4p4YARhcJ3LqHsuWWA66s8
BYeJdoJVcQoev1mxe/cJXIwD0KcNTWDAV7ufzV2qLTnRu21V7qpHdir0bWakzeSF
jnyNUijBMdzxwXoTEGnvjtfVQJxQkwWexZQgCrLn4Omd6iU/v3AWtI69V3lXPNdL
YYKHDXmo/WkzHMC1jnQ2
=O3vC
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
