Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbaBYMmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:42:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51668 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaBYMmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:42:44 -0500
Date: Tue, 25 Feb 2014 21:42:37 +0900
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        devicetree@vger.kernel.org
Message-ID: <20140225124237.GG25940@sirena.org.uk>
References: <cover.1392995566.git.moinejf@free.fr>
 <4dca81f45b67a4dcb21271e57409ba114c3b59cb.1392995566.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0AE7xBcoXTow8yBG"
Content-Disposition: inline
In-Reply-To: <4dca81f45b67a4dcb21271e57409ba114c3b59cb.1392995566.git.moinejf@free.fr>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] ASoC: simple-card: Fix device node locks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0AE7xBcoXTow8yBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 06:25:12PM +0100, Jean-Francois Moine wrote:
> Some device nodes stay locked and some other ones are not locked
> while being used during the card lifetime.

Please pay more attention to describing your patches clearly in
changelogs and to splitting them up for review.  This is a frequent
issue and it does make it much harder to check what's happening.

In this case you're not actually working with locking but rather with
reference counting and there's no real description of the actual errors
either.  Saying something like "function X takes a reference which we
need to drop" would help a lot, and it would let us think about if it's
sensible for the function to return holding the reference in the first
place and how long the reference needs to be held for.

--0AE7xBcoXTow8yBG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDI+5AAoJELSic+t+oim9GL0QAIieIbNbLSitT8rabMy2nezx
bczJ3Q+mvo/lKuBklY3mjK/3IpfVY0/HAvKKaKvdlP2N15pC2ftEfKgbHd4VyMm9
o6hrJ2BmwXPKGl8v/VasBPar0lkI2N1wA/yXzsrapjsiLkT4QhtVHVgZ3EwOVTdE
2wtZv56oz4IyAo0+kfhQ/hVOrElbujXPrUK+sCQYJ1a+hl3IGbxsxv/yDvM5zXrx
JwEtDM0LuxH+/bpKWUMf2j8cWdGEoPR0CiPr8GCGZEoqy8YwBsnLiGUzA00pF7tM
iO/GX4cv/mcIAMblhI+lA2rOT5y8lc1U1tEtQAd+bwPEThdzHxBerGksaRRpb9Ki
PSLLHjocuai9B50COuugqCv7bypHgDeZx5aXCNNTcYyfoTw9b3FbnT/1Exuo4jIV
efVI5fc9H80JZLro04M0b8jVMMCty7AdkhrZOxLAgk/Q3tx0Y+SRZmLq6BlsaVUd
dp6bKeCRLA/z27+fE20yX8ZxqKtHMVw6I3yi8R5CXz5To1YYo3ctvuYqLIDAva5I
ZLFkrgO+o/fygessg2Dk2QB05JDre/Xnq7w5MyDYTAgpr9Wiw7wVZBE1CFXqmr7k
8mvFxj8wor2T8J+bqKsT2eoqyWsZ7qT543KsmOkmNSlNH9Ik6dJqzMvkMDoN4eNp
09IHrwdP/HD+TRR4+ya2
=AlD1
-----END PGP SIGNATURE-----

--0AE7xBcoXTow8yBG--
