Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3LaTyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:54:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38242 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485Ab3LaTyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:54:06 -0500
Message-ID: <52C320D1.3040509@gentoo.org>
Date: Tue, 31 Dec 2013 14:53:53 -0500
From: Richard Yao <ryao@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dominique Martinet <dominique.martinet@cea.fr>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "v9fs-developer@lists.sourceforge.net" 
	<v9fs-developer@lists.sourceforge.net>,
        "kernel@gentoo.org" <kernel@gentoo.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: v9fs does not honor open file handles on anonymous files
References: <52C31927.40304@gentoo.org> <20131231194110.GA28209@nautica>
In-Reply-To: <20131231194110.GA28209@nautica>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="5XE05GvkCTmNGP229nNLe7EETKeb1SsnS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5XE05GvkCTmNGP229nNLe7EETKeb1SsnS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/31/2013 02:41 PM, Dominique Martinet wrote:
> Hi,

Thanks for the fast reply.

> Richard Yao wrote on Tue, Dec 31, 2013 :
>> #!/bin/bash
>> cat <<-EOF
>> EOF
>>
>> Running this causes bash to fork via clone(), set fd=3D0 to point to a=
n
>> empty file in /tmp, unlink it and then execve cat. Specifically,
>> something like this;
>>
>> [pid  3699] open("/tmp/sh-thd-1388524249",
>> O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) =3D 3
>> [pid  3699] open("/tmp/sh-thd-1388524249", O_RDONLY) =3D 4
>> [pid  3699] close(3)                    =3D 0
>> [pid  3699] unlink("/tmp/sh-thd-1388524249") =3D 0
>> [pid  3699] dup2(4, 0)                  =3D 0
>> [pid  3699] close(4)                    =3D 0
>> [pid  3699] execve("/bin/cat", ["cat"], [/* 22 vars */]) =3D 0
>>
>> It seems that v9fs_vfs_unlink() is killing the file while we still hav=
e
>> open file handles. I have confirmed that this behavior occurs on Linux=

>> 3.13.0-rc6. This breaks several things when Gentoo is on a 9p rootfs
>> (e.g. gcc-config, any emerge command that involves a C compiler,
>> etcetera) inside QEMU. I have placed /tmp and /var/tmp/portage on a
>> tmpfs as a hack-fix, but it would be better to get this fixed.
>>
>> I doubt that I will write a patch to fix this. I am sending the detail=
s
>> to the list so the 9p maintainers or any other interested individual c=
an
>> fix it.
>=20
> I'm not sure if it is the client's job to remember the file has been
> unlinked and only really unlink it after all the file handles are close=
d
> or if we should expect the server to do it.

The answer to this is largely philosophical in nature, but it is a good
question to ask. Quite honestly, I have no preference, but I was not
sure who was responsible. Having caught another bug that I thought was
in QEMU that turned out to be in Linux, I decided to ping the Linux
folks first this time.

Speaking of which, that patch did not get much attention because I did
not send it to the right lists. I will resend it soon:

http://www.spinics.net/lists/linux-virtualization/msg21716.html

> It might not matter in the case of qemu acting as a 9p server, but ther=
e
> are a couple of network 9p2000.L servers out there (diod[1] and
> nfs-ganesha[2]), and if the file is open on one client and unlinked on
> another client.. How can the second client wait properly?
>=20
> For what's it's worth, nfs-ganesha already behaves properly and this
> will work with /tmp being a 9P mount off it.
>=20
>=20
> It might be worth looking into qemu's code and see if it wouldn't be
> easy to hold the unlink ? I've got to admit I honestly have no clue
> there.
> (or at least send them a copy of your mail :))


If nfs-ganesha handles this properly, then I am going to say this is
QEMU's bug. I had CCed Aneesh, who I am told is responsible for the QEMU
9p code, so hopefully we will hear from him soon. Otherwise, I will
resend to the QEMU list.

>=20
> [1] diod "Distributed I/O daemon" - http://code.google.com/p/diod/
> [2] nfs-ganesha - https://github.com/nfs-ganesha/nfs-ganesha
>=20
>=20
> Cheers,
>=20


--5XE05GvkCTmNGP229nNLe7EETKeb1SsnS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSwyDVAAoJECDuEZm+6ExkXZcP/2n8Vg4A28MJ8m9bT2C/7yGn
sUKoZvlriUe3pcXzbRpw2kqE2RGxwboAK6BwZb24t9sfYYMtbOnju2ruVfedWWi2
cLl11JbkgzOiPK5XMJ6Se1apR3Mj5DEOTuWVWUFuMjmvsnSnIQBEpCK/W3pkttTb
51el4baWpaq5wX4/4u6ngFXwLyqaOgIB9uoVTuDFcShtuqjL5P5bEoVtHq/lsW4c
hSLD/Ykk7cyyNX6YVF/i33RzCLDQ+wShYVe8CO9uKAC2ZcoyQydZlYlppmiS9hBm
PBrpjgksKNRnvIcJaRzx+iE5vy1SvPJyH8HMHe2GiTWiuI4fIempjQdrsigeJU9X
uEF3CrdhkGZ7o9B4ukAXjCYKIVET7cFr2XyorYcHHL16Ff2fK/9AZKT3UaxGJvsV
yX4yh8TavM2sAjPntEXNX2fpD3YSPQEf0ux+JaPA+/+dE3YsApK+VWyeKf2dHDMX
16q7rAx4qhYKHU4tPr+iPOjVE1eSQLwtYXXWNFopUGQFat4+4aoRdhBam/FyOki4
xx8L9h9iFK58cITcy8c89Bl5b31bKfBTsnIY5z/13Jkuy9zoOFXQmtfiot2sgXa0
mnj5gR1xiR9z1aFPDhDmNJrMdtbIDsIRaCHCZNR4gMSBok4nuae9pjFetDBjTzi/
t25hQS5FHq7KAS64KqGV
=HNXd
-----END PGP SIGNATURE-----

--5XE05GvkCTmNGP229nNLe7EETKeb1SsnS--
