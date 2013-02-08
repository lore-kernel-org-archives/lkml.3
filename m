Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946282Ab3BHLUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 06:20:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35570 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946247Ab3BHLUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 06:20:31 -0500
Date: Fri, 8 Feb 2013 11:20:28 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] regulator: s5m8767: Fix using wrong dev argument at
 various places
Message-ID: <20130208112027.GI8879@opensource.wolfsonmicro.com>
References: <1360119305.8965.1.camel@phoenix>
 <1360119412.8965.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Content-Disposition: inline
In-Reply-To: <1360119412.8965.3.camel@phoenix>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BghK6+krpKHjj+jk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 06, 2013 at 10:56:52AM +0800, Axel Lin wrote:

> Use &pdev->dev rather than iodev->dev for dev_err(), dev_warn() and dev_info().

It's not clear to me that this is actually an improvement, the pdev is
mostly just an internal Linux implementation detail so it's common to
use the physical device for MFD logging in order to help the user
understand what's causing the log message.

> Use &pdev->dev rather than iodev->dev for devm_kzalloc() and
> of_get_regulator_init_data(), this fixes memory leak.

This is a good fix though.  This sort of thing is one reason for
splitting out unrelated changes.

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRFN9qAAoJELSic+t+oim9CLAP/jWUTStapzrzK2DzjziUzB0q
Wym66s329wvRH1/+SwLNywyJ7Wp+6L4nF6bOaohUMS3D8Vsg0BX0xy3UHc6lAgkR
bnyV82qYaBscLwTRs3LhhG2+zyq1XguQfKtucPjKm+E1+GJGTHA/gGgPWfTPBJ1Q
mYGpXCXgFxuIt3zZX8OuNBEZL50kO4RCcbZ37PSczyCUoMcAHGzpfiCnZcCMg+3m
UzuqOQ5LssgLeUco20xepSOdvxMCWlNx1/d6j+FUeF7MqQUH3UKlruDOCcasOjxS
/K7PrlyoOPIY9KxPgrvWamT8l4XKZKT2cwT8oehUG3ANDHZZKuTSg4ZIr+cDHQAD
3HcAhqrpsF9Z1CBqANoTFSjVvxIy0FNqlEw5XVDCV8c3NIUh2/3jd81dK8m/vuys
Za46tzWQ3C3G4NK+muRz00uMs+vVaPjnX6t6IIsUC3uAK/SVvoiT7zmA+Z70edIN
EBCMbehBUEkSv83b2AH95IFNF5KnP9RJRPz1CT9ucz+KWmIOEev5ZeEVixe3Xj+k
G6YNKEoKd0iiiRNsIoLdBznPRmS/WiNiqQrk8G5cBpx1sUXoerutDJ5RaKyOMFkl
LbEMxDc8CnR1YU7+ON6xqknDR0qDbMrPRXC0wd5hWs2dg7mzQu2+on5JJ0tbcw6x
0X3h6x8bEsRMfbDOsHue
=+vNJ
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
