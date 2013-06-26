Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3FZBFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:05:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53853 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab3FZBFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:05:51 -0400
Message-ID: <1372208742.4006.31.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Dave Chiluk <chiluk@canonical.com>, viro@zeniv.linux.org.uk,
        petr@vandrovec.name, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Date: Wed, 26 Jun 2013 02:05:42 +0100
In-Reply-To: <87fvwev45p.fsf@canonical.com>
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
	 <87fvwev45p.fsf@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Uvnhmsavq49ikuzZOymY"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Uvnhmsavq49ikuzZOymY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-06-19 at 10:30 +0100, Luis Henriques wrote:
> Dave Chiluk <chiluk@canonical.com> writes:
>=20
> > 1d2ef5901483004d74947bbf78d5146c24038fe7 caused a regression in ncpfs s=
uch that
> > directories could no longer be removed.  This was because ncp_rmdir che=
cked
> > to see if a dentry could be unhashed before allowing it to be removed. =
Since
> > 1d2ef5901483004d74947bbf78d5146c24038fe7 introduced a change that incre=
mented
> > dentry->d_count causing it to always be greater than 1 unhash would alw=
ays
> > fail.  Thus causing the error path in ncp_rmdir to always be taken.  Re=
moving
> > this error path is safe as unhashing is still accomplished by calls to =
dput
> > from vfs_rmdir.
>=20
> Stable kernels starting with 3.0 also contain the offending commit, so
> I believe this patch should be applied to stable kernels as well.
>=20
> Upstream commit is 698b8223631472bf982ed570b0812faa61955683.

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.

--=-Uvnhmsavq49ikuzZOymY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUco+Zue/yOyVhhEJAQq6Ww/+MGro4fEMpQ0S6CX/AWhCOKEnGIW5Ln18
1mthv6b4r9MLf/aqDOBZi8unErVnZPt4NagsWm5uoc4oVmax72BlpJ4+OvLGBfpW
2sEEdSsc0d8kMH8HrwnJ8IyC3ak5XlY3iuFhyG81cbQFvZQdOfSsP5XDqVMmZqPP
g6UifHyqw7c1UdNvsUO+bitWI8Mbwr5ShMUvTtf4FGIXPz485efsZJ7pL+zird0f
Df+bB4pc3UHZqcLlq4AffLT/ym+UWaRq+vbr8r0JWwz7ylyjILo+rYaslDT6rC4w
fyfVie9/I7OOzXvL0bNX7tMSaw1SNywaHp0TOKczWXGtG4YvgPMmKJcNbZlRrSTo
/2acTxhWqcFoZxwdy/RBNlET4U3k/EMMS3qn4/c4zt2VfTpzD7Os/juuD4Ctv4F5
v8lJOxyZFdIp7YgDWc1arTpG4PByrppx/vAIRMaKwY/iTVQJ0LgSMX+yz+hVWKK4
5kGMPKaXXhY49jftEcY9Sw3AFpxfXhLf8go8j61qAMiSB9qHZ8jcO30spHBZjueA
XvOsirukW2xAzEpgrm/EERAvsgmuaOScV+YA8rZYCa0ey1Wgbdr9e0aX+S1vauoQ
Drmv5jg37ujjScubq9jMdpX8EdMB8xCa5Fsr8CSrPG4bCuWiPRCv73CkkrsuYjms
BQJt5ov8U4o=
=mTJD
-----END PGP SIGNATURE-----

--=-Uvnhmsavq49ikuzZOymY--
