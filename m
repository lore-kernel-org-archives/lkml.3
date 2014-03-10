Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaCJLAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 07:00:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48131 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753111AbaCJLAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 07:00:38 -0400
Date: Mon, 10 Mar 2014 11:58:08 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140310105808.GE2815@lukather>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307160836.GM21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Content-Disposition: inline
In-Reply-To: <20140307160836.GM21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 04:08:36PM +0000, Russell King - ARM Linux wrote:
> On Fri, Mar 07, 2014 at 03:59:30PM +0100, Maxime Ripard wrote:
> > @@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
> >  exit_free_irq:
> >  	free_irq(drv_data->irq, drv_data);
> >  exit_reset:
> > -	if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
> > +	if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
> > +	    !IS_ERR(drv_data->rstc))
> >  		reset_control_assert(drv_data->rstc);
>=20
> Another question is... why do we need to check pd->dev.of_node here?
> If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
> controller node, so drv_data->rstc is either going to be a valid
> pointer, or it's going to be an error pointer - neither
> reset_control_get() nor devm_reset_control_get return NULL.

Following back on this as I was doing the patch, actually,
drv_data->rstc will be NULL if we're not probed by DT, and hence never
call reset_control_get, that would set an error pointer.

But then, we can use IS_ERR_OR_NULL on drv_data->rstc.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTHZrAAAoJEBx+YmzsjxAgtKoP+gPIHQvDYHj7s6kLT/4VfQeu
j6EcPSnKVm6erU1QBKt0scd4gEbxREuUIgt5NFnA20pxZj1u77+XGB6T9MQ+WIqT
AVAfgkcKBtg3CFSXyVl5JGjDo+VWNysqK7D4ZHR8l3WjivDGE86YHQl+kLGZ6rBg
x4Ns7DMD2DmzzfjleSnEyAH4ZdUjcrFgcydGYHUfafS3ovRB7HWCez0szSXfWf8R
mtd6GBM7rte0zMEYbv03k+anGE6NnJug4sDmqgj34ciLA3dMkkyVrfdO6IFVBj0t
np3vClEEKnlQwPXjcCgbb2IZTWLqIYAC9L9diefKXoBaSl8Aqfv2rgtEYE+GLf9T
8IE4zByiG8LYriyU3fF6JMX0nYn/QVYKQiV4UOzVBN//mrLVHeEQxNwZZ6VpbCz3
RzFmAiBn7xD660+Keo/QvEAv8K44M/zZNkMdia5xXWOFGltXr22P/OkPU0HDVgF4
PEZyrm/SC/a+OcwGeATYGvYvQ9R3oe1r3gCEPuBrtaAj4Mt3brMJF6Ow7ms4y5Pp
UAxFNSH275YPl1auwq8BWMJK0efIxTVfT15JtJuYpZfMuFo46QVGOXz1IvJdAtSi
o7HY3Y7+P+3ykVMlz6YpUUX8sbtJi01Jx7I6RC60Jht3eBLrfvts8WzCNjQdp2v/
qQOycr5FOfnrpTNUQGdX
=Ovt0
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
