Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaCKPr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:47:59 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:60107 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbaCKPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:47:56 -0400
Date: Tue, 11 Mar 2014 11:47:50 -0400
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] regulator: add bcm590xx regulator driver
Message-ID: <20140311154750.GI25092@beef>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
 <1392765432-9111-4-git-send-email-mporter@linaro.org>
 <20140219045232.GD2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <20140219045232.GD2669@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 01:52:32PM +0900, Mark Brown wrote:
> On Tue, Feb 18, 2014 at 06:17:10PM -0500, Matt Porter wrote:
>=20
> > +static struct of_device_id bcm590xx_of_match[] =3D {
> > +	{ .compatible =3D "brcm,bcm59056-regs", },
> > +	{ }
> > +};
>=20
> This looks pretty much OK however I am in general suspicious of MFDs
> that have subdevices like this in the DT - it doesn't seem like this is
> a reusable device which can appear anywhere else so you're pretty much
> just representing the way that Linux splits things up here rather than a
> reusable IP that can reasonably have a separate binding.
>=20
> If you had a binding which did something like enumerate the individual
> IP blocks as individual devices that'd be more interesting, I could see
> for example that a different PMIC might have a different set of register
> compatible regulator IPs laid out.  It looks like that might be doable,
> but it's in no way essential.

Ok I dropped this for v3 in favor of using mfd_add_device() and having
the regulator driver reference the of_node from the parent device.

-Matt



--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHzAmAAoJEOfTILNwq7R4CF0P/10jxyRa0TDFYBmVuOyl6pPT
UCwDr41O1SEWpL4cN67nrExXRUnzcN6p08srS47evulG67A1MqCsT/nhKJ/OqSjx
GBQiFAUMzWmsSZRPBpQOoxl1LqP0tPJp8RUopsM5nmgGqqWt4lX4PBBSUNpL7fQP
a+GtTJ6sELL1GAnM52hkCmDG/8nPsCgMYn6dizRY1JLPsn0qCadszc8ItGnF6mYg
V36vsKpWVxMKU2bnCwMtnX69W+gCf7rhdPtYJwrb3GylV1zyJ8TiOjIW087dJTac
MrJX5bu7j80nj2uu51jjDoPj3ZBR/6fn81R/+gdHwN0eYagk+zWvcqE0WSAsx0HM
k6u5i5IStuLOPACtwQvs5jDiN2bMXREL90tlbyTg8dAR1EzmXt4sp80F3GoyykbP
bNLqjpnN20s7l2fQ1s/Bp5ZurdOb85mZnAb8UGhj4IGtO4GoMb38NXw8tVdGIsM5
cPfj7AZ5zP+s2uRluppuShqglCVVkCt5CLCt+K4h1BsbyAZfYj7AROKVXeejIDyy
COkU8uwf15YqNuxIHCRvDk5u86T85pJr6ZFOzH8uh/O1xhtY0gO6SvNhYzvW3E8j
Z6sWL3MlPNPpsQo7+G0nx8sZ61vXdEX5gPTYjKQP/kX/M+Px+HnRj9sNMbXqN4H2
29eoYxn/VH/bw3GrG2fS
=zJmM
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
