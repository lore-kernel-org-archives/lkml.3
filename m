Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaJTXyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 19:54:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49003 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbaJTXyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 19:54:15 -0400
Date: Mon, 20 Oct 2014 19:54:14 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] binfmt_misc: add comments & debug logs
Message-ID: <20141020235414.GA23349@vapier>
References: <1413759826-11958-1-git-send-email-vapier@gentoo.org>
 <1413845160-22497-1-git-send-email-vapier@gentoo.org>
 <1413845996.5407.2.camel@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1413845996.5407.2.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20 Oct 2014 15:59, Joe Perches wrote:
> On Mon, 2014-10-20 at 18:45 -0400, Mike Frysinger wrote:
> > diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> []
> > @@ -323,46 +343,113 @@ static Node *create_entry(const char __user *buf=
fer, size_t count)
> []
> > +			if (e->mask) {
> > +				int i;
> > +				char *masked =3D kmalloc(e->size, GFP_USER);
>=20
> Why GFP_USER?  Does it need it?

mostly a copy & paste from earlier in this func:
	e =3D kmalloc(memsize, GFP_USER);

the code is running process context and this buffer is only for
debugging on behalf of the user (and is shortly freed there after), so
GFP_USER seemed appropriate.  that said, i'm certainly not an expert
here, so if the convention is to use GFP_KERNEL, it's easy enough to
change.  the kmalloc API doesn't seem to provide guidance.

> >  	switch (res) {
> > -		case 1: clear_bit(Enabled, &e->flags);
> > +		case 1:
> > +			/* Disable this handler. */
> > +			clear_bit(Enabled, &e->flags);
> >  			break;
> > -		case 2: set_bit(Enabled, &e->flags);
> > +		case 2:
> > +			/* Enable this handler. */
> > +			set_bit(Enabled, &e->flags);
> >  			break;
> > -		case 3: root =3D dget(file->f_path.dentry->d_sb->s_root);
> > +		case 3:
> > +			/* Delete this handler. */
> > +			root =3D dget(file->f_path.dentry->d_sb->s_root);
> >  			mutex_lock(&root->d_inode->i_mutex);
> > =20
> >  			kill_node(e);
>=20
> Maybe move the case indents one tab position left

style fixes (for the whole file) are in the 2nd patch.  i specifically
tried to keep those changes to a minimum in this patch (functionality
vs formatting).
-mike

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJURaCmAAoJEEFjO5/oN/WBMVQP/1g7L43ZN8WApt7DnCD9ZPOW
Vf7cNe2cw55EarINZeUAPa6HDRYt4huo+lgNzQKkaKpPpNroyabrDwslHWIVBDYb
zk503Lkq5r8o99XPy1QAhGhqzfGWULS21b1n9JnS6ms6waB29p5hXpPI1I9MWQGn
bgun22BvuHpnk3YYLBhLZGdx4P9m34AIc0vmnppnSLI0o04bScjNdcE1kLOyHqVJ
bNI3+iidPj+moU2ULzIUrKAPTjcyAk8pklIOpndjLZrgsh9AHd8FnN+e7GJQlpCd
cZ+Ec7+KFyiNYvEm7YjhTfAC3/Q0Zrcc+X3XnKNprCfib02VdcOjD5I4mosH0v1f
YS75Eqek0MwfT0KIgiKF03/NwsGpKDuPdGVTOeofltwM5LfrxXsSSVowA1tMPrBi
WjIPhCwkduUEyZjdTXCLXqcLdj9rH+cuxHAL3qw/d0o3k63uoZWsBbI1m14Q+OJz
k62HyU2vs0FExqYP70qxhibpgmjpvj88qHNp4ltRtrVYv6obL8mykH4rmD39OAGa
TCDAAPcGEJTKj3X/3XPi3n0FZUZFNQHaHdn0iQkmKWExb3xWIbjSb9Y3ZcjAOnmh
SDLHzkqfGSxhJSfgAfgviHyHGP6bVn+K8hGjPLE+3wXsErUnoUohvkbXWoZdsUQZ
8naWR9SlVbwqpjELWjuj
=yDnw
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
