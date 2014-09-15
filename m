Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaIOQgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:36:53 -0400
Received: from bues.ch ([80.190.117.144]:42389 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbaIOQgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:36:52 -0400
X-Greylist: delayed 1342 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 12:36:51 EDT
Date: Mon, 15 Sep 2014 18:13:31 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Amos Kong <akong@redhat.com>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, mpm@selenic.com, rusty@rustcorp.com.au,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] hw_random: increase schedule timeout in
 rng_dev_read()
Message-ID: <20140915181331.4e3f5fed@wiggum>
In-Reply-To: <1410796949-2221-4-git-send-email-akong@redhat.com>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
 <1410796949-2221-4-git-send-email-akong@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/k2AhhoIPntp+aTxsAG=dZk/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/k2AhhoIPntp+aTxsAG=dZk/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Sep 2014 00:02:29 +0800
Amos Kong <akong@redhat.com> wrote:

> This patch increases the schedule timeout to 10 jiffies, it's more
> appropriate, then other takes can easy to hold the mutex lock.
>=20
> Signed-off-by: Amos Kong <akong@redhat.com>
> ---
>  drivers/char/hw_random/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 263a370..b5d1b6f 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -195,7 +195,7 @@ static ssize_t rng_dev_read(struct file *filp, char _=
_user *buf,
> =20
>  		mutex_unlock(&rng_mutex);
> =20
> -		schedule_timeout_interruptible(1);
> +		schedule_timeout_interruptible(10);
> =20
>  		if (signal_pending(current)) {
>  			err =3D -ERESTARTSYS;

Does a schedule of 1 ms or 10 ms decrease the throughput?
I think we need some benchmarks.

--=20
Michael

--Sig_/k2AhhoIPntp+aTxsAG=dZk/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUFxArAAoJEPUyvh2QjYsOGCsQAJK4Wd0MLbTsJSE0dnSuW7zm
+lF26LyK0hZJDv84A1SO9/KxnGLAPVNsdZWPCQ2G27OMxOZ6NLIbHJqdSoIImF7L
Y4EncdeOKFmu+W78PxqgJV03LkBTmgQUF+mf9bMr7GGFu25VriM5/fqJkMygjA95
xI0lKPoaPKVlHTNnZSxi/+b10vNCD5/8r+OU3keoSeOQ59UwPLpPJBwHvMB58cEh
7MZ3irpQwZfQajkD7nB7351tXekxy4MimHOPwWSoem9BhFwzxzRSlcIKwgWR0Dyi
Khmjqn5sG4GDvWTy/f1Cmuubsr5giWOsnjGtIGTfMwLHXGx7rOgYnSPbShnGNJzN
NDDf2v+BfNIHEuPTSeh3M86pd7NR/rTjB8ZuhhvGfk0IaU6R4j21wTeV1w5cWT1n
UpBKH7jJmwot/Qss4QIVaDhmFOqzgRfqumGirJbhEMqQp/L9SaKLWnE/GtSkXXSJ
Ov8ACjmuR6/sqQEJ/zos7f5lhEKGxBzfgeDFT5mVwCpyAUMnOrXWlvsTWpbi+RiV
kwQ960ok6/SIE4Qw3KFQsCjR0/S9wM00rT2PfAGUJN2czpMDf157Ip3thk4tg2/0
K59x4FJt1Or1GGJdi0+sNLH3zgoqwGNIDhPt8IsC7yMG35/CZDD7NzRqpud9Y64k
Wf/71D5PPuyFe8NpKj4c
=2MVV
-----END PGP SIGNATURE-----

--Sig_/k2AhhoIPntp+aTxsAG=dZk/--
