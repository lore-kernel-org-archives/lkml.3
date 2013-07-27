Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3G0Xa5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 19:30:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60987 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698Ab3G0Xaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 19:30:55 -0400
Message-ID: <1374967837.3607.31.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/45] 3.0.88-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: linux@roeck-us.net
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Date: Sun, 28 Jul 2013 00:30:37 +0100
In-Reply-To: <20130727062230.5580181gtrfxe83k@67.228.131.205>
References: <20130726205654.896050165@linuxfoundation.org>
	 <20130727062230.5580181gtrfxe83k@67.228.131.205>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jzGQ2ZnKZr+AECfhuMhv"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jzGQ2ZnKZr+AECfhuMhv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-07-27 at 06:22 -0500, linux@roeck-us.net wrote:
> Quoting Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
>=20
> > This is the start of the stable review cycle for the 3.0.88 release.
> > There are 45 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun Jul 28 20:54:53 UTC 2013.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.88-rc1.gz
> > and the diffstat can be found below.
> >
> We have additional build failures.
>=20
> Total builds: 54 Total build errors: 20
>=20
> Link: =20
> http://desktop.roeck-us.net/buildlogs/v3.0.87-45-g367423c.2013-07-27.03:0=
9:16
>=20
> Previously:
> Total builds: 54 Total build errors: 17
>=20
> Additional failures are i386/allmodconfig, i386/allyesconfig and mips/mal=
ta.
>=20
> I don't have time to track down the culprit tonight (I am still in =20
> Down Under ;). I hope I can do it tomorrow.

I iterated through the 3.0 patch queue with i386/allmodconfig, and got
to:

Applying patch ifb-fix-rcu_sched-self-detected-stalls.patch
patching file drivers/net/ifb.c

Now at patch ifb-fix-rcu_sched-self-detected-stalls.patch
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
  CC [M]  drivers/net/ifb.o
drivers/net/ifb.c: In function =E2=80=98ifb_init_module=E2=80=99:
drivers/net/ifb.c:257:3: error: implicit declaration of function =E2=80=98c=
ond_resched=E2=80=99 [-Werror=3Dimplicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [drivers/net/ifb.o] Error 1
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

I think this patch needs to add a '#include <linux/sched.h>', but that
header is being included indirectly in some other configurations (and in
mainline).

With that change, I can apply the remaining patches and compile
3.0.88-rc1 successfully.

Ben.

--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-jzGQ2ZnKZr+AECfhuMhv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfRYHee/yOyVhhEJAQrCmg/+LCqnT3lVeTBXfupZ41XhXOEI2swxu3Wi
GDUEJu5XNohzC87aMtzZHdaZcR6/l6Jg0054YnH/mTl6Rbuu2yuWQkbA44yac4QF
MXzdekuFo7dPab7rZiHOURlLQdd/zBOQo1AYutZSCVujHmu+TBC1LAHkBa4mKwFm
4cPPDW9qB6ZjvOokNq7g8fhrQHGyj8X02DP/6kYoqP/qmXfLi1L7w36WO/aYSeo+
VyPaGRZToZmCzXJzt09wnvmqexS0g276c2CKdskahH19UsD8hTGlKOC4KrAUp/dl
mpqVylr/6jDOnLNT5efeoFczFLuGfNk6QDolF5xzVXNwPOnbUlGMHTJ/YeA6XhuG
VAmb2uFmtEzRfUYTnOF4zOG1H6RQ8KHw2mBJ5bTz6T/kjfwHVL/dy+7PPxRMw5gR
4f3cqGbr07u/Kh/+KnvrCLEh57lLaCK++Bj7ec8CaSKqQU+uDRdjSJPLrcT6pa93
/bPHPsFmPPPYO/jAvkegKzjOSyBdp3laf9c7aW72aOPbwDwy+wTDffhxR16SVEE+
02jcT/09BjCC3DQ5rA7/eU1WRI1uXZt6bqyCQLInAfDQznJPQYrQpFdJCtpduUPy
h4yi3Z7A1OJ1//tMwHt1moYOcBx6MOlmRmJxbFgKI7ghDW8fh34oNwvEducqvS/Y
ha1NMtGap4k=
=Llx5
-----END PGP SIGNATURE-----

--=-jzGQ2ZnKZr+AECfhuMhv--
