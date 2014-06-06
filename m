Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaFFMcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:32:20 -0400
Received: from sauhun.de ([89.238.76.85]:54161 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbaFFMcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:32:17 -0400
Date: Fri, 6 Jun 2014 14:32:14 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c/ACPI: Support for multiple serial bus addresses
Message-ID: <20140606123214.GB2810@katana>
References: <1397189717-30657-1-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <1397189717-30657-1-git-send-email-srinivas.pandruvada@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2014 at 09:15:16PM -0700, Srinivas Pandruvada wrote:
> ACPI specification allows multiple i2c addresses defined under one
> ACPI device object. These addresses are defined using _CRS method.
> The current implementation will pickup the last entry in _CRS, and
> create an i2C device, ignoring all other previous entries for addresses.
>=20
> The ACPI specification does not define, whether these addresses for one
> i2c device or for multiple i2c devices, which are defined under the same
> ACPI device object. We need some appoach where i2c clients can enumerate
> on each of the i2C address and/or have access to those extra addresses.
>=20
> This change addresses both cases:
> - Create a new i2c device for each i2c address
> - Allow each i2 client to get addresses of all other devices under
> the same ACPI device object (companions or siblings)
>=20
> Example 1:
> Here in the following example, there are two i2C address in _CRS.
> They belong to two different physical chipsets, with two different i2c
> address but part of a module.
> Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
> {
>         Name (RBUF, ResourceTemplate ()
>         {
> 		I2cSerialBus (0x0068, ControllerInitiated, 0x00061A80,
> 			AddressingMode7Bit, "\\_SB.I2C5",
> 			0x00, ResourceConsumer, ,
> 		)
> 		I2cSerialBus (0x000C, ControllerInitiated, 0x00061A80,
> 			AddressingMode7Bit, "\\_SB.I2C5",
> 			0x00, ResourceConsumer, ,
> 		)
> 		Interrupt (ResourceConsumer, Level, ActiveHigh, Shared, ,, )
> 		{
> 			0x00000044,
> 		}
> 	})
> 	Return (RBUF)
> }
> This change adds i2c_new_device for each i2c address. Here contents of
> /sys/bus/i2c/devices will
> 	i2c-some_acpi_dev_name:00:068
> 	i2c-some_acpi_dev_name::00:00c
>=20
> Example 2
>=20
> Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
>                 {
>                     Name (SBUF, ResourceTemplate ()
>                     {
>                         GpioIo (Exclusive, PullDefault, 0x0000, 0x0000, I=
oRestrictionOutputOnly,
>                             "\\_SB.GPO1", 0x00, ResourceConsumer, ,
>                             )
>                             {   // Pin list
>                                 0x0018
>                             }
>                         I2cSerialBus (0x0010, ControllerInitiated, 0x0006=
1A80,
>                             AddressingMode7Bit, "\\_SB.I2C4",
>                             0x00, ResourceConsumer, ,
>                             )
>                         I2cSerialBus (0x000C, ControllerInitiated, 0x0006=
1A80,
>                             AddressingMode7Bit, "\\_SB.I2C4",
>                             0x00, ResourceConsumer, ,
>                             )
>                         I2cSerialBus (0x0054, ControllerInitiated, 0x0006=
1A80,
>                             AddressingMode7Bit, "\\_SB.I2C4",
>                             0x00, ResourceConsumer, ,
>                             )
>                     })
>                     Return (SBUF) /* \_SB_.I2C4.CAM1._CRS.SBUF */
>                 }
> }
> Here there are three i2c addresses for this device.
>=20
> When there is only I2cSerialBus address is present then there is no
> change. The device name will not include address. In this way if
> some device is using hardcoded path, this change will not impact them.
>=20
> Here any i2c client driver simply need to add ACPI bindings. They will
> be probed multiple times, the client will bind to correct i2c device,
> based on checking its identity and returning error for other.
> At the same time, any i2c client can call i2c_for_each_acpi_comp_client
> to get the i2c client instances of companion addresses defined
> under the same ACPI device.
>=20
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

Sorry that I need to postpone the ACPI related stuff to the next release
cycle (where it has priority). It was simply too much for this one.

Mika: Your review for ACPI specific details would be much appreciated
here.

Thanks,

   Wolfram


--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTkbTOAAoJEBQN5MwUoCm2QEMQAKWscKUfNrOil/h3s4Ji4jWn
8w736GHR0SOIaDvWmiWn1857yJS4mDY7vuVJjCOEKoGqifNUnx3bIFnRl9WJjzRq
xftvfOMSl35RftIyJ2m9kOH9YYhO9IdAknCpTR1wx2kcRtwcMUgfjJdMW1OT0ynT
51+LYMJ8Yurn7ECinGyynmot1u+36lqDiwu18YzAAlm8NWW2bLwF4nqUQIPuUeSm
fAYvlVfqbDwReXQnoJGEi4ssg7MVPXzun+7HSMHH+jBQEe2HIX1w4ZsjTvDP9Zq4
gHepxHs7VHm+n8ZOEh9Ek+UmQ+wGHsFyA2qHpFsM/hVgHIZmk0SEd59/OC1V+7yj
9camVXah4m3jBo49iHboNcE2EELqCjohFZo6T8jt+ETEDfbO6kqH+a2W8YSOpTBO
wzi0cG/9nsKv6CPIiheodEC3i3uYYQ3NvqZ0Mo+dLOEH9VM/Lsx5IZdv1LfYyv21
ri8KfSovP8X/bJSnivtiHI4fm14/A+qYIjbbnLx2oIPZkJwlqSt9+jeF8cy2/xV8
wgB5wkr2/tUn2HtHL6MkiExU+LslC12OG27504GAkQfB0uYxHUuHdUjzW8c6hpM1
x/Xp92CNbBlJp1kfKUVTESS2wMF0gYpgrIVsBKVJwxZHpSTDhQSvLK7UifmK/uMz
JzPMXR6H8cSlsaAOD6XK
=6zXu
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
