Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaCGRUH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:20:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:40172 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751778AbaCGRUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:20:04 -0500
Date: Fri, 7 Mar 2014 18:19:32 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140307171932.GU607@lukather>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307160836.GM21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fD6GIi1NIioU6454"
Content-Disposition: inline
In-Reply-To: <20140307160836.GM21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fD6GIi1NIioU6454
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

Hmmm, right. I'll fix this in a later version.

Wolfram, do you want me to respin the patch making use of
reset_get_optional introduced by Philip in its other mail?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--fD6GIi1NIioU6454
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTGf+kAAoJEBx+YmzsjxAgAJEQAIOnt/7f51rWaEgzUZElG95Y
6e+Sn5jqDrq+FbGHXf58CzVrad6w/3vH1NhhfP4NOSMP2UakzopatsU6DOAf7zk+
d2dNGQJACXRG6Wr54ZDpPkkQ9MQ1A6W6ATocJd/tydyB7Xu17h7oljfKc6ckrBzT
7NLF4UoTmAUg0VnxKnyN3dcQ46hWK7GiSKtJ/l27V4/9Fq/O5oXDT+8h278PuXOc
8GLQwKkONa1bmxIPQgBeF+KQEFgy1f840bvB7tE5QkDYx1D+reHkgyDgFW6U/Ogm
oCw5dL9uex4xLFAmM6XOFDz2dN9RoL/B66UUMHIYc6+V1VGyjEVTVKU0RLMagZpj
nwDTckb9YZvbnJceag0hpYu/OMLcf/wCcH6yiNKsh8M7ln62GkSuGl8SGskGv4ef
Kje9FN7HVcP0aNf8zajp2juEiqxFOrfSuL+VqKti2RWv3iZ1appascikipLNd25U
8ed3GsDvjqW8dxbcRa0h6/UBzQDWc9R8GlnWQ0COvRm9BMxrE2le2R8w+BG0vTbY
/E9N9ZvShblfVUW1K9yKuCf9zqmWBDMwdj2MSaMTlih5c8CJ9DafEq99WeJIJNw9
ybYQ8HnVLYSiCK+GCSA/Nrxy5G790vAoy3Ri6GPkSwWG6isjGcAeGCrMFE4O9foS
7d+jM7V91qlACNv48PzI
=Lts2
-----END PGP SIGNATURE-----

--fD6GIi1NIioU6454--
