Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaKLMCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:02:13 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35776 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaKLMCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:02:10 -0500
Date: Wed, 12 Nov 2014 13:02:04 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Allen Martin <amartin@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Ensure voltages are within the allowed range
Message-ID: <20141112120201.GB30821@ulmo.nvidia.com>
References: <1415787125-31218-1-git-send-email-thierry.reding@gmail.com>
 <20141112114505.GE3815@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tsOsTdHNUZQcU9Ye"
Content-Disposition: inline
In-Reply-To: <20141112114505.GE3815@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2014 at 11:45:05AM +0000, Mark Brown wrote:
> On Wed, Nov 12, 2014 at 11:12:05AM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Unless a regulator has a fixed output voltage the core will not attempt
> > to modify the output voltage. This can cause a situation where a driver
> > enables the regulator but the currently configured voltage is outside
> > the valid range.
> >=20
> > Fix this by constraining the current voltage to the allowed range upon
> > regulator registration.
>=20
> I've thought about doing this before but it's tricky as if there is a
> voltage range it's possible something needs it at the high rather than
> low end of the range and will get upset if the voltage gets lowered.
> Setting the top voltage also has risks (though less bad when constraints
> are sane) and requires working out what that is which we'd need to write
> the machinery to do.
>=20
> This is all especially likely to break given the depressing desire
> everyone seems to have to put the maximum possible voltage range for
> their regulators in constraints regardless of what's actually sensible
> for their board design.

Perhaps rather than checking that the voltage is within the valid range
we could at least cover the case where voltage is zero, which is what
triggered me to write this patch.

As it is, regulators with a valid voltage range but for which a voltage
isn't explicitly set will remain off if their default voltage is 0.

Do you have any recommendations to work around this other than adjusting
the actual voltage to be within the range?

Thierry

--tsOsTdHNUZQcU9Ye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY0w5AAoJEN0jrNd/PrOh9xMP/jhvbQEFT3dMaPZDlK9pn+On
5G38GPU1HWUDCF5ovJRJQrkazLisLvNWDDpSDH/raPWDn8AcC2uCHDn46SzzLr6Z
KsDgUM0pm0+TnCVOiVoZHrhcMnVNi7UKZyC/QY71AC2y0BmnTogADBpfhBoD2mAz
pa2lvtgmOhujQwOyuKwItSxuX1q1xk3VAfwtGWnVY8WALI60ZeA0Li0oq9ZeFOgk
h7oq1IRhLM0BrjpPIcTWb9NsF0q3WEAGThshb8yN4G6iIvwuOq++CbC8yrdmOQxG
DDAB0np1TMRWBkMnFLclrJcF5vLVkOz1A9nzGjzwxpsxqHO//gR37zMFfsVPKs6q
J5fmQ6w+qXc9fN3lYeuVkcAnch2xiEqbT2SFog6GAGiumePz+63hZ7+mJDUFqQb9
r3VcIdB5sctTPL4+PmhBuSTDczZ7YnLw5teAMyXTnJgpFlqPSEmxIlTlY7o9WaUi
jEEEEA3cfCXsBQqOZRyY51OjAX7I/it7Ok/yG04p0fdJaG0Hbp9Fp7S6fONnexUx
uhw4FFiGVUFQShI3fIUcaBTCRWvD4Eg+4Q4Dz+Fdn2HzDzpSzHZuaPmV3tkCqajV
sXO99e74pXBUowfLN5y+si9KhVdXqEBxvdiDF1XXYEciDlNJPM5q79uPiU/LWFE2
TAe1bpPZsZs8pMcgh8QG
=gRCh
-----END PGP SIGNATURE-----

--tsOsTdHNUZQcU9Ye--
