Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaIPAcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:32:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbaIPAcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:32:16 -0400
Date: Tue, 16 Sep 2014 08:30:31 +0800
From: Amos Kong <akong@redhat.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        herbert@gondor.apana.org.au, mpm@selenic.com, rusty@rustcorp.com.au,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] virtio-rng cleanup: move some code out of mutex
 protection
Message-ID: <20140916003031.GB5671@zen>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
 <1410796949-2221-2-git-send-email-akong@redhat.com>
 <20140915181320.28f642d6@wiggum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <20140915181320.28f642d6@wiggum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2014 at 06:13:20PM +0200, Michael B=FCsch wrote:
> On Tue, 16 Sep 2014 00:02:27 +0800
> Amos Kong <akong@redhat.com> wrote:
>=20
> > It doesn't save too much cpu time as expected, just a cleanup.
> >=20
> > Signed-off-by: Amos Kong <akong@redhat.com>
> > ---
> >  drivers/char/hw_random/core.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/cor=
e.c
> > index aa30a25..c591d7e 100644
> > --- a/drivers/char/hw_random/core.c
> > +++ b/drivers/char/hw_random/core.c
> > @@ -270,8 +270,8 @@ static ssize_t hwrng_attr_current_show(struct devic=
e *dev,
> >  		return -ERESTARTSYS;
> >  	if (current_rng)
> >  		name =3D current_rng->name;
> > -	ret =3D snprintf(buf, PAGE_SIZE, "%s\n", name);
> >  	mutex_unlock(&rng_mutex);
> > +	ret =3D snprintf(buf, PAGE_SIZE, "%s\n", name);
>=20
> I'm not sure this is safe.
> Name is just a pointer.
> What if the hwrng gets unregistered after unlock and just before the snpr=
intf?

Oh, it points to protected current_rng->name, I will drop this
cleanup. Thanks.
=20
> >  	return ret;
> >  }
> > @@ -284,19 +284,19 @@ static ssize_t hwrng_attr_available_show(struct d=
evice *dev,
> >  	ssize_t ret =3D 0;
> >  	struct hwrng *rng;
> > =20
> > +	buf[0] =3D '\0';
> >  	err =3D mutex_lock_interruptible(&rng_mutex);
> >  	if (err)
> >  		return -ERESTARTSYS;
> > -	buf[0] =3D '\0';
> >  	list_for_each_entry(rng, &rng_list, list) {
> >  		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
> >  		ret +=3D strlen(rng->name);
> >  		strncat(buf, " ", PAGE_SIZE - ret - 1);
> >  		ret++;
> >  	}
> > +	mutex_unlock(&rng_mutex);
> >  	strncat(buf, "\n", PAGE_SIZE - ret - 1);
> >  	ret++;
> > -	mutex_unlock(&rng_mutex);
> > =20
> >  	return ret;
> >  }
>=20
> This looks ok.
>=20
> --=20
> Michael

--=20
			Amos.

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUF4SnAAoJELxSv6I5vP9jzHMQAJxY4AWJytK6Trofz2Jmna3L
SHyftIR/Rg6ZZi1uHuIQDnJTyeN7SR9nycVpK/YUfGX7/xJKMGOxFF2zkchfjOPJ
pCbpvyqr50hbRE+C/JTTagqKyQdjpChV7/zzJUXwJ9uuJ1B9/M0ps8878QSNU8Aa
MoKEKd0ZAUIrL1Sw8EmTMvGk6xQOScnFnBEOIA2WJd5TbzT0b5SHP9Vbk+oPBnLa
3mS1A4YcU9qGJvVm0OD4UdrgCZHu6VkBfWFzguqC5ZK8lWEtbE7IL83P4yS1LzbP
/YfsZw1kVKupatTf7OKh6oSe0dxH7tum6fBmu3EFuxFYBf+SFYafLdHs6bNPEoyI
HTt3qil4LOHw+OU9+r3F8jwaVxn1aKTx3cqHhphefOxABWo6qv9omSX62N3wpn0b
tict/1zSB7FtVPEed61yuHEB5I1bOaAktpqVfPM/MTNhtrSoCMt0HHvJKI6ALLpP
n4Tg3L/lxX3YlQ/Vru4VbanSXbxizxQeuHVbMgx+I9u6qBdBHpGBcJklf56GEHtn
2hHY4hQabNpyUioW06W0DwYHK4a2HFblDPkw/2IogEnru4DkKhvaDRP6AtbtvwnD
8yD2hyPT1pbguEc3Kjk3vcXiyAVwbC/D+K2uznhNF/uAYbkdFlSsRQ0dvxvLXJHf
TG7rl6ReyUF9iMacjGqS
=n9X0
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
