Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaH2IYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:24:36 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:52295 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaH2IYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:24:34 -0400
Date: Fri, 29 Aug 2014 10:24:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pwm: Fix uninitialized warnings in pwm_get()
Message-ID: <20140829082430.GC13371@ulmo>
References: <1409216594-31389-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <1409216594-31389-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2014 at 11:03:14AM +0200, Geert Uytterhoeven wrote:
> With some versions of gcc (e.g. 4.1.2):
>=20
> drivers/pwm/core.c: In function =E2=80=98pwm_get=E2=80=99:
> drivers/pwm/core.c:610: warning: =E2=80=98polarity=E2=80=99 may be used u=
ninitialized in this function
> drivers/pwm/core.c:609: warning: =E2=80=98period=E2=80=99 may be used uni=
nitialized in this function
>=20
> While these are false positives, we can get rid of them by refactoring
> the code to store a pointer to the best match, as suggested before by
> Thierry Reding. This does require moving the mutex_unlock() down.
>=20
> Fixes: d717ea73e36dd565 ("pwm: Fix period and polarity in pwm_get() for n=
on-perfect matches")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/pwm/core.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)

Applied, thanks.

Thierry

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUADi+AAoJEN0jrNd/PrOhscwP/i7U57nXEawwSZgTv0x7oRDy
2LbFpcWGeGa5ZlIiElbG21t+QNy1PRezsKUQTb95sa6E775ToQPxJ2LfuNviEo/5
3bv1TM6WGMyqf09aAKLayQynjMKRL3fxgqSZVPo16BQDnHyC7PblvWNPKck5SUsf
QuakIXJj3RQJNrjwM5YyLI0uXLSuAw7J9j3ugFq/qJxzmCUxmPqtSgP4XJys9jbW
EC2iZGTUHXWKyyvhNv1Oj9Wt2159ncMCRLQm8Q5ivHtze5dbdaQKjhuBwYI8J9gl
LwWrFAMP8txrepVwknukvucCh4ksXBzcO4KCjDRtibozImwFocfR4jsELDGroJ2s
djfCcbA/2wnLT3gNt7FdKFbG3tXUCgx+z5DtkfY2N+Xj1ly3rfahYRt7kNtfiyCO
oPeTWywb6tiyDmo9OJIbPioix+CkmgUI3sOCtw1PO2rl/S92k7QrEe7VGu99LJ1u
KlFgoRLGO8yTNYjJbzYWM13ji7j6kPbWej4aYV1foOikjzY6vKc4PWwKyu+zQeqj
ZF/hTVxWlUpzkrfyikG5V8khmsPo1BNbma7KXVFCulf1NYIlkVT1VTbOrjng+yse
wQfUC0QiChwZ0BFOf+BH1HihoHpXYSlSwmoIPiZJsYSnSsLscRgFh/FSAMAEORkS
RDvbQNWCtunlQ34nv4/v
=6g22
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
