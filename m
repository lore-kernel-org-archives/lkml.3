Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaG2RT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:19:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33235 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG2RTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:19:25 -0400
Date: Tue, 29 Jul 2014 18:18:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140729171857.GV17528@sirena.org.uk>
References: <1406651339-28901-1-git-send-email-javier.martinez@collabora.co.uk>
 <1406651339-28901-4-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R0sYUISimcquDWTD"
Content-Disposition: inline
In-Reply-To: <1406651339-28901-4-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 3/5] regulator: core: Only apply constraints if available
 on list voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R0sYUISimcquDWTD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 06:28:57PM +0200, Javier Martinez Canillas wrote:
> If a selector can't be used on a platform due to voltage constraints,
> regulator_list_voltage() returns 0. Doing this unconditionally made
> sense since constraints were set in machine_constraints_voltage() at
> regulator registration time.
>=20
> But for load switches that don't define a voltage output, the parent
> supply voltage is used so the constraints should only be applied if
> they were defined for the child regulators.

No, think about what you're doing here and why we're filtering out
unsettable voltages - this causes problems for consumers on regulators
that don't have any ability to vary voltages since they will now be able
to list voltages that they can't select. =20

I would also expect any regulator where the supplied devices are able to
vary the voltage to explicitly provide a constraint even if the
implementation is done in a parent regulator.  There may be constraints
on the child supply which aren't directly present on the parent supply
and can be ignored if the child supply is turned off.

--R0sYUISimcquDWTD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT19d+AAoJELSic+t+oim992wP/iLrqpiwTyw4N9z1hAe8Oi6F
bSV6hdU0SVlfOp2Fwge5oLNu8PVhrxpV3t/O607GeAwVBCnmW1cFS6c02gccuKpf
4GGxaiBqe6Juw/KH4j26dgrEKFJwvpoEKkgGMBcw++bE7xEsvwpMMEDgEndFjpge
WFe7Dw28SH4pcLbZd7/3o1k1zR2Fn6K2JevSMiPb3ukpiqwmt9MwySbuUsoVzz+U
xqtARXnLN/U+XE8VX1R+jCYf0QqaAh/1u5Vzt2b6RKNsX/tuame+2wiPTZROj2oc
U1csVFPHuztI+bi/FSVRiqEVav0TMekdqSzVjvX0T1Rg81qK9OPsOO2vD0aQC0NK
bj3pFT0zb2Yu/hb6iQ9VKXs11yel1RmQRKPJ5nwp95b6zbDdvm1UKgbSJH2b2k05
CZJBJSOiph016g1jdpfiNYfWQ0DxKLi9ph70+Cs6RcIw5jioVulhf2ZAKmzYbUJD
aDlATxwn3L2jgL3jySGwxLmPjAlmtuXJxwStgfSOzSauscGA23r607ZNcpOD5X9+
QEqmXH5PGwFd21h6sJ0DxTANTTBT1aQMikqxgiocYnafk9DuGPnEX6zKn9pdzWMJ
XPeOh6AYsPYckbs0yIOfs8TKpZA67JVBsxWAzalCArtwraEy/NnCKc+pHy/1wUQm
HpnYpfeS5Q6+d6Mi8gRF
=uy9r
-----END PGP SIGNATURE-----

--R0sYUISimcquDWTD--
