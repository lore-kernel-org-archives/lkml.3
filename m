Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521AbaGPGKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:10:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36915 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbaGPGKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:10:12 -0400
Date: Wed, 16 Jul 2014 16:10:03 +1000
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] autofs4: don't take spinlock when not needed in
 autofs4_lookup_expiring
Message-ID: <20140716161003.48abe8c1@notabene.brown>
In-Reply-To: <1405482132.2527.26.camel@perseus.fritz.box>
References: <20140709233541.4525.25151.stgit@notabene.brown>
	<20140709234114.4525.70534.stgit@notabene.brown>
	<1405482132.2527.26.camel@perseus.fritz.box>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/GzHX+fqAmHWt4OZX2HMlMH6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/GzHX+fqAmHWt4OZX2HMlMH6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jul 2014 11:42:12 +0800 Ian Kent <raven@themaw.net> wrote:

> On Thu, 2014-07-10 at 09:41 +1000, NeilBrown wrote:
> > If the expiring_list is empty, we can avoid a costly spinlock
> > in the rcu-walk path through authfs4_d_manage.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> I know it should be straight forward to say this is OK but I always
> think twice and again about areas that are subject to race pressure,
> such as the expire to mount pressure of this code.
>=20
> After thinking about it for a while now I don't have any reason to think
> this would be a problem. Perhaps later pressure testing will reveal
> something I missed.
>=20
> It occurs to me that autofs4_lookup_active() might benefit from a
> similar addition. Multiple calls to ->lookup() made while the dentry is
> still unhashed should have enforced ordering due to the directory
> i_mutex so there shouldn't be a problem adding this. But perhaps you
> haven't seen delays in that function.

Yes I think the same optimisation could apply to autofs4_lookup_active().  =
It
wouldn't benefit as much though.
autofs4_lookup_active() is only called from autofs4_lookup() which is only
called when the dentry doesn't already exist.  So it isn't called so often
and isn't on the fast path.

However ... maybe "is on the active list" is exactly the "flag" I was wanti=
ng
earlier to see if a dentry might be waiting to be mounted on - in which case
d_managed already does the right thing.
I think it is time to read through the code again.  I seem to be
understanding more of it which always helps:-)

Thanks,
NeilBrown


>=20
> Acked-by: Ian Kent <raven@themaw.net>
>=20
> > ---
> >  fs/autofs4/root.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> > index 1ad119407e2f..774c2dab331b 100644
> > --- a/fs/autofs4/root.c
> > +++ b/fs/autofs4/root.c
> > @@ -219,6 +219,8 @@ static struct dentry *autofs4_lookup_expiring(struc=
t dentry *dentry,
> >  	const unsigned char *str =3D name->name;
> >  	struct list_head *p, *head;
> > =20
> > +	if (list_empty(&sbi->expiring_list))
> > +		return NULL;
> >  	spin_lock(&sbi->lookup_lock);
> >  	head =3D &sbi->expiring_list;
> >  	list_for_each(p, head) {
> >=20
> >=20
>=20


--Sig_/GzHX+fqAmHWt4OZX2HMlMH6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU8YXOznsnt1WYoG5AQKycw/+JY2QqMUx0l995/CINJ66+LRlLNR7gIXP
B+L+SMWUdVGNGDYc9G4Q1PCQLsVhoGF4s1bOIbqM+2RSQXITm2nxcKqjrEgd9fCT
8cte+RhXV2moHDdrVWSkE7zSikbZXzc7B7kaMHtSGc4BCKhKR0xXdDyBfOPmpTBj
5fxT8DZStnHIviW8v1jrG1s06tFozNcUVxde4twqMJbsFzLeVG6UIMH3rplsEbMa
WjmKNkPSgAkNa/MaF6Sbr3wK22lulK+AgU192yhD1MSBINZ7eBFXnaz4vr0UUYkd
jY7W0aRsJNcf6HmGPzCfTh1QXdBMiRFFTwd1SWtnkcpQVIcYfqIt0euDEUMaOHlx
EEi7colFdLJ2yc6962Za5eo/l8GBnDVeuC00d20GIqws6TKbMXt9MNNF6pjSqGYE
3E68Oyci9IeT5sXckZedMh/+Rq19+D3JjAE/rHNzGD9Me9puJy4A80sjxpDApWoS
yKnxipQNpPdSgCD3NxyYctAnk5sEYm1z5RtoNI7HdZ7XvmZL0n180uU1pgTLgpVc
pwh9Jdqa9Gy6etEkAeyDcVvOwJ1YkAuBFqCtX34EjPJeTUtOjlcTkWLA0HxN4Zpj
33X8wzE1mOfpSVIrYdF51Za8X/98xsEAtKZPIbBOjXhDOp9D55+aBgHdhogy+P7q
yUM67arAorA=
=fuaS
-----END PGP SIGNATURE-----

--Sig_/GzHX+fqAmHWt4OZX2HMlMH6--
