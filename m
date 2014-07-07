Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaGGPrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:47:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaGGPrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:47:18 -0400
Date: Mon, 7 Jul 2014 17:47:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH V2 2/3] perf protect LBR when Intel PT is enabled.
Message-ID: <20140707154708.GO3588@twins.programming.kicks-ass.net>
References: <1404324855-15166-1-git-send-email-kan.liang@intel.com>
 <1404324855-15166-2-git-send-email-kan.liang@intel.com>
 <20140703073321.GU19379@twins.programming.kicks-ass.net>
 <20140703155237.GQ5714@two.firstfloor.org>
 <20140703170711.GW19379@twins.programming.kicks-ass.net>
 <37D7C6CF3E00A74B8858931C1DB2F077014C6431@SHSMSX103.ccr.corp.intel.com>
 <20140707154635.GG19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e8/wErwm0bqugfcz"
Content-Disposition: inline
In-Reply-To: <20140707154635.GG19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e8/wErwm0bqugfcz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 05:46:35PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 07, 2014 at 01:57:16PM +0000, Liang, Kan wrote:
> > > > This doesn't work, e.g. hardware debuggers can take over at any tim=
e.
> > >=20
> > > Tough cookies. Hardware debuggers get to deal with whatever crap they
> > > cause.
> >=20
> > If so, I think I may discard this patch (2/3). I will resubmit the
> > other two patches as a patch set to only handle the KVM issue we
> > found.  It checks the access of LBR and extra MSRs at the
> > initialization time and set the flags. So we just need to check the
> > flags at runtime and avoid the protection by _safe().=20
>=20
> Right.
>=20
> > For Intel PT and LBR handling, since the PT codes haven't been
> > integrated yet, I will try to implement another patch later.  The
> > patch will add flags for LBR and PT.  When enabling PT, it checks LBR
> > flag and update the PT flag. When enabling LBR, it checks PT flag and
> > update the LBR flag. When disabling LBR/PT, we just update the related
> > flags. we don't need to add _safe or extra rmsr in fast path.=20
>=20
> Yeah, should be part of the PT patches.
>=20
> > How do you think?
>=20
> With my brain, much like all primates :-)

Also, teach your mailer to wrap text at 78 chars or so.

--e8/wErwm0bqugfcz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTusD8AAoJEHZH4aRLwOS6QKYP/ivTr/FaujVwtRcg9QF5ifNN
lfmGcRnvydaBpUmSg0JE58jktdg+X63MC9pZvBz6Apv8Pt2L4nCMMgwt0p2CSLfg
VGniQ8+9QNWE8Dm+Ita+vjWM2nqC2aRifh61tTFz+WspHoJDm7x1zeFXxDxi22R9
xNqFQpSe+t01YrOIi2tC91iQDnwExGVFzfAC6Leb/oczY8IUSjhGoT8zmatSCBF4
UeiPNC391qMJT0TaDmIbOdZ7lOVCzGlePr9SKfTMZq4h9lNqZPRw4bCFqSR1lmEm
OpEsgBNnWZGvuXyjsStvtUsHA6Lfevmzpd17GWSKtVCZDGFhsHaCfbKI6HrN+Rsj
vuky5wtY/UAOvKujE4IgzMZ5FDpXzJoYOAl0FizUAa3+Xlk9pPowyztVH7Aqwx4a
XDXNb7dlOcLDAiO/Ra4/tWp8nKoHTF0ZCnyDNaUkbTp/gZ7/685KZdX0cOLl4Wkq
82r2ojdklSpyQu75La43qyXrpwp7g9Fp5EqaAmy+oTT/KgRwUd3goGDdKLW1AmA7
ymIl32tIa/DgXxezVZwDYJlfNppvim1iGp7K1F8bfocSz4VuwfSDwe/lTxinbi7I
k+hKIu9I3tLZI0GT7DxfPApqE3f4pVRKE+57J3L35+MicGF1XPsJCg5VxQk0xd3R
TiyF3dSsSRLhy8jRDLln
=/jpg
-----END PGP SIGNATURE-----

--e8/wErwm0bqugfcz--
