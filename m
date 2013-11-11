Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3KKUzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:55:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:38272 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751369Ab3KKUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:55:04 -0500
Date: Mon, 11 Nov 2013 21:54:01 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: mturquette@linaro.org, james.hogan@imgtec.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, luca@coelho.fi,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: add flags to distinguish xtal clocks
Message-ID: <20131111205401.GZ26440@lukather>
References: <1382528150.21526.25.camel@porter.coelho.fi>
 <1383933648-28595-1-git-send-email-balbi@ti.com>
 <20131110113716.GN26440@lukather>
 <20131111194247.GB19212@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OHFW44Kv8gQ39vd8"
Content-Disposition: inline
In-Reply-To: <20131111194247.GB19212@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OHFW44Kv8gQ39vd8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2013 at 01:42:47PM -0600, Felipe Balbi wrote:
> > > +	if (of_property_read_bool(node, "clock-xtal"))
> > > +		flags |=3D CLK_IS_TYPE_XTAL;
> > > +
> >=20
> > Introducing a new compatible instead of a property would make more
> > sense here I think.
> >=20
> > Do you have a reason not to do so?
>=20
> As you can see, this is original work from Luca but I disagree that
> adding a new compatible makes more sense. This still related to a fixed
> rate clock, we're just giving it one extra metadata which will
> differentiate between crystal and oscilator fixed rate clocks.

I don't know, I think it's more a matter of consistency.

If we turn the problem the other way around. Let's say we have a
crystal that for some reason can't be used with clk-fixed-rate. You'd
add a new driver for it, with a compatible of its own, and you'd put
that XTAL flag in there, without any extra metadata in the DT, right?

And I'm pretty sure having a compatible like "clk-xtal" would make it
pretty obvious that it's still a fixed rate clock.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--OHFW44Kv8gQ39vd8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSgUPpAAoJEBx+YmzsjxAgHcgP/RBickPG2EHTBEAxjK6uVhUr
EN83m2U51xOtcREqH3PfwZOyWi3e2UOjujzgF8UA67gFzlF2p1Rei5Wr8r5cyTUx
LA34E01QrNliNXxA6C8uym6i4JmhLDxzUPgqgks77FRp5kzlikISNqIFSSpNby1c
GANbyNvV7j+8YIwXtg9AzQyl2xBaTMiUDgFVnYiPfarQXZtYCXLBc2iQezEdxqbo
rdhjOl/J8lKtj62SUQmtShkURRk3xcg0S/ZhY6I6FiQCcE+pXb6ZiGnce78XYmTL
0c/4spuKdGMVYhKNpiec1SyN5L2yvF4zR06WfVMJtR1r89Jn08OfKzyTcqNj0Pn1
5974vCBGFevvDbEg0Waebn9rgPbtn1Xw5jg7cC31qHCmzZ9+STxfoMu0q0iDRoCx
EqGBcvE5KWLllEMOWB7kxr1UX6NuzJ2y4AOIP8eAroXxXs5iyPcq5RnBOkLiHFtI
LYMG/deLbqa9+ACcBze8Mxi9cVri5lzB9Ku5JbeaG1odnNuOraOoXDpEGz2BmxBu
pYInB7MO6NNqoNQ0fDwDlG7YMKiwmMjmuHI85a8Iql/jrxpy7/HBPC+yC6C/8euv
3ek2+Fy//IG0ddqVRLA5af0IpIC09tazrbfVXaqtS3et4H1DNmNSLugM1gJUWBID
Y0h+q6xaLFh20NY0inqj
=yPrt
-----END PGP SIGNATURE-----

--OHFW44Kv8gQ39vd8--
