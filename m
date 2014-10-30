Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbaJ3LXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:23:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57030 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbaJ3LXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:23:18 -0400
Date: Thu, 30 Oct 2014 11:22:43 +0000
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Huan Wang <alison.wang@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20141030112243.GV18557@sirena.org.uk>
References: <1414552896-20797-1-git-send-email-b18965@freescale.com>
 <20141029113634.GF18557@sirena.org.uk>
 <718ee124537a4f4091bdf5242d256705@BY2PR0301MB0613.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVfNuiS7HlVt3T7n"
Content-Disposition: inline
In-Reply-To: <718ee124537a4f4091bdf5242d256705@BY2PR0301MB0613.namprd03.prod.outlook.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] audio: sai: Add Power Management support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qVfNuiS7HlVt3T7n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 30, 2014 at 03:30:40AM +0000, Li.Xiubo@freescale.com wrote:

> One more thing, if the device is not performance critical, then shouldn't we
> Take care of the cache memory consumption to determine using flat or rbtree
> Type ?

Yes, it's always fine to use a rbtree if it makes sense - it was just an
unusual choice for a device like this that didn't seem to be discussed.

Depending on the register map a flat cache can actually be more memory
efficient sometimes since there's some overhead for the rbtree data
structures, if you've just got one block of registers with no gaps a
flat cache is going to be a win there.

--qVfNuiS7HlVt3T7n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUh+DAAoJECTWi3JdVIfQh2MH/jdbvpitCAym6GZEz+uOSx2C
GT2ucOcRELRheT5iNiUhxMz5Q8pkjn81JU44gUsWr3bbtSeaiFLiA5T5If/WASWo
1Qd0HnLjZyFQUJwx0b4nFiH+d3+Y7WPSD/ADplGTEVDedUkXcuU8iKWXpXfRigKv
AGwHvADzJOAkyxmI4DqCo9wALrgpBv3qzxTG7BHNi5fbI/1VHAceNnc/DYN9S+Ev
22rv4/nnOZ+fZwRihP8+W3YZFU1cMp27W3S8wUDSLumGH/MXuZV7CeTB8lJM2jTF
1OSuL15SDBqDHqxqOaC1moYaWmgK//1St938tiohHXCTwQeFsM4c9LSCNX7Zrg4=
=NKTJ
-----END PGP SIGNATURE-----

--qVfNuiS7HlVt3T7n--
