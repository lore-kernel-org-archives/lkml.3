Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab3BARSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 12:18:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44963 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757111Ab3BARSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:18:50 -0500
Message-ID: <1359739116.31386.64.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] x86: Use enum instead of literals for trap values
From: Ben Hutchings <ben@decadent.org.uk>
To: John Kacur <jkacur@redhat.com>
Cc: stable@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 01 Feb 2013 18:18:36 +0100
In-Reply-To: <1358894672-10914-1-git-send-email-jkacur@redhat.com>
References: <1358894672-10914-1-git-send-email-jkacur@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nqCYNiv+MAaZYXjNYDk+"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 109.129.208.115
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nqCYNiv+MAaZYXjNYDk+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-01-22 at 23:44 +0100, John Kacur wrote:
> From: Kees Cook <keescook@chromium.org>
>=20
> commit c94082656dac74257f63e91f78d5d458ac781fa5 upstream
>=20
> The traps are referred to by their numbers and it can be difficult to
> understand them while reading the code without context. This patch adds
> enumeration of the trap numbers and replaces the numbers with the correct
> enum for x86.
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: http://lkml.kernel.org/r/20120310000710.GA32667@www.outflux.net
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cherry-picked-for: v2.3.37
>=20
> This fixes the following build error
> make O=3D/bld/v3.2.37
> make[2]: Nothing to be done for `relocs'.
>   Using /home/jkacur/linux-rt as source for kernel
>   GEN     /bld/v3.2.37/Makefile
>   CHK     include/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    /home/jkacur/linux-rt/scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CHK     kernel/config_data.h
>   CC [M]  drivers/misc/sgi-xp/xpc_main.o
> /home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c: In function =E2=80=
=98xpc_system_die=E2=80=99:
> /home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1208: error: =E2=80=
=98X86_TRAP_DF=E2=80=99 undeclared (first use in this function)
> /home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1208: error: (Each u=
ndeclared identifier is reported only once
> /home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1208: error: for eac=
h function it appears in.)
> /home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1211: error: =E2=80=
=98X86_TRAP_MF=E2=80=99 undeclared (first use in this function)
> /home/jkacur/linux-rt/drivers/misc/sgi-xp/xpc_main.c:1212: error: =E2=80=
=98X86_TRAP_XF=E2=80=99 undeclared (first use in this function)
> make[4]: *** [drivers/misc/sgi-xp/xpc_main.o] Error 1
> make[3]: *** [drivers/misc/sgi-xp] Error 2
> make[2]: *** [drivers/misc] Error 2
> make[1]: *** [drivers] Error 2
> make: *** [sub-make] Error 2
[...]

Queued up for 3.2, thanks.  I've also added X86_UV and SGI_XP to the
x86 .config I build.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-nqCYNiv+MAaZYXjNYDk+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUQv47Oe/yOyVhhEJAQrTyg//dI36HnJLhvOfh/171dMGqgFkJ1P91SYW
vzkgpV1yIrObTw9rBi4Yvo9Rglz80G8C4Mi+4ZdI60aKWcsggmnW/5luZ7zIjhRE
AXMLBRYNfXvR/MMosdefPVln4uUkZ3hxInfS2zOqbbwYj8PQIlreeaGfpIbx2trJ
DJA7jhMWlhsE6sULlttObXlPiKaguH/AupP4rC+nBL0pkLRUXNapbL4oIrk9KydP
hBkHXVSyxHS6X3cGabLhPSF0AUoQTFq1OAo+vCJg1vcHPgHLJJxUvYSq5HhTKfTu
v+T92JABaDbEWo8z1XmNY0koAyJhRUr2rEnG0UYSP3oyWJUrw4w9mn3OAiK14bZA
RKy/sxH/k9LsDsdeksqqv5ddre2T8mTCpPKUCbHxOPjIbeIWbVD4MS7gSrS9KN7h
Y1EbyCfnbmvSC9JM/BzBzKWcx/upKtKgPUDSFXjGya7SKOGVXK3izB4ofuDQsreL
ZOAkVj/ukqUM1j41p4rjEuVEuRpHoO97OB1SRud0W2RUieJVG6zVcamp+Cb17feV
6IIo5lpOX68wP8VRVYLHrrZ8pIg9BC5lxDtw1Lj2jWradM1hj2aF+PrZTXHMq7l5
tcfAmStkxLQ/xWNgoFNSTaTWtIPv21m772UzkxJSeN5Jh077VEG5PCDTKbXi0lH4
Rsp8/oNlfvc=
=NaqN
-----END PGP SIGNATURE-----

--=-nqCYNiv+MAaZYXjNYDk+--
