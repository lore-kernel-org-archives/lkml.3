Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971AbaLDS2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:28:34 -0500
Received: from sauhun.de ([89.238.76.85]:34322 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932464AbaLDS2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:28:31 -0500
Date: Thu, 4 Dec 2014 19:28:28 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: Re: [PATCH v3 2/5] i2c: davinci: generate STP always when NACK is
 received
Message-ID: <20141204182828.GG7944@katana>
References: <1417448047-15236-1-git-send-email-grygorii.strashko@ti.com>
 <1417448047-15236-3-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uc35eWnScqDcQrv5"
Content-Disposition: inline
In-Reply-To: <1417448047-15236-3-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uc35eWnScqDcQrv5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2014 at 05:34:04PM +0200, Grygorii Strashko wrote:
> According to I2C specification the NACK should be handled as follows:
> "When SDA remains HIGH during this ninth clock pulse, this is defined as =
the Not
> Acknowledge signal. The master can then generate either a STOP condition =
to
> abort the transfer, or a repeated START condition to start a new transfer=
=2E"
> [I2C spec Rev. 6, 3.1.6: http://www.nxp.com/documents/user_manual/UM10204=
=2Epdf]
>=20
> Currently the Davinci i2c driver interrupts the transfer on receipt of a
> NACK but fails to send a STOP in some situations and so makes the bus
> stuck until next I2C IP reset (idle/enable).
>=20
> For example, the issue will happen during SMBus read transfer which
> consists from two i2c messages write command/address and read data:
>=20
> S Slave Address Wr A Command Code A Sr Slave Address Rd A D1..Dn A P

Applied to for-current, thanks!


--uc35eWnScqDcQrv5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgKfMAAoJEBQN5MwUoCm2omIP/RIXUavcJBCbHB/Zpt20ZgdZ
P7VBMFPtlwNcbWkjFA8GeuSBv0KSJHgr5F83NlhKvJauEp9bdOUKo8YIi15Y8dcf
wN8FCE2pmYl9dbtUD9uT4bdtfjfXCVqlvwAoGe0StVz40JivYtZcb6LdVszn/Lhg
S/K/wpdRtevMewuh20FdEL+uDfwZtOin04BfDHoyP9rR7Z/IvlchD6KYzO0wegvo
IfX91JnMzWOIveODRh8kY4CMNr2D31YlDARjEYDRP2vMKtt2Nss7MvOkezz+MO5g
hDur1BRiAcr0pI+FGQ2M433wvnB3ymgi+2xwLvhI6JqBNQvMdQlslMDo+0k6NNWi
R6kbtTndrKqKInOdcS06gW+DOzL2EL13Jtz1w4ruTd3ZIOaExjplcKqKxMvZPI4j
yAhZwPsGW+t9eaHGNeu3b4hX1ZMSkmyE5Yz+gpF6wX14/pTmAqaebvEziP5sqpjO
z+KHvLUucZHfQY05DPoS8e2ii8cFchOk4LlU2e5U/7eTGs25j8QJMflJeSeZeX1X
K71EoUVhq6DBC6yyWU9vGq1fd2Ss9li/ojRjHfhNt0G/vk22l6qtgHCJtjLleoUS
JZG51bayn9V4X10ruzj/rvcbVi4mjWc2tKthWfHJ72gJDX9rFjYoGOYRx02I3noV
zjiq0FFl0GypwLmM+fCf
=fFfo
-----END PGP SIGNATURE-----

--uc35eWnScqDcQrv5--
