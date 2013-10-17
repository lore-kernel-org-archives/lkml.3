Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3JQGqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:46:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:1832 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab3JQGp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:45:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,512,1378882800"; 
   d="asc'?scan'208";a="412392324"
Date: Thu, 17 Oct 2013 02:30:59 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: tony.luck@intel.com, bp@alien8.de, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
Message-ID: <20131017063059.GB14946@gchen.bj.intel.com>
Mail-Followup-To: Joe Perches <joe@perches.com>, tony.luck@intel.com,
	bp@alien8.de, naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com,
	arozansk@redhat.com, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Winischhofer <thomas@winischhofer.net>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
 <1381978749.22110.76.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <1381978749.22110.76.camel@joe-AO722>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 07:59:09PM -0700, Joe Perches wrote:
> Date: Wed, 16 Oct 2013 19:59:09 -0700
> From: Joe Perches <joe@perches.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, bp@alien8.de, naveen.n.rao@linux.vnet.ibm.com,
>  m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, Thomas Winischhofer
>  <thomas@winischhofer.net>, Jean-Christophe Plagniol-Villard
>  <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
> Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
> X-Mailer: Evolution 3.6.4-0ubuntu1=20
>=20
> On Wed, 2013-10-16 at 10:56 -0400, Chen, Gong wrote:
> > GENMASK is used to create a contiguous bitmask([hi:lo]). It is
> > implemented twice in current kernel. One is in EDAC driver, the other
> > is in SiS/XGI FB driver. Move it to a more generic place for other
> > usage.
> []
> > diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> []
> > @@ -10,6 +10,14 @@
> >  #define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long=
))
> >  #endif
> > =20
> > +/*
> > + * Create a contiguous bitmask starting at bit position @l and ending =
at
> > + * position @h. For example
> > + * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
>=20
> ull
>=20
> > + */
> > +#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
> > +#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
>=20
>=20
> Maybe add a
>=20
> BUILD_BUG_ON(__builtin_constant_p(l) && __builtin_constant_p(h) && \
> 	     (h) < (l))
>=20
No, if so, users can't use variables for this macro.

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSX4QiAAoJEI01n1+kOSLHLhoQAInW+q5yvH1dYUdhudDzdgpl
K6edVgyywW24vD39XyXJ/xZhgw/bnlv+bKtxbucu9Ma0Wx/IIP3L2Y5lPMgEkWhx
f3JlL3GEVh/HuEFId7UxpC0EzvPLZ0fEYXDUbIiasgc2McsPSTSbsiT4o8Gagz0W
SIcyblIKMX8oc+EAv2L1a9jH69awuVGY1Jh9iCi820LH3JPomfF8YULUZwR/p2wu
cn0+XpoVN6kZwFJuHsE3K8apZAWPYHwjXrUfpfxlOlZU72mlyjND7RSSlwKD91xJ
rByvlxnLymCkedJarGM7cTV/o602yrS3XDnvmpQE07gkVe09HjPhlgkJPqJTpxCb
FSG/8WPNP2pwwQ5s45C6pkdhtWloHpegKkyEQocLXjY3qp201tZVDnJUBl/u9N6c
ZqL/t/IOdD4O4VGIa2wbv/l00O1KoHaKPyQjGXPec4L2lm690958rWTRB5QQM4DT
MNtPrRBKOpJqGezjZ62HU2Dy6V3yqBn/t5IYz9MXlSV9z/8meRYMdjPa/PFdd4FX
2/v7wORkfvbI39Rvepkfg1kCkQn9aMwDFHh49Bly9Jy/09KTsBE79JnLA+FLtzK/
1SzNgJSt/0ndLz495rZ52QNvUwDhM6gyWeW1JbPABFkuFtZSS6n/2wNuCjq8NoJq
ppOdB9HKvYDoz+nIZPUF
=eRZD
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
