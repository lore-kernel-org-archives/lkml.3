Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaILNqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:46:24 -0400
Received: from sauhun.de ([89.238.76.85]:33699 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbaILNqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:46:22 -0400
Date: Fri, 12 Sep 2014 15:46:32 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH RESEND 0/8] i2c: Relax mandatory I2C ID table passing
Message-ID: <20140912134632.GE1930@katana>
References: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Content-Disposition: inline
In-Reply-To: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 03:35:30PM +0100, Lee Jones wrote:
> Hi Wolfram,
>=20
> Placing this firmly back on your plate.  I truly hope we don't miss
> another merge-window.  This patch-set has the support of some pretty
> senior kernel maintainers, so I hope acceptance shouldn't be too
> difficult.
>=20
> As previously discussed I believe it should be okay for an I2C device
> driver _not_ supply an I2C ID table to match to.  The I2C subsystem
> should be able to match via other means, such as via OF tables.  The
> blocking factor during our previous conversation was to keep
> registering via sysfs up and running.  This set does that.

As mentioned in another thread, modaliases are one other possible side
effect. As Javier correctly mentions, the beaviour does not really
change with your patchset. Yet, if we remove i2c_device_id from drivers
too carelessly, they might not be bound anymore.

>=20
> After thinking more deeply about the problem, it occurred to me that
> any I2C device driver which uses the sysfs method and issues an
> of_match_device() would also fail their probe().  Bolted on to this
> set is a new, more generic way for these devices to match against
> either of the I2C/OF tables.
>=20
> I hope this ticks all of your boxes.
>=20
> v3:
>   - Insist on passing 'struct i2c_client' instead of 'struct device'
>   - Remove hook from of_match_device()
>=20
> v2:
>   - Removal of ACPI support (this is really an OF issue).
>   - Add a new .probe2( with will seamlessly replace
>   - Supply a warning on devices matching via OF without a suitable compat=
ible
>   - Remove unified match_device() - bad idea as it subverts type-safe beh=
aviour
>   - Provide examples of the kind of clean-up possible after this set.
>     - I already have the full support from the maintainer of these driver=
s =3D;-)
>=20
> Kind regards,
> Lee
>=20
> Lee Jones (8):
>   i2c: Add pointer dereference protection to i2c_match_id()
>   i2c: Add the ability to match device to compatible string without an
>     of_node
>   i2c: Match using traditional OF methods, then by vendor-less
>     compatible strings
>   i2c: Make I2C ID tables non-mandatory for DT'ed devices
>   i2c: Export i2c_match_id() for direct use by device drivers
>   i2c: Provide a temporary .probe2() call-back type
>   mfd: 88pm860x: Move over to new I2C device .probe() call
>   mfd: as3722: Rid driver of superfluous I2C device ID structure
>=20
>  drivers/i2c/i2c-core.c      | 72 +++++++++++++++++++++++++++++++++++++++=
------
>  drivers/mfd/88pm860x-core.c |  5 ++--
>  drivers/mfd/as3722.c        | 12 ++------
>  include/linux/i2c.h         | 22 +++++++++++++-
>  4 files changed, 88 insertions(+), 23 deletions(-)
>=20
> --=20
> 1.9.1
>=20

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUEvk4AAoJEBQN5MwUoCm2kOgQAKCI/fFrXmJFbf1Q0/Tl/9VI
ujN7X5nJBG/7Fgy3o8QhK/De7Z8DJU0nnsdd701NcAyE29SAQaStaHUv5s+K+0Bc
Feu+zbV60NB03ogrIwe80JsSLVVaYl2VHJN7qqhQ64IuJYdbKg+08c9ilv6U1vbu
Tcp0n2CAlJ2RQpgvelQRKsjo3yZmloeL6aeZKbcRTpCtzr2iboq67Dz3ZAhCNqY4
YIYvA0w/1yor7li1e9NgnnSIHaCHhMPQfkTAHQZD4Onu8tHhSnCbx8ueQPomr4uV
2inZ/4T1OrmVIyQz86Ge4hGHPBJ+6dChGierF1j8NyNXdF6tj4uQ411S6NilJzW+
An7AWDgHl44xDiquhruk7ijPPIXDYDtCpAUzuUFqlNRsnSUgaNCr7UfTO//qEoC+
pE3u3S3+UuysgCK+q9nHubjlph7v/nGsaN8k91vPY/EXZ1Xz/QoOBOHhJIkUITSQ
UaoHEI/0L2QA1gwYNbLP4a31GjVHBYy5W7ptzDv4hLevRxBUSN3OaAxQxBEc61Up
1BUnrnArXn25x08NF7/YUAkHnVywUBXoYISTNeOOnuZcsBa6nOF/wxrnr9LSNrBb
Q+RJYIe+7wem0J+1TQpfhSYSiQGQt4XLOQzC7CGyyv5YY0YYmcDV//H5jTEmHjkA
Bc5AxCylij+UL1Q5lRhj
=YATJ
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
