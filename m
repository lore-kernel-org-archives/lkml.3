Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaJCOox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:44:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60539 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaJCOov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:44:51 -0400
Date: Fri, 3 Oct 2014 15:44:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Marcelo Tosatti <marcelo@kvack.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-spi@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Message-ID: <20141003144420.GC24441@sirena.org.uk>
References: <20141003125609.5BEA11AB276@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <20141003125609.5BEA11AB276@localhost.localdomain>
X-Cookie: The coast was clear.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: fsl-spi: Allow dynamic allocation of CPM1
 parameter RAM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 03, 2014 at 02:56:09PM +0200, Christophe Leroy wrote:

> +config CPM1_RELOCSPI
> +	bool "Dynamic SPI relocation"
> +	default n
> +	help
> +	  On recent MPC8xx (at least MPC866 and MPC885) SPI can be relocated
> +	  without micropatch. This activates relocation to a dynamically
> +	  allocated area in the CPM Dual port RAM.
> +	  When combined with SPI relocation patch (for older MPC8xx) it avoids
> +	  the "loss" of additional Dual port RAM space just above the patch,
> +	  which might be needed for example when using the CPM QMC.

Something like this shouldn't be a compile time option.  Either it
should be unconditional or it should be triggered in some system
specific manner (from DT, from knowing about other users or similar).

--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULrZDAAoJECTWi3JdVIfQbywH/0vlIbyDtXeXSo8Qg0xKxfu+
NmGzbVSizdDFhjhq8+LRSFjKdl6u8cXF+Vuyt+hGXsvAc1c6Vc2XNSWO0eXbq+kg
soGV9Y9UfLx4smuhdcuWqri1qZOJG2k7058AzSZwDWfEwTQ88Sb47cGHv8L69jhn
s7TR2SMnMZ+Gk4JWiZ/lETGbVYspRnKSAnKtu4ubsPRG34wJnhQvc9V9WhGynlKu
hhA/5II3+8grWKmEdWTK/mTQBMoikxJxElN8FPQnogoApnJONM6fsmLH/1O4979K
o/3DAS80NGnPDC23k65b+iOHg2EIXnzfFSYdHXaSUAiWvN5Rjg4hrxyC1IBgxpw=
=cnSl
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
