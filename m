Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3GXRCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:02:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53765 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3GXRCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:02:40 -0400
Date: Wed, 24 Jul 2013 18:02:15 +0100
From: Mark Brown <broonie@kernel.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Joseph Lo <josephl@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Message-ID: <20130724170215.GP9858@sirena.org.uk>
References: <1374683282-17517-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lnCRbaW8TcgsIoW0"
Content-Disposition: inline
In-Reply-To: <1374683282-17517-1-git-send-email-rklein@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: fix pdata ptr not be updated after it
 has been allocated
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lnCRbaW8TcgsIoW0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 24, 2013 at 12:28:02PM -0400, Rhyland Klein wrote:

> +	/* Store the pdata pointer after everything else passes */
> +	pdev->dev.platform_data = pdata;

No, this is bad - the driver should not be modifying the platform_data
pointer, it's owned by the thing that created the device.  If the
platform data needs to be modified it should be copied somewhere in the
driver data.

--lnCRbaW8TcgsIoW0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8AiUAAoJELSic+t+oim9FlsQAIBi3RQKryKif7cc/B4lQAsu
tIaEDnE0zkscnMDiq+zhJjQFV6B8uG+v1ASk5TPHgpDYM3jTunQMnMybF+Erq0ld
wj7mwmxbix31k/1yS0kNuvE3Jlmo231snhe4ytboOtowmQkCGDDqTV6mlgMMQjhA
JlO/HRKnU4Va4/6JcU7VKiGPbUzBtVD9qSx43Iri1BEHUB1YJRTDTBKgG+RHtVzs
4vSttSdvruKhNtIO+Hx0CfDmSv4A0I/+DyBhcQsjN+RWIVIgpxbI0YQ2W7hsFy7T
RuhMQwrwmm3iq6+v9jEuxRSoN9t/kZWKgfALszUmKydEkbs8gftwMYICQtMfI9dB
A6StW4N+3cidVXQUbtZpLDde6XcKMUhuhx/MVB3v/fP7wh74dW6ckl6NeKvhUaQv
ERS5TaSdFaY7p2rcqMh3EobRiuxQ7fDFszEAhEVZZH2Wc1ku1UXfVBOwAnNLul6a
M3X/iQ155DV5/WVFzsKwUJo7AbZujPdPrtjYaY+NqIJvaQqF5ebqum/SpUGFx7G6
jx2FBXy9t3u8J622buWY91gAxl5mKAVumwi5lMMZikT7c9lkZwG3hkmnAAmZU1KV
1T5IAxFLmOpywnqjrsCPuXtY/Gex3sihfj0vU1mL2+POBo28+HqzP1AaaWoX97VB
bJ979T4SkFLaPScT6KJ9
=EoX9
-----END PGP SIGNATURE-----

--lnCRbaW8TcgsIoW0--
