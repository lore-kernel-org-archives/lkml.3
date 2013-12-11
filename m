Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3LKPWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:22:37 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:52650 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab3LKPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:22:35 -0500
Date: Wed, 11 Dec 2013 16:21:20 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: plagnioj@jcrosoft.com, linux-pwm@vger.kernel.org,
        devicetree@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        galak@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 1/2] PWM: atmel-pwm: add PWM controller driver
Message-ID: <20131211152119.GD31617@ulmo.nvidia.com>
References: <1384766002-2852-1-git-send-email-voice.shen@atmel.com>
 <20131202105957.GD18060@ulmo.nvidia.com>
 <529D4B58.9020700@atmel.com>
 <52A67A71.6020404@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <52A67A71.6020404@atmel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2013 at 10:20:33AM +0800, Bo Shen wrote:
> Hi Thierry,
>=20
> On 12/03/2013 11:09 AM, Bo Shen wrote:
> >>>+        atmel_pwm->chip.of_xlate =3D of_pwm_xlate_with_flags;
> >>>+        atmel_pwm->chip.of_pwm_n_cells =3D 3;
> >>>+        atmel_pwm->chip.base =3D -1;
> >>>+    } else {
> >>>+        atmel_pwm->chip.base =3D pdev->id;
> >>
> >>That's not correct. The chip cannot be tied to pdev->id, because that ID
> >>is the instance number of the device. So typically you would have
> >>devices name like this:
> >>
> >>    atmel-pwm.0
> >>    atmel-pwm.1
> >>    ...
> >>
> >>Now, if you have that, then you won't be able to register the second
> >>instance because the first instance will already have requested PWMs
> >>0-3, and setting .base to 1 will cause PWMs 1-4 to be requested, which
> >>intersects with the range of the first instance.
> >>
> >>The same applies of course if you have other PWM controllers in the
> >>system which have similar instance names.
> >>
> >>So the right thing to do here is to provide that number via platform
> >>data so that platform code can define it, knowing in advance all ranges
> >>for all other PWM controllers and thereby make sure there's no
> >>intersection.
> >
> >OK, I will fix this.
>=20
> After read deeply of PWM framework, for non device tree, I think we'd bet=
ter
> let the PWM core to choose chip.base as device tree, while not pass a num=
ber
> through platform data to it. Or else, it will confuse the user to set the
> chip.base, must set it in correct value to avoid intersection. And, actua=
lly
> we won't use chip.base in driver itself.

Yes, that should work as well, if you make sure that every user actually
has the PWM lookup table and doesn't rely on a fixed global index to
retrieve the PWM channel.

Thierry

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqILvAAoJEN0jrNd/PrOhgUcP/05aeW2mXhtLX+GA6aGfbN0v
SmdDDnqCwHBdZsZ7zp2Bm9rGUmN4PFHL8j45RvfwWuiyvZh78DHFV+w3h8KonY49
Tj9FRvouaWeDusCahzMX0QVW29WATjffa9O9IlvoTQApUsQSgSEI6Mnkx4U11Ks6
hOJ7LtqmQmfMDXSBjowG08JSRMlG7vtvokxo3B+atdOkzRsUSnEAiT8YcSrR0CGn
Cb9xfo3vFB5rHcKPIHHSSRBh1E23+uzyZS+ANeCJ4buHvjhHNT88LnZHbNBqFiRa
XjmJUPB+KUO6jvPVcq/Xy/gHdJ/gVYX+kvmONUgOeFJo9cYN8NvrcE/ec6Ivb2ER
m+dk2xsxs/2sqNCbZuWDgcVh1YuiuB688IKUubVJdHMrZYp3Qqs1N2ois+MG50mv
vhrUXKkq+oxTV58km7MGgy+K0RgMyvUdc+gnkV3KdEHno17AMiWKM9/ALssQbR6l
QbDb1iWSoL+VRp12WDyCMiC0cdOqPKZcjVn23PvL0NCdqTddaNbvqWwzl6bkI7xl
d+urt2lyhH0YT9BP3mr3uzErg/C4RX+F2ylIfzbfSLJqDisYwJ5jmvCDoVPIDHzv
b0QB7KLdRqGwlRv0AoHUHN93wQ+weP/OJCldZETGwgRigk0QsAuGFMSqtg5Pzmls
/Dd1SuOMUuzg0tBBuBLp
=pywk
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
