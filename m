Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860Ab3JQHxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:53:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:3236 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3JQHxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 03:53:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,512,1378882800"; 
   d="asc'?scan'208";a="420459314"
Date: Thu, 17 Oct 2013 03:38:24 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: tony.luck@intel.com, bp@alien8.de, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
Message-ID: <20131017073824.GC14946@gchen.bj.intel.com>
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
 <20131017063059.GB14946@gchen.bj.intel.com>
 <1381993136.22110.95.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Content-Disposition: inline
In-Reply-To: <1381993136.22110.95.camel@joe-AO722>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 11:58:56PM -0700, Joe Perches wrote:
> Date: Wed, 16 Oct 2013 23:58:56 -0700
> From: Joe Perches <joe@perches.com>
> To: Chen Gong <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, bp@alien8.de, naveen.n.rao@linux.vnet.ibm.com,
>  m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org, Thomas Winischhofer
>  <thomas@winischhofer.net>, Jean-Christophe Plagniol-Villard
>  <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
> Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
> X-Mailer: Evolution 3.6.4-0ubuntu1=20
>=20
> On Thu, 2013-10-17 at 02:30 -0400, Chen Gong wrote:
> > On Wed, Oct 16, 2013 at 07:59:09PM -0700, Joe Perches wrote:
> []
> > > Maybe add a
> > >=20
> > > BUILD_BUG_ON(__builtin_constant_p(l) && __builtin_constant_p(h) && \
> > > 	     (h) < (l))
> > >=20
> > No, if so, users can't use variables for this macro.
>=20
> __builtin_constant_p checks for constants
>=20
> Built-in Function: int __builtin_constant_p (exp)
>         You can use the built-in function __builtin_constant_p to
>         determine if a value is known to be constant at compile-time and
>         hence that GCC can perform constant-folding on expressions
>         involving that value. The argument of the function is the value
>         to test. The function returns the integer 1 if the argument is
>         known to be a compile-time constant and 0 if it is not known to
>         be a compile-time constant. A return of 0 does not indicate that
>         the value is not a constant, but merely that GCC cannot prove it
>         is a constant with the specified value of the -O option.=20
>        =20

Yes, even we have following codes __builtin_constant_p still can return 1,
so long as the value of variable can be identified.

int len =3D sizeof(int);
if (__builtin_constant_p(len)) {
        do_1;
} else {
        do_0;
}

but the point is we can use GENMASK like GENMASK(end_bit, start_bit) but
we don't know the value of end_bit/start_bit at compile-time.

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSX5PwAAoJEI01n1+kOSLHJTwP/1j0AyXAQJLTx0wyh6l5jEEg
beG4MkqKr3iBEUc6ivjUw2rQWNrQ1BQeFPgMC46CYLlkH0q6RdKNEb0m7IkOTZjt
k1eGGXrvGoYQGmddns2O5s2KuOWQSVV4sgBIlGF4I5wvfgHPGoSpb19Sw9w3hpx2
wAm80hMvAF9W+W2lRt3dDLmeTlFFSa+twLMSKtMPlqUJasCC7kZDnZs14xxU+ZIY
ISnRrC2KSQr99/2W2YfRytg9Ke2QmPfqyI2+dTN6njEKBKGkE8qmKboVSwZEdPX+
H5WV5KXsh3LpI2t3c4fbehlKLE2tEDgyfwez+ojJBFIJt0wviz5TxO60hciPXAqO
lLm6cOIU5REwNtw3RYfBGVuT2Dj0AIMT74+MpW6L6+8YdqFBh06dKIVgiWt3GcoM
Fe8o9cBNZBusm0+ykNW2RoO3mICBLKhzenmYjCPuiyh4aefkMAWZjLgd9IGGnWQh
Uh5FNOdV3MKLQJdC4FHBGMDeXPnr+g0aFsB0qvSxAZtkP4aO2s1XtCbbUDwc9bZ8
bpLuQJ7ahZELfImMkK1oEG8Cj/LL1buDJ7ylHJsfy2FGJ5gCS2HH0mOEDRgxU+mb
v1DVTjLPB8FgLlUam61pN++9K+dk5gJpFloIq7OALuWAoGAcOKPQapeGVOV2NEnx
wyQG4BQilfb7hdOWCAWl
=Sc/M
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
