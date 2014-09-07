Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaIGCmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 22:42:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38151 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbaIGCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 22:42:34 -0400
Message-ID: <1410057728.7389.24.camel@decadent.org.uk>
Subject: Re: [PATCH v2] deb-pkg: Add support for powerpc little endian
From: Ben Hutchings <ben@decadent.org.uk>
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, Gabriel Paubert <paubert@iram.es>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Sun, 07 Sep 2014 03:42:08 +0100
In-Reply-To: <20140905120925.GB3846@oc0268524204.ibm.com>
References: <1409894927.11359.26.camel@ale.ozlabs.ibm.com>
	 <20140905071344.GA16024@visitor2.iram.es>
	 <1409903718.11359.30.camel@ale.ozlabs.ibm.com>
	 <20140905120925.GB3846@oc0268524204.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-JmYE29X0qWPiP86bFq5H"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JmYE29X0qWPiP86bFq5H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2014-09-05 at 09:09 -0300, Thadeu Lima de Souza Cascardo wrote:
> On Fri, Sep 05, 2014 at 05:55:18PM +1000, Michael Neuling wrote:
> > On Fri, 2014-09-05 at 09:13 +0200, Gabriel Paubert wrote:
> > > On Fri, Sep 05, 2014 at 03:28:47PM +1000, Michael Neuling wrote:
> > > > The Debian powerpc little endian architecture is called ppc64le.  T=
his
> > >=20
> > > Huh? ppc64le or ppc64el?
> >=20
> > ppc64el.  Commit message is wrong.  Fixed below.
> >=20
> > Mikey
> >=20
> >=20
>=20
> What about ppc64?
>=20
> Also, I sent that already a month ago. Both linuxppc-dev and Michal
> Marek were on cc.
>=20
> http://marc.info/?l=3Dlinux-kernel&m=3D140744360328562&w=3D2

Anyone using powerpc (32-bit) will then need to add ppc64 as a foreign
architecture before they can install a 64-bit custom kernel.  This is
fine in principle, except that ppc64 is not an official Debian port and
its packages are not mirrored on the same servers.

I just tried something similar, which is to add x32 (also unofficial) as
an alternate architecture to my biarch x86 system.  APT now complains:

W: Failed to fetch http://http.debian.net/debian/dists/experimental/InRelea=
se  Unable to find expected entry 'main/binary-x32/Packages' in Release fil=
e (Wrong sources.list entry or malformed file)

W: Failed to fetch http://http.debian.net/debian/dists/sid/Release  Unable =
to find expected entry 'main/binary-x32/Packages' in Release file (Wrong so=
urces.list entry or malformed file)

W: Failed to fetch http://http.debian.net/debian/dists/testing/Release  Una=
ble to find expected entry 'main/binary-x32/Packages' in Release file (Wron=
g sources.list entry or malformed file)

W: Failed to fetch http://http.debian.net/debian/dists/wheezy/Release  Unab=
le to find expected entry 'main/binary-x32/Packages' in Release file (Wrong=
 sources.list entry or malformed file)

E: Some index files failed to download. They have been ignored, or old ones=
 used instead.

So I think Michael's version, leaving big-endian kernels as powerpc by
default, is preferable for now.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-JmYE29X0qWPiP86bFq5H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVAvGBue/yOyVhhEJAQqPuhAAg7EuOtddbQWZUG/rVs+9HYNZcjimNvyL
CYuQJju1WguqqYaoSlN7End5Io1yHjOoMBvLKcRvJHcX937237f7F7H3lKDl116B
0rvJGJCOngiv5PnWqE3BpeLtVVS1uAl0MzVS3xwitcV5Yis2wRZggOspC5O3LMs6
UnlKEE0BbAEA0Ht5vBr6WNJqj5Sgiqfh84LhLaDV2abftI5k2EM8ebc2tM4LDKH2
/jG6SEBSqALWl1VZ70Y/pXBN8VhmgU2HfaB0KCMr8rI942wZyC84uTp/2f0roA90
Eit2gMu/xLV5WsMTxZukh9ylSaYTqBoZcf1cULntws1rsC26xap4500stXSr15EU
nq6M6j9DPbJxFMcLyTpYTLLDaIR1l86f2LUWHjqNnhVZfcfD8akLkqqGq5DD3Obk
bP6Gb2sCOtQmyvM4d/blW9+p1LG7xabymLZmdvftQBPOVc2NlFwskwy74u5hX/DP
PAGg3RGe2vBO/swxlExrssU0dX6AFJjovTNgKsW9kE3Ae8GDaNN7cDaUJ+KETYQW
W3IP07oMaWCOfywokgw36/udeUyoEAHpgb7eCIXa3thzPn3nY2IcG9F4eAfDnjlO
dlOFzF8sGbgnKfv+W/MLGIVV50vre1xJ0LlFonz07+Xv10/MOHJCvvhD/sDy+rjS
qrpiAqWeIjM=
=FfrF
-----END PGP SIGNATURE-----

--=-JmYE29X0qWPiP86bFq5H--
