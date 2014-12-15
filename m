Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751137AbaLORHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:07:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60639 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaLORHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:07:20 -0500
Date: Mon, 15 Dec 2014 17:06:45 +0000
From: Mark Brown <broonie@kernel.org>
To: "Strasser, Kevin" <kevin.strasser@intel.com>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Lin, Mengdong" <mengdong.lin@intel.com>,
        "Fang, Yang A" <yang.a.fang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141215170645.GH11764@sirena.org.uk>
References: <1418282517-851-1-git-send-email-kevin.strasser@intel.com>
 <20141211132026.GY11764@sirena.org.uk>
 <51B6C3CD1F10FB47A5702881E0E230A74A0ECAE1@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aObFJ3I/fcifeQec"
Content-Disposition: inline
In-Reply-To: <51B6C3CD1F10FB47A5702881E0E230A74A0ECAE1@ORSMSX104.amr.corp.intel.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Intel: fix possible acpi enumeration panic
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aObFJ3I/fcifeQec
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 09:55:38PM +0000, Strasser, Kevin wrote:

Please fix your mailer to word wrap comfortably under 80 colums so that
your mails are easily legible.

> > This changes the check from verifying if a codec_id is present to verifying if
> > the first character in the codec_id is non-NULL.  That doesn't seem obviously
> > safer and the tables of machines seem to be terminated by having an entry
> > with all fields set to zero (which is a common idiom in Linux) which would
> > now crash with this change.

> In this case mach->codec_id is non-NULL, even for the terminating element, because it
> is defined to be a fixed width. So we have to take a look at the first character to see if it
> has been initialized.

That's a really unusual and (as you've seen) error prone idiom - is it
not better to fix the struct to use the more common idiom?

--aObFJ3I/fcifeQec
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjxUlAAoJECTWi3JdVIfQdbwH/jMEToQ6JN4EAR2XOTbT9sKH
IRhwFhD20wpAqHL/+GbQUOzDRpoE47WgGXsAr7huYCwv10KRv4DNFr+mD+wTFFJM
eE1eBqjEXcrHS27NEruEZAlSFrpIXLt7Ysd7Aw1NoZ2XefjvVXtQu8fFAgtYRYWA
FdK2kk+23Gtynrb8a6z05cnxZN8Des6/NepHv6wIQ4+GphsTsZ1FKA9t8TTB7Vny
Fa4bP4cdK1FJNSmGa8lH9nFua20nTPuGN4nn7kmAjExYLXrttpAVt+G2b956QMmV
fmB5mBZ/0L6vgkDzvd/c8lQxM1uWbCYEqEPHwNQMT/hdJ+eJkQOVLD0lX/sIXpo=
=TEl5
-----END PGP SIGNATURE-----

--aObFJ3I/fcifeQec--
