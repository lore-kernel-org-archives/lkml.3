Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3EJCJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 22:09:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55391 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab3EJCI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 22:08:59 -0400
Message-ID: <1368151722.17344.1.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.8-stable] perf: Fix error return code
From: Ben Hutchings <ben@decadent.org.uk>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        "'Wei Yongjun'" <yongjun_wei@trendmicro.com.cn>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>
Date: Fri, 10 May 2013 03:08:42 +0100
In-Reply-To: <20130423105659.GE3471@hercules>
References: <007001ce3fce$58768be0$0963a3a0$%choi@samsung.com>
	 <20130423105659.GE3471@hercules>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oTGNpG/x+iip9kOjSmfC"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:4022:769e:a966:672f
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oTGNpG/x+iip9kOjSmfC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-04-23 at 11:56 +0100, Luis Henriques wrote:
> On Tue, Apr 23, 2013 at 11:57:51AM +0900, Jonghwan Choi wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me k=
now.
>=20
> Thanks, I believe this is also applicable to 3.2.y, 3.4.y and 3.5.y.

I agree; I've queued this up for 3.2.y, thanks.

Ben.

> Cheers,
> --
> Luis
>=20
> >=20
> > ------------------
> >=20
> > From: "Wei Yongjun <yongjun_wei@trendmicro.com.cn>"
> >=20
> > commit c481420248c6730246d2a1b1773d5d7007ae0835 upstream.
> >=20
> > Fix to return -ENOMEM in the allocation error case instead of 0
> > (if pmu_bus_running =3D=3D 1), as done elsewhere in this function.
> >=20
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > Cc: a.p.zijlstra@chello.nl
> > Cc: paulus@samba.org
> > Cc: acme@ghostprotocols.net
> > Link:
> > http://lkml.kernel.org/r/CAPgLHd8j_fWcgqe%3DKLWjpBj%2B%3Do0Pw6Z-SEq%3DN=
TPU08
> > c2w1tngQ@mail.gmail.com
> > [ Tweaked the error code setting placement and the changelog. ]
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> > ---
> >  kernel/events/core.c |    1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 7b6646a..f6eba58 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -5988,6 +5988,7 @@ skip_type:
> >  	if (pmu->pmu_cpu_context)
> >  		goto got_cpu_context;
> > =20
> > +	ret =3D -ENOMEM;
> >  	pmu->pmu_cpu_context =3D alloc_percpu(struct perf_cpu_context);
> >  	if (!pmu->pmu_cpu_context)
> >  		goto free_dev;
> > --=20
> > 1.7.9.5
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe stable" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

--=-oTGNpG/x+iip9kOjSmfC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUYxWque/yOyVhhEJAQo0pA//a7Q9m5w2Bl+C+miBlxnvxno71aLVY3St
K3IiKNHltWW88qMxKSAVcr/dFQtVw9lkFsuWLxWyUrhp4hgW+iEY340sDNMNC18V
+f1v5oyq3VtqG16UBvmL/nI57JiNhdHJq66XFS3B4ktrio3nNW+yQgYIpTEIVEgb
+yRVBUal9YeNqEBeAByscXeR1kmnqCkUGbkvQB9U+vbUGrOvLaY7hQTkSN+U8nN2
qmCf0fIIyYWA6Sar1PepxcTv+yAPUXeYxgmnUKRAFxCWIFzI3qIHXAeJ06Upy7Ya
x4MedIn+w14kujXmLUk5idnflKjfPV5aymxQVclKxAGcJuBoAbVt1K3RVRFZJHsv
7PwBJpzflI+RJjvxtKFOfHml1KMYb7AdZqg0tNGK7n2dJVI0H1L1vdOF7ocLaboi
ViKmkMT6GP1GRXdB72xUQrJYWYrabfsiWS1SivVEe6X+8ugJwuYkMvLvATcwadAj
2L65TAxi7Y6nTZrmmBG15LrhV7OoKhjYeTFM078MjGti46xpNGwkSs9Y6fS4/RsH
aAsme/z+mVCCSnEV6VRFkhSy+HB5rE03Zal0kpNhlOiRNqFO2jF5/grwY1hAQ/nM
SOYlAYH7tufHnAQWjwmD2IXMhXixHi/2KRHG03YOYHFUstvag4tDvb+bUuL8v+tA
TaSciEsDLsI=
=o4E5
-----END PGP SIGNATURE-----

--=-oTGNpG/x+iip9kOjSmfC--
