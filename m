Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaLEI3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:29:36 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:58210 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaLEI3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:29:34 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jeremiah Mahler <jmmahler@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: linux-next: Tree for Dec 4
In-Reply-To: <20141205005401.GA1279@hudson.localdomain>
References: <20141204195928.4a5b93f4@canb.auug.org.au> <20141204233411.GA1223@hudson.localdomain> <20141205005401.GA1279@hudson.localdomain>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 05 Dec 2014 11:29:03 +0300
Message-ID: <87sigu5wkw.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jeremiah Mahler <jmmahler@gmail.com> writes:

> all,
>
> On Thu, Dec 04, 2014 at 03:34:11PM -0800, Jeremiah Mahler wrote:
>> all,
>>=20
>> On Thu, Dec 04, 2014 at 07:59:28PM +1100, Stephen Rothwell wrote:
>> > Hi all,
>> >=20
>> > Changes since 20141203:
>> >=20
> [...]
>> >=20
>> > --=20
>> > Cheers,
>> > Stephen Rothwell                    sfr@canb.auug.org.au
>> >=20
>> [...]
>>=20
>> linux-next 20141204 is broken on all my machines, 20141203 worked fine.
>>=20
>> They fail very early in the boot process and are unable to mount root.
>> There are lots of "ext4_check_descriptors: Checksum for group ...
>> failed" messages.
>>=20
>> Any suggestions for where to start looking?
>>=20
>> --=20
>> - Jeremiah Mahler
>
> I ran a bisect and found this patch to be faulty.
>
>   commit fdfe073987619ec375da8d8a2701ab271d1b1339
>   Author: Dmitry Monakhov <dmonakhov@openvz.org>
>   Date:   Tue Dec 2 16:09:16 2014 -0500
>=20=20=20
>       ext4: fix potential use after free during resize
>=20=20=20=20=20=20=20
>       We need some sort of synchronization while updating ->s_group_desc
>       because there are a lot of users which can access old ->s_group_desc
>       array after it was released.
>=20=20=20=20=20=20=20
>       Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
>       Signed-off-by: Theodore Ts'o <tytso@mit.edu>
+       rcu_read_lock();
+       gd_bh =3D *rcu_dereference(sbi->s_group_desc) + group_desc;
+       rcu_read_unlock();=20
Yes this is true crap. The only question is how it passed xfstess?

>
> --=20
> - Jeremiah Mahler

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUgWzQAAoJELhyPTmIL6kBkZYH/3BC7NzklZf/bqYf0lkPQdMp
9q8aY7ME5jTVFPopWTdgbMVOzWrFrDEedOjevnLDFSobjm2spM2OoWxXvyHGYhO4
4OBS//n8/CIubZuRTQzPQ8pmcRtDiW8F/NacbRzAH/KGe7h0221pU1pO0rLAyfih
KjCGd+P8/qzrwiPr4amB0zTZtDFHiCJWbtrPkPNJ+zvvJEcSPzUqX+d9Rwm5N1zG
zJEE0JdTryCY+hT0CIfKA1NiNFU5Q+woIR9IgEx4mj6uIpdSS9aD3pLxwtZTyVcf
2/PDTdqpqVOpJI7bA8zjRb1rAVfiRMhDyVFKjOZfU6CTQjkUqTy9mUlQe4FbPlU=
=Vf97
-----END PGP SIGNATURE-----
--=-=-=--
