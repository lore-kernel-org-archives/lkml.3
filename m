Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaELF4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 01:56:13 -0400
Received: from ozlabs.org ([103.22.144.67]:56180 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbaELF4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 01:56:11 -0400
Date: Mon, 12 May 2014 15:55:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Scott Wood <scottwood@freescale.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: linux-next: build failure after merge of the fsl tree
Message-ID: <20140512155557.5b758614@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/elLLYofYkdxJx6jXv+M0eEG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/elLLYofYkdxJx6jXv+M0eEG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Scott,

After merging the fsl tree, today's linux-next build (powerpc
allyesconfig) failed like this:

arch/powerpc/kernel/epapr_paravirt.c: In function 'epapr_idle_init':
arch/powerpc/kernel/epapr_paravirt.c:77:23: error: 'epapr_ev_idle' undeclar=
ed (first use in this function)
   ppc_md.power_save =3D epapr_ev_idle;
                       ^

Caused by commit 7762b1ed7aae ("powerpc: move epapr paravirt init of
power_save to an initcall").

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/elLLYofYkdxJx6jXv+M0eEG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcGJ5AAoJEMDTa8Ir7ZwVACUP/22wVygigCWr729ZnUuAeO0L
hkh7xpnHGTSslOs6kfwnXcq2c0Mh94nOZTqmI5L5WPq1+bInlsEBSwoZKrzqkHov
m3H3H94iWPD83rw6iVzvenpNvQErxZMPUSKW+WQc09byDWmTt+gm2TGARAdzoWND
CT6958dJ0Sh1H4UQls+LJ1Pqblhx5m/2BkvZxLveeogwBZHkmqZgaWb79BAnsqsL
pvt3V8QDgyphR4Zo8NasUUBf01Pce+A3+0UsEM67+KqPbnl99VjnPU7W29X0/ceA
UDQEvWIsKpCKCV+sMWsb57eqD97+KFSfMGwV3j2YCO1kKRtbrn5JYLtECFQfygld
dgpvrLJMOakxnyKK+Xy1OeCGGvAorTzKMPnq4nUfOe0bk1+snvmVCpncGLCbcxgw
rRpXJcGxTp1TqbTrv6XVpsmEWHcbuQGJnz2uRgNFxVKI8JWMRbFn6V6Kt7H580bc
upbMil0joLzuWzl6iYusqwuXxZOMqW7dF2OtcxwNhQh3O+869HwhCPOU7vkMtfES
wUJvWMbUaMkT3wFfpJiMN53awjP7nN3q66CHIzIVWkQXxWsW2gVs1ha8SOjERjQj
RaVfxqylz5w+0uueGgraAe1NmljIajKbaMIebOeUPTWXzJUgOFd5vTXGy0WShcto
mbk7nmxrzhbDkvdCUGnH
=m/mk
-----END PGP SIGNATURE-----

--Sig_/elLLYofYkdxJx6jXv+M0eEG--
