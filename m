Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaCIU2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 16:28:48 -0400
Received: from sauhun.de ([89.238.76.85]:52310 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaCIU2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 16:28:47 -0400
Date: Sun, 9 Mar 2014 21:28:41 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: mike.looijmans@topic.nl
Cc: nsekhar@ti.com, khilman@deeprootsystems.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Looijmans <milo-software@users.sourceforge.net>
Subject: Re: [PATCH] i2c-davinci: Implement a bus recovery that actually works
Message-ID: <20140309202841.GB2835@katana>
References: <1393583525-9555-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1393583525-9555-1-git-send-email-mike.looijmans@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2014 at 11:32:05AM +0100, mike.looijmans@topic.nl wrote:
> From: Mike Looijmans <milo-software@users.sourceforge.net>
>=20
> Having a board where the I2C bus locks up occasionally made it clear
> that the bus recovery in the i2c-davinci driver will only work on
> some boards, because on regular boards, this will only toggle GPIO
> lines that aren't muxed to the actual pins.
>=20
> The I2C controller has the built-in capability to bit-bang its lines.
> Use this to implement a generic recovery routine that puts the
> controller in GPIO mode and pulse the clk lines until both SDA and
> SCL return to a high state.
>=20
> Because the controller must be held in reset while doing so, the
> recovery routine must re-init the controller. Since this was already
> being done after each call to i2c_recover_bus, move that call into
> the recovery routine as well.
>=20
> Tested on a custom board with OMAP-L138, and after this change, the
> board can recover from chips keeping SDA low.
>=20
> Note: This is an adapted port from 2.6.37 code, and was only tested
> with that kernel.

What about using struct i2c_bus_recovery_info, so the actual recovery
logic is taken from the core?

Thanks,

   Wolfram


--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHM75AAoJEBQN5MwUoCm2kpUP/2snT2tnUth7+KbQVXZZHNs4
DcO8sqd22PDF3fmPCPM23MOO43rUk8g7bw0tw4/G+Hk1pUpc9KgOVmvCHvv9jB5D
v9DuYZ7WMTktobhFTpa4B74eId5jalkuZCi4fPAHdz+FobKeJAD33kWyIRPrp2LY
ryDm7NuMsHNo1AEKKSFiwnojC6RqC1ANzcPuZqk4D9+UtfT1xt0U58sSBG1Zj/lQ
Q5ZaQs/3cIbl7Pp5hY3wQ+/WTQwI63quguTz7cUD69Otij4cqq90e/cCsVZzHJ/b
waT71oXZlrlkbuL8wbrLr9viExX4lZkqDbBAgqjREvBiHixTa1nd2OFVvo8Dp7Wz
mU4iJlU0fgwDkfau8oYfx1S2yc1lXCRvNjjGkNmXwnmC7ajay5IrDqmTPQu+hZQA
wu2YwKz0WnoP5pqT//o1KvqqGVfHp8BjQBh5/sCRRJa3tIhuNXylztwVc+m0CSxA
RZVYjZxiC/22fg6WCWknGXu9UIp7rHcjy+hAsqDVXKqb1UqDloKK+stzGDiETLfr
87Xi2R9kPJrOdN8fEYI0JKsSorNQ3Eg2jQpGCafqEN8S7CcDnU4MLPS9FsXTACu4
REORcMoTuf1MDvSifx/Y4MIswMGEHsDshL8MQPEr+v6kKxYeLgei4BP5hAyyeEAw
qrwrDeq8iUbwFIixNuxO
=xCOP
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
