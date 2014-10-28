Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaJ1XZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:25:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44858 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbaJ1XZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:25:45 -0400
Date: Tue, 28 Oct 2014 19:25:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] binfmt_misc: add comments & debug logs
Message-ID: <20141028232543.GA7743@vapier.wh0rd.info>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
References: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
 <1413845160-22497-1-git-send-email-vapier@gentoo.org>
 <1413845996.5407.2.camel@perches.com>
 <20141020235414.GA23349@vapier>
 <20141028155853.8327ad332397c5b426e0aa46@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20141028155853.8327ad332397c5b426e0aa46@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28 Oct 2014 15:58, Andrew Morton wrote:
> On Mon, 20 Oct 2014 19:54:14 -0400 Mike Frysinger wrote:
> > On 20 Oct 2014 15:59, Joe Perches wrote:
> > > On Mon, 2014-10-20 at 18:45 -0400, Mike Frysinger wrote:
> > > > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> > > []
> > > > @@ -323,46 +343,113 @@ static Node *create_entry(const char __user =
*buffer, size_t count)
> > > []
> > > > +			if (e->mask) {
> > > > +				int i;
> > > > +				char *masked =3D kmalloc(e->size, GFP_USER);
> > >=20
> > > Why GFP_USER?  Does it need it?
> >=20
> > mostly a copy & paste from earlier in this func:
> > 	e =3D kmalloc(memsize, GFP_USER);
> >=20
> > the code is running process context and this buffer is only for
> > debugging on behalf of the user (and is shortly freed there after), so
> > GFP_USER seemed appropriate.  that said, i'm certainly not an expert
> > here, so if the convention is to use GFP_KERNEL, it's easy enough to
> > change.  the kmalloc API doesn't seem to provide guidance.
>=20
> I can't see any reason to me using GFP_USER for these objects so how
> about
>=20
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: fs/binfmt_misc.c: use GFP_KERNEL instead of GFP_USER
>=20
> GFP_USER means "honour cpuset nodes-allowed beancounting".  These are
> regular old kernel objects and there seems no reason to give them this
> treatment.

tracing the source bits showed that as the only difference i could fine, bu=
t as=20
to what they actually impacts, i'm not sure :).  i don't think it's super=
=20
critical though considering only root users can update this, so it's hard t=
o see=20
how it'd be abused.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUCX3AAoJEEFjO5/oN/WBTy8P/1j7RmJ9tN1md2sNbXFg+kO6
HdivmhlNX7aRtyWtlK02T2jS0brPg6Cx9CGjZl0pJ10KfKC1oxNj5j+8ltx41L/f
2AzTGemPG55s6JTNjAZdEowfUR3xzz+weuicd1NJnpi/8KpI7LeajCLFUeyDbe4T
zK03qNHDy7Ca7O2zxa6DLUF+ABL7yblEvCre7EIU3ibHitCF+A6a8izYmZFVO9Z1
zHuCDK6TX8CwTUDlHvPCX6jFAWK0jaCOyBjbu7tfNxz7fxMczJgc90Od4pSEp6Xo
BVzXJxLtryfYcKS2q2lsPAxaC2Fi7Bf1a8a2GDZdKGciTddcPwlPQK7sjvqndiu3
97Rdai8bdTgKFYCqpEfDTDpCtZTy0rLtp29HApzevauACc23iUIDEdQzdQgbMb0q
nxDzMeAMlWjwhzv1G+m5IbXsdhFhm6vOAWALUNuYbwmWp2MhhsILDBpZPLg4uKW+
xSJoE4WXVGvIS/qNSOsYAPDDthtimQlL3qKxOZuYqssOgPT5vBTjg9MFbFCAy/To
ckTHSxhuYXoZedkjFIuhAeVVuhPL9w0svjBda+Tk5n9e4g9zk1BeP8+AFLmy+DUn
SLL5vfsH+kXvzpz3BFFlWbIWrkwYg9HFMDMuCz88mjrUYN8B/UEDXE8z7Tgp+4t9
j2bZDz6b6sx8qmRaN49H
=VjLn
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
