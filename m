Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaFFUaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 16:30:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43348 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751901AbaFFUaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 16:30:08 -0400
Date: Fri, 6 Jun 2014 18:05:52 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 3/5] regulator: axp20x: Update the bindings to use a
 local parent regulator
Message-ID: <20140606160552.GC9791@lukather>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
 <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140528185051.GB22488@sirena.org.uk>
 <20140603131204.GJ27722@lukather>
 <20140603144319.GD31751@sirena.org.uk>
 <20140605142729.GG5765@lukather>
 <20140605154931.GY2520@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <20140605154931.GY2520@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 04:49:31PM +0100, Mark Brown wrote:
> On Thu, Jun 05, 2014 at 04:27:29PM +0200, Maxime Ripard wrote:
>=20
> > You already list the regulators available and their supply in the
> > regulator driver, why do you need to set the regulator parents in the
> > mfd driver as well?
>=20
> Unless they're being used by the MFD directly there should be no need
> for the MFD to know anything about the supplies.

Ok.

> > My guess is that it's to work around the fact that
> > regulator_dev_lookup only looks for the regulator's device of_node (so
> > not the PMIC one, but one of its child), which doesn't have the supply
> > properties, and then just falls back on the regulator alias
> > list. Would it make some sense to add a lookup in the parent device
> > of_node (which would be the "main" PMIC node in our case)?
>=20
> This sounds like you are passing the MFD child device into the regulator
> API when you should be passing the parent device in.

We're passing the device coming from the platform_device that is
passed in probe, that has been created by mfd_add_device, which is
indeed the child device from the MFD device. So we should always use
the platform device parent's instead?

> > Also, there's also the fact that all the supply properties seems to
> > also be mandatory in the DT, even though the regulator itself might
> > not be used at all on the board, and the input voltage not wired to
> > anything.
>=20
> For electrical engineering reasons it's unlikely that the supplies are
> actually floating but yes, they are mandatory.  This is an issue with
> registering one device for the entire regulator subsystem on the PMIC,
> it interacts somewhat poorly with deferred probe.  However for systems
> with full constraints like DT and ACPI ones it should be mostly
> sidestepped since the if there is no supply mapped a dummy supply will
> be substituted.

Yes, they are actually tied to the ground, but it's still something
meaningless, that I guess shouldn't be expressed in the DT?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTkebgAAoJEBx+YmzsjxAgKGkP/3oe9/TZjocPOukg2iqR1oVD
EK1KqgWI6EXdD0TmlH07bG51k6l9bjqLqA2GbENz8OpMmUIOeIVypwLet36DUDen
z6qLnGfIBp9WL5wD0M2pwKCp3B6xSbvsww1P43kX0MYwTmDKFtPVksZ16pk6jGG4
fstpmXxxjb5Bz/D2zLgKBQ9JNrQ+a3YFYiTHwlcDo19miyK8s3Ndwu3pqISHciBh
zLXczRMOl//lXHhC3+1x6znRLwY3xLc5dQMGl8EOTAKMJdM+GIjurnQeZOhnim6U
0k70u/HU+jnCIs4Q5JuZlGp0AWzLFeFZIWZHKtTkFGVMeYrIMLKuB3exq37D4Q25
oBGpHIMJmuiZkL4mazm0TIiBOfctdKtV52w4d21eflv6hS70I6phXNoGxBOpvPF9
V7+NrxO2Rfx2ckf1iW9YKEICcm6mW7rBYHSUXzUEQgHFcV5CvBQRtW33nYUvlHji
b6dWg6k+Wlt8G/NJ7cfxqqaabNpbBFv0nlbh3Progqckr09/tTp7qFp/UFUn6ugK
izJGl+42NbfZU8h3goOeXPWbvLy5m9Z2L3dja7QXkvwcd85Q5rXFQDUGwBc3UIjc
Rke2xdZs1pf4krkC6bPr8EFG8v9gJqzPI7ynBuiiWDrTjyIW1HILsumrN8EMnlkU
X2M9Win2aGtX4dNlCwLq
=dKdq
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
