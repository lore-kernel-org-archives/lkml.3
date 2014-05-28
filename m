Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaE1SsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:48:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45851 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaE1SsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:48:17 -0400
Date: Wed, 28 May 2014 19:47:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        lgirdwood@gmail.com, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140528184752.GA22488@sirena.org.uk>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: I'm having an emotional outburst!!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/5] regulator: Enhance AXP209 DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 28, 2014 at 07:11:04PM +0200, Maxime Ripard wrote:

> This patchset modifies the regulator core and axp209 regulator driver
> to be able to set in each regulators sub-node the supply, that should
> be possible, given that it's documented as such in the bindings, but

It is?  We should fix that.

> is not at the moment, since whenever looking up the supply in the DT,
> of_get_regulator will always look into the parent's device of_node
> pointer.

> This leads to a common pattern accross the regulators to have multiple
> supply in the main device node, while it would be more intuitive yet
> follow the documented bindings to look into the regulator sub-nodes
> first.

No, we've been round this loop several times before.  This reduces
consistency in how we map supplies since the user has to work out which
subnode the supply is associated with and what it's called there instead
of being able to just look at the schematic and translate the supply
name into a property name.  It also means you have to map supplies into
multiple child nodes if the same supply is used in multiple places.

The idea is that supplies that happen to be used to supply a regulator
don't get treated any differently to any other supply and that we do
that at the physical package level.

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThi9VAAoJELSic+t+oim9pXQP/j2Rv1yL6LH0jE3CHfU87mWb
61jpHGQMVmrKrFwpb2ucLkoOzah346FFkV0obBqP212hGHGdlDvcI+K3ek7w//en
2F2h5oMOsvZZaJNpKQEG/3tkng+dolU62exMW6nfmmkiyvoJD+h/bm5rRZIe9f9G
XeGyOVdT6lBGG/VmaSkNvZ8li0lYWpIvuTHavDqWi2sQGmXgiVljCoL7Nu/JGvg8
ULRCilVNXH0SL6u/p2FLdgiWFmvs6IUjZTlVJn7jMoMzwFxXU+nD3wdZsZ0DwZoI
0hMz0ZwNR+K0KRiI2AIUczU3QDcpE1sgK62O5F/FpehGgf3X0e8zFvuHL+EUQElm
9IYxBkQ0uhhxka5gcblBfAN25Lz+ATbF9S8h/Ubum/QzgAos7rDIFxgiToLyF3uc
09rd1md9QLMC0zZekyAH0iGpuMDG2RPEOIkZCH6fqfjbja7Oib6rbDqxgQJgEno/
POZA4aDpWSWCKyasB9E4uhIJrl36hkF+/vkTd0cVI08KAi4UcNwUoECG4q0umnH6
YwZNBtXxJx5uvrP6ytmzPtvBNP22pCiDxbgfG0h7cUzC1nXZ76Yn6mkq/W2r2OAn
CfKEwXOgDTad92hYqffDbP+HFjWisS4ODZegZII0+kRf++TzK57lNIQQ/4KsSRtF
vIugRltuCG+jp79l/Dua
=YrZI
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
