Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967958AbaLLNfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:35:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56781 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967589AbaLLNfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:35:10 -0500
Date: Fri, 12 Dec 2014 13:34:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Zhang <benzh@chromium.org>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        Bard Liao <bardliao@realtek.com>, Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        Albert Chen <albertchen@realtek.com>, linux-kernel@vger.kernel.org
Message-ID: <20141212133457.GL11764@sirena.org.uk>
References: <1418271327-14710-1-git-send-email-benzh@chromium.org>
 <1418271327-14710-3-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p0HNO2YbtFeVXwJ3"
Content-Disposition: inline
In-Reply-To: <1418271327-14710-3-git-send-email-benzh@chromium.org>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] ASoC: rt5677: add a platform config option for
 DACREF source
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p0HNO2YbtFeVXwJ3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 10, 2014 at 08:15:27PM -0800, Ben Zhang wrote:
> DACREF power source can come from external 1.8V or codec internal 1.8V.
> This patch adds the option to enable the internal DACREF power source.

> +- realtek,internal-dacref-en
> +  Select codec internal 1.8V as DACREF source optionally.
> +

Why is this not done using the regulator API - don't we need to ensure
that the external DACREF is enabled if it's there?  I don't think we
need to model the internal reference as a regulator (we can just set
the registers up in that case) but if it's off device I'd expect to be
making sure that it's turned on.

--p0HNO2YbtFeVXwJ3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiu8AAAoJECTWi3JdVIfQ9HkH/0qssY6McAPlWY63XTM/VbP4
XzOtQACFpMBzpbH5SP++SIvekcx7QdMU1OBMN+Xw5OjL75nJ1p9glJuI8nD8mNID
BY0YPtqE77U9sj93P3ttrH3dtF+4dgkQTWCkPrWyHkC3NZwCa6ZGJzmBT9IKgd9N
Bpt9AQVef0491eSs5ZK3RWwRtu6rTJenp3H2bMUixrMwR8SB7J4/JL2YMCKfigIy
cMHJPBd2/ZMcoBWdjn0KV+VCB3scr3TIaIp2Y06XAgGFnUQKr1FACUNRsu9cHXJL
1GlZ9vEkgr8VkijbBfOqOiYa5Ztkr2xBoCg8kUoKG0BfcQk1quD+Nex8nns2kx0=
=qYze
-----END PGP SIGNATURE-----

--p0HNO2YbtFeVXwJ3--
