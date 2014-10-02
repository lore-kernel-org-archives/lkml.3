Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaJBNuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:50:40 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44054 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaJBNui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:50:38 -0400
Date: Thu, 2 Oct 2014 15:50:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] s5p-fimc: Only build suspend/resume for PM
Message-ID: <20141002135034.GA9245@ulmo>
References: <1412239691-28719-1-git-send-email-thierry.reding@gmail.com>
 <20141002104321.0b5b6aa2@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20141002104321.0b5b6aa2@recife.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2014 at 10:43:21AM -0300, Mauro Carvalho Chehab wrote:
> Em Thu, 02 Oct 2014 10:48:11 +0200
> Thierry Reding <thierry.reding@gmail.com> escreveu:
>=20
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > If power management is disabled these functions become unused, so there
> > is no reason to build them. This fixes a couple of build warnings when
> > PM(_SLEEP,_RUNTIME) is not enabled.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >  drivers/media/platform/exynos4-is/fimc-core.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/drivers/media/platform/exynos4-is/fimc-core.c b/drivers/me=
dia/platform/exynos4-is/fimc-core.c
> > index b70fd996d794..8e7435bfa1f9 100644
> > --- a/drivers/media/platform/exynos4-is/fimc-core.c
> > +++ b/drivers/media/platform/exynos4-is/fimc-core.c
> > @@ -832,6 +832,7 @@ err:
> >  	return -ENXIO;
> >  }
> > =20
> > +#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
> >  static int fimc_m2m_suspend(struct fimc_dev *fimc)
> >  {
> >  	unsigned long flags;
> > @@ -870,6 +871,7 @@ static int fimc_m2m_resume(struct fimc_dev *fimc)
> > =20
> >  	return 0;
> >  }
> > +#endif
>=20
> The patch obviously is correct, but I'm wandering if aren't there a way
> to avoid the if/endif.
>=20
> Not tested here, but perhaps if we mark those functions as inline, the
> C compiler would do the right thing without generating any warnings.
>=20
> If not, maybe we could use some macro like:
>=20
> #if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
> 	#define PM_SLEEP_FUNC
> #else
> 	#define PM_SLEEP_FUNC	inline
> #endif
>=20
> And put it at pm.h.
>=20
> That should be enough to shut up to warning without adding any footprint
> if PM is disabled.

I think you could use __maybe_unused to that effect, but it has the
disadvantage of hiding such messages forever. For instance if the
suspend/resume code was ever to be removed, then you wouldn't get a
warning at all.

And there's a corresponding #ifdef for the fimc_runtime_{suspend,resume}
and fimc_{suspend,resume} already anyway, so I don't see much point in
trying to avoid this particular #ifdef.

Thierry

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJULVgqAAoJEN0jrNd/PrOhm9MP/3AMXKYx6z6VkLQD/K5lKqKe
zXihuNR8/ViRLTA6/svdhnj+JnidSaJmpRWdpQAW7G/pbDBXJvtY6DPJxTCpNu74
bfhAg2La/0S8tiiQuEpM9cPH3EuTKV8Msa/GkF9PRKcf47TU+QH3Hvm/vgOtxKyO
HPgtOlPBvcdC5VFmz5Na6XlRMTg+YG42pxc3dv5vo6wSBqhdOvTMpdqZj9zR0F+W
x2BklvfTKQOWumyXHzlLU0hQW9zodHq+KUnj8Uu9pbcitBtdJWWt5kwLi1K6lKFm
cem037BbTzOxk+WRd5leg0SaX3yR45si+mrb5o0qLIAWQhivI6N0fWo1UA9+JAqe
Ep1cn5pDkveKqISqGG15rZdCIj9idrrfXz3+330XoiP/7s7bz+KIswX6nUwJYoKS
6T7jD9gG9L2ziPEIALRuJiA/Mo6M5LM0hn+wWOYFW0O65CnG3ylk5O7J5MUA9Z/H
lGtdlid2HwWDiEwZexW58Fsom8ziXwphfQVcbAaJSZlYn1N0wNq1O4vFuI55YUuL
K35uLQEqti3IZkdoOW5KcfvOUDjebKW5xM+cP6hkOjK4O7qKxZAEfRJcFbzdC+N6
Rf1uA6lkf81s3QEtuOCfARbbj7pTs5IxEvBjf0FZX4Lg1Am2XQv41GsTh3145WpF
7T32CcgbL+SVfhnHwqyc
=nqnQ
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
