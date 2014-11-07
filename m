Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaKGO6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:58:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49077 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaKGO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:58:48 -0500
Date: Fri, 7 Nov 2014 14:58:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20141107145806.GQ8509@sirena.org.uk>
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
 <1415365205-27630-2-git-send-email-javier.martinez@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6yp3DxVbLZXge6e"
Content-Disposition: inline
In-Reply-To: <1415365205-27630-2-git-send-email-javier.martinez@collabora.co.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.165.208
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/5] regulator: Document binding for initial and
 suspend modes
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6yp3DxVbLZXge6e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 02:00:01PM +0100, Javier Martinez Canillas wrote:

> +	  The "regulator-mode" property only takes effect if the regulator is
> +	  enabled for the given suspend state using "regulator-on-in-suspend".

Why?

> +	  If the regulator has not been explicitly disabled for the given state
> +	  with "regulator-off-in-suspend", then setting the operating mode
> +	  will also have no effect.

This seems surprising, I'd expect mode setting to be paid attention to
even if the regulator is off - we may add other ways to control the
enable state in suspend for example.

> +- regulator-initial-mode: initial operating mode. The set of possible operating
> +  modes is the same used for the regulator-mode property and the device binding
> +  documentation explains which property each regulator supports.
> +If no mode is defined, then the OS will not manage the modes and the hardware
> +default values will be used instead.

Again that seems surprising, it precludes any future changes and isn't
going to be true for devices where we can't read the current state.

--d6yp3DxVbLZXge6e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXN3+AAoJECTWi3JdVIfQ1CEH+wVIAHIeDVtR3iEK1BH1GdzP
K6IqQUcMQ2z6/OZgW3FNSArPj6AoGGsWPwlGDYbI/j0pbuo4ufYcZqKLeJmo9iOX
ohGmkmAjqb68EtLlsDghOm1110JXBwr0qqmkFAlawvKT6eZYWnlJs1nyGoyakO/2
isq7C3qxYVzMP1hgOhs2A8LL804kACmd/K7t4eoZJk12KwGi6m/NLM6LOrGunMnF
BUaSZGih9SeqXwxnVcQiHhOUJU8ikcS4p2c8305Qdmmmd9fU/ElLLYbfiU12IEOj
Yzpm9d2v/RqVslJC0bBf14HXAPJzxVngS3ZS3cVWhDcsJFVaAWXRuNsmmUZjueo=
=jVnK
-----END PGP SIGNATURE-----

--d6yp3DxVbLZXge6e--
