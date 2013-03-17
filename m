Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab3CQCPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 22:15:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53127 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab3CQCPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 22:15:07 -0400
Message-ID: <1363486492.3937.238.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] hw_random: free rng_buffer at module exit
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aurelien Jarno <aurelien@aurel32.net>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Sun, 17 Mar 2013 02:14:52 +0000
In-Reply-To: <87d2v1tfr0.fsf@rustcorp.com.au>
References: <20130312223211.492954675@linuxfoundation.org>
	 <20130312223212.790278686@linuxfoundation.org>
	 <874ngeykp6.wl%satoru.takeuchi@gmail.com> <87txoetre6.fsf@rustcorp.com.au>
	 <87k3pagllu.wl%satoru.takeuchi@gmail.com> <87d2v1tfr0.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o0xneHHjTjCluw23MPZ+"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o0xneHHjTjCluw23MPZ+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-15 at 15:35 +1030, Rusty Russell wrote:
> Satoru Takeuchi <satoru.takeuchi@gmail.com> writes:
> > At Thu, 14 Mar 2013 17:11:21 +1030,
> > Rusty Russell wrote:
> >>=20
> >> Satoru Takeuchi <satoru.takeuchi@gmail.com> writes:
> >> > Hi Rusty,
> >> >
> >> > At Tue, 12 Mar 2013 15:43:33 -0700,
> >> > Greg Kroah-Hartman wrote:
> >> >> @@ -307,6 +312,14 @@ int hwrng_register(struct hwrng *rng)
> >> >> =20
> >> >>  	mutex_lock(&rng_mutex);
> >> >> =20
> >> >> +	/* kmalloc makes this safe for virt_to_page() in virtio_rng.c */
> >> >> +	err =3D -ENOMEM;
> >> >> +	if (!rng_buffer) {
> >> >> +		rng_buffer =3D kmalloc(rng_buffer_size(), GFP_KERNEL);
> >> >
> >> > rng_buffer is now kmalloc-ed, but not kfree-ed. Shoudn't it be kfree=
-ed
> >> > at hwrng_unregister()? If my suspect is correct, the same problem is
> >> > in 3.8.3-rc1 and 3.0.69-rc1. I'm OK to make a patch, but it'll be af=
ter
> >> > some hours.
> >> >
> >> > Corecct me if I'm wrong.
> >>=20
> >> Yes, it would be nice to free it, but it really makes sense to free it
> >> in module_cleanup() (which would have to be written, as the module
> >> currently doesn't have one).
> >>=20
> >> Cheers,
> >> Rusty.
> >
> > From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> >
> > rng-core module allocates rng_buffer by kmalloc() since commit
> > f7f154f1246ccc5a0a7e9ce50932627d60a0c878. But this buffer won't be
> > freed and there is a memory leak possibility at module exit.
> >
> > Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Matt Mackall <mpm@selenic.com>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Aurelien Jarno <aurelien@aurel32.net>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: stable@vger.kernel.org
>=20
> Cc: stable might be overkill, but I've tested it and put it in my patch
> queue, and will push it to Linus once it's survived linux-next.

If the module cannot be removed currently, it does not leak.  Making it
removable is a feature addition and I think you're right that it's not
suitable for stable.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-o0xneHHjTjCluw23MPZ+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUUnHOe/yOyVhhEJAQpERhAAqgbY9LTd1inmy27ekGO+2+8dw27YV+Y5
VhObqdqVXcjTY1K2V+eCTZqHR3+wjTKSBbqpH9J4kSW8C2apAiGSA6DPsmGramxS
DWhf2BBQba6ryczVNysbRUvUkqm2tABc2Tqexc7t+gO4nHYkzVzhDdBka5EEICXK
umSgNQFryZcxgf86Twpr53uDbGZn7iI9AV7rzf3hfH9M4eTcn5C0vQa5wNav84wE
rn+R72YPmdJQxMmoP1VD2VX3czXNP4OKQW4ByqarFRz/f7no6hw5/lvqhD4QTFRb
zbs8VahKahFNw1lowY2ylSWgq6jLntY0FsRtENjcowuccLGaVhrlMm09ddUodD0Z
0L+ORsIci7+7R1bml+Y9yDW1nxQX13GiUgEdboBXYu49VIFKcaIObZ2Wg16Nqhc+
2IYZ4Z19S/SMHV9Tn7kvxMUSz98ivc128cgyEkKl3mATF7f/Q88LcL3xUCJWsXFe
WUziH8MZTLxtEZqWWy7CGGo2crK3Ey8ucCLbF0Bw/ItZObImJqp3mQec36YF6h2W
9BH2eG3UDijCJw3AmtnrH43kr3lDKGIrL3UWSUwYhpI/hsdHayqm/AnyYixTkOG+
GZ41VjUVa2hjCHyLByuqsNHYV7UJFYoWE0WZQtPPMM5FrIX1z+7YuEH7bf/hRb9L
RnLG4I2+QUY=
=JLt7
-----END PGP SIGNATURE-----

--=-o0xneHHjTjCluw23MPZ+--
