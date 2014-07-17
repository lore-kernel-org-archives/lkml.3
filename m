Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaGQTmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 15:42:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42428 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaGQTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 15:42:40 -0400
Date: Thu, 17 Jul 2014 20:42:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140717194215.GH17528@sirena.org.uk>
References: <20140716121029.GA22222@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U/fatWn3w9i48dtV"
Content-Disposition: inline
In-Reply-To: <20140716121029.GA22222@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: arizona: Disable AIF TX/RX before configuring it
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U/fatWn3w9i48dtV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 01:10:39PM +0100, Richard Fitzgerald wrote:

> If we don't disable the AIF TX/RX then we may fall into a
> situation where the new AIF settings are ignored by the device.
> For example, this problem manifests when switching between
> different sample rates.

So, what this does is momentarily disable the AIF when reconfiguring.
That will glitch any running audio, making me wonder if the driver
shouldn't be returning an error or at least complaining if it has to
reconfigure instead.  What's the use case where this might get
triggered?

--U/fatWn3w9i48dtV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTyCcUAAoJELSic+t+oim9hiwQAJizNsa+8f4DamujnlTjXFA7
rrC2kPZz0ICCV/qmok3MWo0uRC4oVZabUDQ7Q9FKpWDyr4if7OzCYPGJuBM07CMg
qNYq/+5WQ1dI5Er6CPrVAaZ9n4icdgfqAqLAFZLnOWACasiw2f3LD/w0ROhMyZ20
mgrmUst3OBiiJ2PJ7i4gzZIu+fOXlKeJd2Du4SIOpqrenrfhra5YJxsXap/F/NT6
+tf1N0AmyEo7363X3FUVFYpi+nFyhKBRwqr0JLn8cbjCCFTcCyfrS29VNnx7VFDC
/ljgUW4eQRT5ShTE356soYn+VqkEEZfdOzyxSbwZIo1suK6bXCN6xpI/bZIsmE/k
GdGM1SvwPsS4f2d5WRHDMn+kFe7dqt7Ss60VatALNxxMTdIZJYIo7Js7i6vVYWdp
leihBTFRR0otf60T9zzxgcrAORe0OVPbucHqfVkY3h5lFcJIM4aBQ5lYuL6/gZDa
rFwK8FHdrdB94RF3B/n3hqAcAGVW4/BAUTM7c4aWJzOyOMha6ABo70f1FLwMEnls
6LN33sk6vuiONKmMPnDYQy4RBXj2cZTUfCxUeORXwcao6zr/7s8HNF7PX45+FIrd
PPwtv3YGI2AZpol5U+fsiwYmqwg778bWRyKfbKX6/iosWNUXmpZIGE1rcAcN9rl/
XSMNL7bSUxNmznqiZ09o
=lu0+
-----END PGP SIGNATURE-----

--U/fatWn3w9i48dtV--
