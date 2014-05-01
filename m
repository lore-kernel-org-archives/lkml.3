Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaEASoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 14:44:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54251 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaEASov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 14:44:51 -0400
Date: Thu, 1 May 2014 11:19:08 -0700
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Anton Vorontsov <anton@enomsg.org>
Message-ID: <20140501181908.GS3245@sirena.org.uk>
References: <1398264640-12122-1-git-send-email-k.kozlowski@samsung.com>
 <1398264640-12122-6-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tm3avfvRG8umVcF7"
Content-Disposition: inline
In-Reply-To: <1398264640-12122-6-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH part2 5/6] regulator: max14577: Implement SUSPEND mode
 for MAX77836 LDO-s
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tm3avfvRG8umVcF7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2014 at 04:50:39PM +0200, Krzysztof Kozlowski wrote:

> This patch adds support for mode REGULATOR_MODE_STANDBY (and NORMAL) to
> LDO regulators by implementing the set_mode() and get_mode() operations.
> However the necessary regulator constraints (valid modes) are not parsed
> by of_regulator_match() so the driver adds them manually to the
> regulator init_data.

No, that's not the idea here.  The reason that the modes need to be
explicitly enabled is that there's an element of board design in
determining if a given mode can satisfy the required current demand for
the board with sufficient quality (usually the lower power modes have
both a lower maximum current and poorer regulation accuracy especially
as the current rises).  Doing it unconditionally isn't in general
reliable.

The reason that the modes aren't supported by DT is that defining a
binding is hard - it's not clear what exactly a "mode" means since it's
basically a Linux internal thing.  We probably need to explicitly add
definitions of the modes to the bindings for individual devices
unfortunately (ie, saying "mode X maps to Y in the datasheet", possibly
using the datasheet modes in the binding for ease of use and having that
translation in the driver).

Ideally we'd be able to have the automatic mode setting working for
devices but in practice nobody wants to publish the numbers and working
out how much the board needs can also be hard so that isn't really
practical.

--Tm3avfvRG8umVcF7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYpAZAAoJELSic+t+oim9/bQP/jWnZ8WJOCvHFBAQE+tJL+AU
4l8iencVvI0id7oJKTyEHg5xcAXFqi5gd+MeLScXD4U1RI4xDKw4CPnsWCKcNryR
B4eTmttpulG+2asn/hGUKBSJvhXZvCMPbyyw+MTqTAs44fy1a5emf3eOV3upcTN9
ZWPtFOHgP+Hf/XQUBVmz0ON3zY4Yi4XY/+AqpvuDCVZjBueCJ6gmpt3WXOaFZb0P
C2mM216sW/cUj3RU2F8+qI+vh/bbboqrfgaSU8q6+chaKWbTk04UTBEuDSCduZk9
ckF/5nFpKySEj1RLA223IT083YBGClOASr6sAwisplTl18Wbl8O4n3DFBaHpEicZ
Z6BLh6Qi3I0xi/bcGDQjixhTZ0y/ODDA/lqTH7vuW1nEcHYIwwZe/+pwGEW7gQ3D
1NVCaoaeLbQkBhoqzVfpBstzl/5eDhgg3Au6Ff19KRJ0rDmUDEsxF7O3EXBSvTFk
cxKSa8tI0X6GV0Smjl64T0zNht3TxgIDCX5ABGeUAoTpMylAezJrTzrfZ59jVPU2
XgmZFk1vDFBipSLy4bTAxgUJpoDV7huBtM2auOwsHGculL+72P8NsMAelLzZuN+p
MX5dP+ihLg0szfXuIY4IkryjeQisIoelLb4M27ZVYpplr72NPpUDKyveGPeRIb6l
2kBHlYqkcQrxoXEQbLfR
=8Wyy
-----END PGP SIGNATURE-----

--Tm3avfvRG8umVcF7--
