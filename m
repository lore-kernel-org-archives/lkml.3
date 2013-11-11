Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3KKFZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:25:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39693 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3KKFZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:25:34 -0500
Date: Mon, 11 Nov 2013 16:25:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the userns tree
Message-Id: <20131111162518.bdf27fe160af288ce8ea1bf2@canb.auug.org.au>
In-Reply-To: <87r4aqscxm.fsf@xmission.com>
References: <20131108180759.12dab53816900b1b58c1ea1b@canb.auug.org.au>
	<87r4aqscxm.fsf@xmission.com>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Nov_2013_16_25_18_+1100_cp+wVpDrLaaZXw9j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Nov_2013_16_25_18_+1100_cp+wVpDrLaaZXw9j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Fri, 08 Nov 2013 15:15:17 -0800 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>=20
> > After merging the userns tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > fs/namespace.c: In function 'detach_mounts':
> > fs/namespace.c:1340:2: error: implicit declaration of function 'br_writ=
e_lock' [-Werror=3Dimplicit-function-declaration]
> >   br_write_lock(&vfsmount_lock);
> >   ^
> > fs/namespace.c:1340:17: error: 'vfsmount_lock' undeclared (first use in=
 this function)
> >   br_write_lock(&vfsmount_lock);
> >                  ^
> > fs/namespace.c:1340:17: note: each undeclared identifier is reported on=
ly once for each function it appears in
> > fs/namespace.c:1345:2: error: implicit declaration of function 'br_writ=
e_unlock' [-Werror=3Dimplicit-function-declaration]
> >   br_write_unlock(&vfsmount_lock);
> >   ^
> >
> > Caused by the interaction between commit d7e58b8abc4f ("vfs: Add a
> > function to lazily unmount all mounts from any dentry. v3") from the
> > userns tree and commit 84550b9356af ("RCU'd vfsmounts") from the vfs tr=
ee.
> >
> > I don't know how to fix this up, so I have just dropped the userns tree
> > for today.  I only dropped that tree because it was the latter of the t=
wo
> > conflicting trees.
>=20
> Yeah.  Al has somethng cooking where he renamed the lock.
>=20
> It looks like this just needs the trivial change:
> s/br_write_lock(&vfsmount_lock)/lock_mount_hash()/
> s/br_write_unlock(&vfsmount_lock)/unlock_mount_hash()/
>=20
> Certainly that is all it needed when I closely inspected an earlier
> version of Al's changes.  He changed the name of the lock and I just
> happen to be using it.  In this case I don't think any of the semantics
> have changed.

OK, I added that as a merge fixup patch today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Nov_2013_16_25_18_+1100_cp+wVpDrLaaZXw9j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSgGpEAAoJEMDTa8Ir7ZwVFd0P/RUWVnkQyK+cU018lZkrNB4F
t8WZQwf4qo6Zhk0dqOSHAv9h5Zw+WWpdoEvR3cQ/hVGjCAJjVehRQOzei9jjsrP8
lSpXpznBHFzNiDnM83gEQWQ7KRCRmTXN6le5OOxML7CUVZji9PvS70eHxc39viIE
ZsXxw/OyWoh7RLgpy19TO/hFsQu543gsh5dEQegqtpQKHtZU2wF5wKxGM4sdvVqx
hUf62OHoLxMx0uBhazqzPImvHgWGgIOwcgIj444hioP+UdIxm498hjBpcWA9J1qd
/Cv5ZPviPtpkhbHLL/GCY7rQkA6tNF9cIsS2+wdOoDAh5np04fa85tY5AZll8kYo
joib7cFuSE4DhUqyanUSQIiV8oFqH6TXvDWnmlo9XYq+SXhfW4ZT1NI8lTPi1Rps
CxhzQj+4SXYvz5Ia0Kbx9wjS8qEDm/M3IzFjx8WgyOp4EnPg+cTvB6Pxsws/1VbM
1O+KiMeZ1cADzLaE0JeOGoeYdFjRyNslBOOXoFDKkTPaI8mCadF8w6G149GM0w23
qABzpML4dXPv7pm0uXCCAFarxSJRc++EIqUrW9AQLO6UlbKC3h1DC3gsQB5calH2
uS/1xjsElFwCPIabLtgqSHkJjAi1SI78oaVqoKhB3DG1Y2XiUnSn6+g3XmRIAZZJ
rIVzyK3czdSn7U8KZGQI
=dZtA
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Nov_2013_16_25_18_+1100_cp+wVpDrLaaZXw9j--
