Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965866AbaFSW7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:59:41 -0400
Received: from ozlabs.org ([103.22.144.67]:55335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958AbaFSW7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:59:40 -0400
Date: Fri, 20 Jun 2014 08:59:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Message-ID: <20140620085931.6427678d@canb.auug.org.au>
In-Reply-To: <3494783.s5KPIUO972@sifl>
References: <20140618084046.1bce12cc@canb.auug.org.au>
	<1446656.4HCLD295vV@sifl>
	<20140620010837.692e5472@canb.auug.org.au>
	<3494783.s5KPIUO972@sifl>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/V6HksuFMCbdmoS87h+.cZKl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/V6HksuFMCbdmoS87h+.cZKl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Thu, 19 Jun 2014 15:47:01 -0400 Paul Moore <paul@paul-moore.com> wrote:
>
> I want to avoid use a -rcX release as the foundation of any of my trees; =
the -
> rc releases aren't as stable and it goes against what we're trying to do =
with=20
> the different Linux Security trees.  Unfortunately, based on what I've re=
ad=20
> above, this seems to be incompatible with linux-next.

The problem with basing your development for v3.17 on v3.15 is that
you  do not take into account any of the changes done by others during
v3.16-rc1 (or even your upstream tree) some of which may be core API
changes.

> While I hate to split my development branch from the #next branch, it see=
ms=20

I don't want that either ...

> like that is the only way to accomplish both a reasonably current and sta=
ble=20
> development tree and get the patches into linux-next.  Unless you, or any=
one=20
> else for that matter, has a different suggestion I'm going to go ahead an=
d=20
> turn the current SELinux #next branch into a development branch and creat=
e a=20
> new #next branch that will be based on the most current -rc1, this new #n=
ext=20
> branch will be created new for each major release.  Not exactly what I wa=
s=20
> hoping for, but will that work?

Do you mean that your #next branch will just be a merge of -rc1 and
your development branch?  That would not actually change anything
(except that you would possibly take care of some conflicts for me).

At the core, what is in linux-next should just be exactly what will be
merged by your upstream.  My real point here is that that is not what
has happened recently.  The patches in your tree have been
cherry-picked or rebased into James' or Serge's trees, not merged so we
now have duplication.  This is what you need to solve with James and
Serge.  linux-next is a side issue - I can cope with a lot.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/V6HksuFMCbdmoS87h+.cZKl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTo2tYAAoJEMDTa8Ir7ZwVvBsP/iaD9clMzjw3fSpeR5i0vYif
/lDeX/46lqyEJcn/qYeax5Murc/+oXgwllhyNpjkaCZsDMZzUhlBmR4KiZvNx36G
dkyOacmOGMJP2rWEaRS5qXWuW2A1tBFlhmYiGkjb8HqBOfT+r0faonxivXNymLD6
vfcV48cVb9rXa+IhmXlXF1GTmkJVJVHPWcEoKqsaP+12wZKeb3NoMYs8tVSR1KPg
3TUhv+k62idy66qKRNlbQvlOdGfZegQj+FO65qo+9DVc42C69qYf+gkAeEi6eKBw
RahS6V3rJEMeSS5YNKwInuJ9kaToJB9dlM3Wj2OT674pmMi4bk4XfyHzVLm6eXW0
FXFO9wwYF4kjSQMvfwp7WxeT1VnChaz/IeTcEd4x5Tl7v/MHCJuACHh8aP3VJ+pW
a02MlVCk8uw4eENI9BwkKUvFzJ+N9rrSpzTt0vYF96SbHZCva+sBI+wo5HboivXG
rRSmG0IfRGBuYUlmsOsRh8rHPBUGbDtNlUGfj21qH+rHivvacafn2VtkD+uva52R
teZhoA7dC/Jnwkc60rphAo+LLjCqmtKdjKmCslxhr8S0mCv/S1mvoxbS4bkpCYzd
LnKpwYKl9Iv86iKwUH3WePOFKqSxpV8wJljrFYssYCJuLTFZ+/OoDyRzAnVz+AIV
4fos8y7Uh+OoHrsmhNp3
=ApKi
-----END PGP SIGNATURE-----

--Sig_/V6HksuFMCbdmoS87h+.cZKl--
