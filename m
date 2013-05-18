Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3ERLYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 07:24:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58643 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3ERLYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 07:24:17 -0400
Date: Sat, 18 May 2013 12:23:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130518112353.GR1627@sirena.org.uk>
References: <1657392.sx3qBqNYrh@dtor-d630.eng.vmware.com>
 <20130517205025.GQ1627@sirena.org.uk>
 <20130517215246.GA24730@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4T94Hejb80K+e1gX"
Content-Disposition: inline
In-Reply-To: <20130517215246.GA24730@core.coreip.homeip.net>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Regmap and register ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4T94Hejb80K+e1gX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 17, 2013 at 02:52:46PM -0700, Dmitry Torokhov wrote:
> On Fri, May 17, 2013 at 09:50:25PM +0100, Mark Brown wrote:

> > The general idea is that the pages should be mapped in to virtual
> > addresses rather than real ones so in your example you might add a
> > prefix so all the registers are numbered 0x10000 to 0x1ffff.  The
> > physical registers and the ones inside the paged range aren't supposed
> > to overlap.

> The issue I have with doing an arbitrary offset is that then data
> exposed in debugfs does not match the data from device's specification.

Adding a random prefix on the front does mean you can just ignore the
prefix.  But this seems a fairly odd way for the device to do things to
be honest...  paging every single register is a bit random.

> > We should probably either do sanity checks for this at init time or come
> > up with a sensible way to support this in case someone does decide to do
> > it, though this is the first time anyone noticed.

> Does this mean you'll be open to patches allowing this scenario?

Obviously I'm always open to patches that aren't crazy, though I do
reserve the right to define what's crazy :)

--4T94Hejb80K+e1gX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRl2TGAAoJELSic+t+oim9iVkQAINQy862wkK/90VK5CzIXMEv
BkkWpbhyzZPU3UI17u7vfGe2O4+hFwMtfmGWYQBsIRPnp6Vj6wiSAVOkTr3ObGdw
0M6lIlGiBvvXGC8u264l+qBqCMWg+4Isi/jvsdYr9lHdY+VJpkF6VF8OUs0o3CGl
Cjf37jpRsDg+Ggfml8ahVKZyILVG5XGQmwlNOf8ncuDYYmaYBhEZtUGk9l3L6Zp5
dDuxFDXkgsW6UlCoSkJ4F06oh1Er2GaLMfyiO/l6K/Pz71cadYrwXW4tw0ZkzjbY
/eqEUxDTUX9WRtQ9DtwiqKTIE7DLvrx8opV4M+ECh1aBTNms9ONueyNNwyx0F0Sf
bW4kAw28okUTwaXZASJZpnip78o30nS6AeoqdypWEtOcwesmwOeRc5NCXPtqAbJB
jMzdL+jquS93no4M3uIIGBmQNbIZFoHf4lvQPsTZxqx5Dw7amVarUEtDmHl+rO57
gnkwD+EDZQwg+/xOFVDfW0RrHYbkYWoicT/pXNnONQd6WkSp2rZ5NSrLH0QGdw3H
Q1vCE1w8QXqKK8gWvqv2uoKQSr8cVPxgGdACEDc/EnUUuNDYDQIA73ZjHjbnYUOw
Znd1LS3slVyU8kBGFGp2qY+x6DRuGwySnAiMHERRzmDHLcd+1mTrAxuygUoc0BVJ
Zk5y/xyg8XHyiwGrioOP
=WnEF
-----END PGP SIGNATURE-----

--4T94Hejb80K+e1gX--
