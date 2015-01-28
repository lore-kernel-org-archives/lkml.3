Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbbA2Bc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:32:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38405 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbbA2BZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:50 -0500
Date: Wed, 28 Jan 2015 19:38:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150128193820.GJ21293@sirena.org.uk>
References: <1422447834-23116-1-git-send-email-ricardo.ribalda@gmail.com>
 <1422447834-23116-3-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GMAK4tsM7WHnyxbM"
Content-Disposition: inline
In-Reply-To: <1422447834-23116-3-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 02/15] spi/xilinx: Leave the IRQ always enabled.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GMAK4tsM7WHnyxbM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2015 at 01:23:41PM +0100, Ricardo Ribalda Delgado wrote:
> Instead of enabling the IRQ and disabling it for every transaction.
>=20
> Specially the small transactions (1,2 words) benefit from removing 3 bus
> accesses.

For this particular change I don't think it matters but in general
moving things that do need to be enabled and disabled to
{un,}prepare_transfer_hardware() will avoid quite a bit of overhead
under load.

--GMAK4tsM7WHnyxbM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTqrAAoJECTWi3JdVIfQxZUH/jJTTkEYThZvBD050a87k2Tg
CeNoDZAKEaKWT/2BN2WFG6LlPb23eeVnoeqx1cA6UAUI9v8ZkkZR1+dLJBp30oRl
JZ3NS9QkR7f+nYASW0GKJORvmYy58D1x+9kUk5Xyu0wOYawUwvTJNAKACH9EO1Uo
pqn62FJsV1rvYlkcdww6eIIt6XuTPF1tt0W3E7l5jwuj4mgB5Oh3DVk/Q9DNC/0Z
EQrFUCLqk5uz6MT3v6CEecTw4IC6sFaduIBaCAxVui3H32YU+hcgm3tVYhYCn6Tv
jusuIEvMke3wfk898Eafqmle6otcB8YZTWVley9RARVH6IVpDGPya7hDT7V/Vow=
=7G/h
-----END PGP SIGNATURE-----

--GMAK4tsM7WHnyxbM--
