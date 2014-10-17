Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaJQL5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 07:57:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33083 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaJQL5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 07:57:39 -0400
Date: Fri, 17 Oct 2014 13:57:01 +0200
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141017115701.GE1820@sirena.org.uk>
References: <1413478133-2577-1-git-send-email-javier.martinez@collabora.co.uk>
 <1413478133-2577-6-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline
In-Reply-To: <1413478133-2577-6-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/7] regulator: max77802: Document regulator opmode DT
 properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 06:48:51PM +0200, Javier Martinez Canillas wrote:

> +- maxim,regulator-initial-mode: initial operating mode.
> +  This property can only be used on regulators that support changing their mode
> +  during normal operation. These regulators are LDO1, LDO3, LDO20 and LDO21.
> +- maxim,regulator-disk-mode: operating mode for the regulator when the system
> +  enters in the Suspend-to-Disk state.
> +- maxim,regulator-mem-mode: operating mode for the regulator when the system
> +  enters in the Suspend-to-RAM state.

This seems pretty ugly since it's not integrated with the suspend state
binding at all - adding new suspend modes is going to involve changing
the binding which seems icky.  Adding a standard property to set modes
doesn't seem so bad, I think a translation function to parse device
specific mode bindings in properties might be the way forwards.

--//IivP0gvsAy3Can
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUQQQMAAoJECTWi3JdVIfQyy0H/0Abr/wX2dEV8wmMq5CiC7Vg
nAUMqqmylSuKrATHRJ0+wXmvUYoitcgr23dkuP6w4j322tj/CaMcBy1rZAf2ZqrA
DeeoyY58el6+4cX54Q6UbpJnzgjsQNVeaBNYQQora160r5rh6A+YvzXQnEP+LNAq
vgpkFvrgG/mp5BRHo87fDBxL5C1m4zDM3p5BaGf3Myh6bq6x/fEhPFZEg7HHH+G/
dOwuPNsRGgCV0t4k/+c4BBC3SWLWjP217Ns0fFfTDTygv+50dVQQNc9ssLYR49Xb
ljLOTpP1g0q0acZBmccGtnPBJNYQshUMi3CvHx8xgMuC9IB50m8MQniHQlvK77A=
=trBw
-----END PGP SIGNATURE-----

--//IivP0gvsAy3Can--
