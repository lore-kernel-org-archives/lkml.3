Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaI1Kdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:33:52 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50086 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI1Kdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:33:50 -0400
Date: Sun, 28 Sep 2014 11:33:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: heiko@sntech.de, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20140928103301.GN27755@sirena.org.uk>
References: <1411834906-9533-1-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rdeY6f/ml8+xnc5C"
Content-Disposition: inline
In-Reply-To: <1411834906-9533-1-git-send-email-romain.perier@gmail.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.138
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 1/3] regulator: act8865: Add support to turn off all
 outputs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rdeY6f/ml8+xnc5C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 27, 2014 at 04:21:44PM +0000, Romain Perier wrote:
> When the property "active-semi,system-power-controller" is found in the
> devicetree, the function pm_power_off is defined. This function sends the
> rights bit fields to the global off control register. shutdown/poweroff
> commands are now supported for hardware components which use these PMU.

We really need to come up with a standard property for this and document
it rather than continuing to add individual device specific properties
all doing the same thing, and probably also some helper code and/or a
standard operation for this - there's a lot of drivers implementing the
same pattern here.

> +	if (dev->of_node &&
> +	    of_property_read_bool(dev->of_node,
> +				  "active-semi,system-power-controller")) {
> +		act8865_i2c_client = client;

Indentation seems messed up here - tabs vs spaces?

--rdeY6f/ml8+xnc5C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJ+PcAAoJECTWi3JdVIfQBRsH/jG9HiRNk1r92AiGwMqUGWAq
DrykyN7xeX0riwKdWWJSfV/2B4a3QMmgkpf3bjQapgEKHH+/RkMBPsFPhygDwn7L
NNgRrolQ+KV0Q7Z209X4QaGQAgrIM+lCxim9c50DIrkhXqQ5j9SZc6/7LyIUfXXY
B1s6gHexwZQhX4bEkD8ynMRgk77/vyBTsywbbEOqbBxWsEZt/fp2ZiRKJ0eplv9f
FaHKBwaUyVyGqrRFPBnqnfO3/ZkCExpQ9mZnKe2ZPMFFPOggx6F1cVCNA0jK9uQz
bWWnVJLIWg2xRA3TWezrbdUaF8dmZ2zyZDYS7NKUeOJCTF4u0EQ8ATRGax6+SuA=
=VddQ
-----END PGP SIGNATURE-----

--rdeY6f/ml8+xnc5C--
