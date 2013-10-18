Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab3JRR2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 13:28:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44871 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab3JRR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 13:28:53 -0400
Date: Fri, 18 Oct 2013 18:28:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, timur@tabi.org, lgirdwood@gmail.com,
        r64188@freescale.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, linux@arm.linux.org.uk, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, fabio.estevam@freescale.com,
        LW@KARO-electronics.de, oskar@scara.com, shawn.guo@linaro.org,
        b42378@freescale.com, b18965@freescale.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
Message-ID: <20131018172814.GT2443@sirena.org.uk>
References: <1382000477-17304-1-git-send-email-Li.Xiubo@freescale.com>
 <1382000477-17304-6-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ozmrAWQcVMJcOLTa"
Content-Disposition: inline
In-Reply-To: <1382000477-17304-6-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv1 5/8] ASoC: sgtl5000: Revise the bugs about the sgt15000
 codec.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ozmrAWQcVMJcOLTa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 05:01:14PM +0800, Xiubo Li wrote:

> @@ -883,14 +883,19 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
>  				struct regulator_init_data *init_data,
>  				int voltage)
>  {
> +#ifdef CONFIG_SND_SOC_FSL_SGTL5000
> +	return 0;
> +#else
>  	dev_err(codec->dev, "this setup needs regulator support in the kernel\n");
>  	return -EINVAL;
> +#endif
>  }

If these systems don't actually need the internal regulator then should
they not be trying to enable it?  Alternatively if it's OK to ignore
this then why is this conditional in the board?

If this is something that it's safe to ignore then it should either be
ignored all the time or should be controlled by platform data not by a
compile time #define.

--ozmrAWQcVMJcOLTa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSYW+rAAoJELSic+t+oim9e1cP/iq+FRM1OthmKupHcsx75mPo
/BSHzbRMV3vQg8d5stwzWn2iH0cDe8uu61lc/clarnoWdBdscb3dgvsRMrV4SO1X
K/VGYDmdC/baGPYNL+Mx6CFEgO5bv0HOzYh0ItCbfht1DJWe7WK8YPW3xidxutsN
2vc4SiBdYepNKPpeqMP+OLdS1TFxn+nZKKxERsDoMrdAt9XsDW6MSaqXt7/q7cUd
fUEnXTINIJl+KhNqsrsf+pxhds6ezL0SkyCjuRDdXpUyw1ur0HBndJsTL4XKtClU
gr022z5LRSwXano+JbtpWoydBJ2t7qhUL956CG29JVjHfzGNJvep2k2vW7bXC4lB
UWjfy7xBf+NZNlQtTvIGi6tSlMvqEEKF5EKOMZoNMGa1+Pk0vtx3eqdjZk/9GFzJ
82cW0sRdS1l2fNvF4LYb5jC8rcqV43UKjG0SWOT0vxEKaLdWGFMSXHwgZaepwBx9
TAIclxB5+F20Yfo6cxUDmaVwywyCf1xJNL3pjqOFDYwEdX82SHqh+xabGp+Bsf9l
QtLpmAB6o1nvMNj/l45hDPoO7Vz5c1P1WwuDcppVtz72M4HIBlGRVna9Q2DDX60s
/luBFR/1qhLsDzE5ZGm+rqcb8gftbZqmLDLCZmO4gf9lbkgtwLuIavytfXKZUrAb
1EzNihFkatoctVTdBBN0
=tZKV
-----END PGP SIGNATURE-----

--ozmrAWQcVMJcOLTa--
