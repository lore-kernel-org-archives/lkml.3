Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaJHXqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:46:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41494 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaJHXqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:46:07 -0400
Date: Thu, 9 Oct 2014 00:45:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Message-ID: <20141008234541.GQ4609@sirena.org.uk>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
 <20141008223403.GA24828@roeck-us.net>
 <20141008223601.GP4609@sirena.org.uk>
 <20141008225912.GA25134@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RFOVuXNPDwFVwt30"
Content-Disposition: inline
In-Reply-To: <20141008225912.GA25134@roeck-us.net>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RFOVuXNPDwFVwt30
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2014 at 03:59:12PM -0700, Guenter Roeck wrote:

> There is a log message "no parameters" for each regulator. This is printed
> unconditionally from print_constraints().

> Looking through the code again, looks like this is on purpose. It is just=
 a bit
> annoying to get lots of those messages. One of the systems I am dealing w=
ith has
> 17 LTC2978 chips in it, with 8 channels each. That results in 136 times "=
no
> parameters" in the boot log. And that is not even a fully populated syste=
m;
> if fully populated, there can be more than 60 of those chips. 500+ lines =
of=20
> similar log messages is really a bit on the high side.

> It might help if there was a way to silence the messages, ie to make
> "print_constraints" optional.=20

Ah, from the constraints rather than from the DT parsing.  I do like
having it there since it's enormously helpful in debugging and that is
a...  specialist number of regulators you have in your system.  We can
definitely at least add a boot argument or something to suppress them,
let me have a think if we want to do that by default.

--RFOVuXNPDwFVwt30
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNcykAAoJECTWi3JdVIfQSqAH/0kx1+a4TRMXDj7EoP2+j6Bb
6X2DWtwXxewt3o3Ef1LFnyGWa+d4ilNEYagLk3eiCP9J+9j0IgSRYxcB6cI+HNHb
CRhaYmWVLI/23hUcxhPzitDJ/Z7VtUKeo/WoL8zpF7AgVLi+p3x1ID0l53DyUrvD
BA6SmmVpbjgPufcQW9nJjzfNSBlBck/UcpnW5xnEw55+goU11QEZbm7xvQgRqOT2
FY3hheHruGhIcB2q7n9Rdl1rrU1uGd3s728XI4DBoIErcDTQyZdFzGqjMXbzgIbf
/XBInsnQeYNpE8KiuEAP2fPJzXapujUtxqwGozwCHJ7NrBBHDnj5Z2qV+CHhNsE=
=tMpn
-----END PGP SIGNATURE-----

--RFOVuXNPDwFVwt30--
