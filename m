Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3B0Fhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:37:41 -0500
Received: from ozlabs.org ([203.10.76.45]:39704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab3B0Fhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:37:40 -0500
Date: Wed, 27 Feb 2013 16:37:38 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, hongfeng <hongfeng@marvell.com>
Subject: orderly_poweroff() is no longer safe in atomic context
Message-ID: <20130227053738.GN30946@truffula.fritz.box>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rdbbj4JunmnVtKq/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rdbbj4JunmnVtKq/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit 6c0c0d4d1080840eabb3d055d2fd81911111c5fd "poweroff: fix bug in
orderly_poweroff()" apparently fixes one bug in orderly_poweroff(),
but introduces another.  The comments on orderly_poweroff() claim it
can be called from any context - and indeed we call it from interrupt
context in arch/powerpc/platforms/pseries/ras.c for example.  But
since that commit this is no longer safe, since
call_usermodehelper_fns() is not safe in interrupt context without the
UMH_NO_WAIT option.

I'm having trouble understanding the commit message to see what the
original bug being fixed was.  Specifically I can't make sense of:

  |  The bug here is, step 1 is always successful with param
  |  UMH_NO_WAIT, which obey the design goal of orderly_poweroff.

And without understanding the original bug, I'm not sure what the
correct fix is.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--rdbbj4JunmnVtKq/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEtm6IACgkQaILKxv3ab8bHqACcDXLieNEM2er1w7ceXbMBAQPZ
1L8AoIKAU+pjGp5rTKgtAaVbjhLccXyg
=VelM
-----END PGP SIGNATURE-----

--rdbbj4JunmnVtKq/--
