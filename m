Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab3FSJXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:23:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42955 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933820Ab3FSJXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:23:18 -0400
Date: Wed, 19 Jun 2013 10:23:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>
Message-ID: <20130619092310.GS1403@sirena.org.uk>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
 <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130618180948.GP1403@sirena.org.uk>
 <20130619074437.GF11878@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FdZ5NtWbL8qlnu/5"
Content-Disposition: inline
In-Reply-To: <20130619074437.GF11878@intel.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is
 runtime suspended
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FdZ5NtWbL8qlnu/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 19, 2013 at 10:44:37AM +0300, Mika Westerberg wrote:

> I agree that it is better handled outside of the driver (or provide some
> API for drivers). One thing that immediately came to mind is
> adding pm_runtime_suspending() that could be used here like:

> ssp_int()
> {
> 	if (pm_runtime_suspending(dev) || pm_runtime_suspending(dev))
> 		return IRQ_NONE;
> 	...

> or something like that?

Yes, something like that (probably include the suspended state in the
suspending check).

--FdZ5NtWbL8qlnu/5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBAgAGBQJRwXh7AAoJELSic+t+oim9OacP92s25Jtgz+woy/wJq4J+GXs/
FQu0reQaXjAG9dSJIQE/9jNXX25WwAUOtBWexMy6M3t36wXFbKOaGPaSZANNPCDp
KUX3om2pzWmSfq7SbVSUESaHnCDN4kMqwXgkdYzvw+j+94Pd1iwYwvupZtdJyxNz
k4YorACQ5PZl2iBjhae/m5yMiNy73aeRyLaNaAX5i0PsuVdCGEjlVBbppHVhX3/F
9b5BFJu+TcA4gP0P7XNfwtPDLeT0g9tydwrYYrnec5Por3B39K2iwbyT08duFfIs
+yuQbNimPXoT7xESmHokdclwoTgXF3rnM2obwarseZveNk2oTD51MyMC88h8HCiv
D3u+vBMo6YENthbSFrByv1LUpI4aSLWqSgOL6k4qjEcUiXKOAwL+0/IrscPShE4J
++kkmKLJ6tDvgy7QEhDFnYWVYJnW1HPMuVqRY5gfGDTeotsAPsrEXY4BCn8DZBuA
rIc2J+oQHwHtSH4KbacY//CGYvrU2if3dSxlq1O3VB1cPLMufdr4hYJk2k3Twr9+
NBkbjK/DBYMT+zwZGN8i9WzVQHV/JfFkLIvMexx7boScNjNvkFyd64J+MlTGmIgI
23bqa+6HF0V35F5d9FTFxSx723lF65/6fl5dofrBB2fpLUKgVBTF8c0R1I56w/C5
4/1GJLEpJM73kLTEfbw=
=pkWG
-----END PGP SIGNATURE-----

--FdZ5NtWbL8qlnu/5--
