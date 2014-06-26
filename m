Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaFZGXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:23:07 -0400
Received: from ozlabs.org ([103.22.144.67]:51422 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbaFZGXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:23:05 -0400
Date: Thu, 26 Jun 2014 16:22:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Petr Mladek <pmladek@suse.cz>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140626162257.45f8e2aa@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4iev0dQvO52y3YmY+_m3rjm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4iev0dQvO52y3YmY+_m3rjm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

kernel/printk/printk.c: In function 'log_buf_add_cpu':
kernel/printk/printk.c:269:37: error: 'CONFIG_LOG_CPU_MAX_BUF_SHIFT' undecl=
ared (first use in this function)
 #define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
                                     ^
kernel/printk/printk.c:864:42: note: in expansion of macro '__LOG_CPU_MAX_B=
UF_LEN'
  cpu_extra =3D (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
                                          ^
kernel/printk/printk.c:269:37: note: each undeclared identifier is reported=
 only once for each function it appears in
 #define __LOG_CPU_MAX_BUF_LEN (1 << CONFIG_LOG_CPU_MAX_BUF_SHIFT)
                                     ^
kernel/printk/printk.c:864:42: note: in expansion of macro '__LOG_CPU_MAX_B=
UF_LEN'
  cpu_extra =3D (num_possible_cpus() - 1) * __LOG_CPU_MAX_BUF_LEN;
                                          ^

Caused by commit 58209adf633e ("printk: allow increasing the ring
buffer depending on the number of CPUs").  CONFIG_LOG_CPU_MAX_BUF_SHIFT
is not defined for this configuration.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/4iev0dQvO52y3YmY+_m3rjm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTq7xGAAoJEMDTa8Ir7ZwV57MP/2Qp3HzZctBV+3t2jcpBHRKS
laNDfOjUno5ILbzyr6uY0ravTYS7ytwb7p4AduQS6ImHOY9f0d85ym32bqF5ePCp
B6j5IJUJAlX5OP4Emaq0B1De74MrhttqEgMpDYjznKBHjtrFDIy/X16gBnvfNPiB
t8SpuYMhG4RPn3g+9XskxtgWp8SLZExP9nzvrEk+gT3aaoWI3CT94lyYTFVBU3f7
GiCGhu4NtMBW1SNB28qkqSOCXDUN3U8EO/oyWWI4YS6XwibXaHgpwbll50w2lWn6
EyKMdOc62ov19vncG8lkOT1c/yvvczD0qVg2DlsDBJWY+owc1mcDeaRsgCkRaF+Z
tTbyazIORt/aH/aUK0zTZS4HgRb7hwrfFYM+ajl5MVuja5Rwty0CkR4lWSvMugXO
IjNkGPrIsEFoNfui5EIbtFzbBdoFjybBAckwkE5d7KGg2gqOXcq9Fuw+AdPryMi0
Nq4hZejOShwiNa/UnBwYcT62kSLJTdi2kjc7uA9Tog+fv25+Hd7YgfzNK1BjNsnt
f3ylcAqz4DjBkjp/b5z2qlUYPYea+BNQCndJDOQwsQVO8FcoYzgHOlNGAaldOcSk
17TTa8USFVP0IuMpdgpSiobSkvndtSh0X1IF+wyUfWiv6d2+ZKnZhK4W9IErJYin
Jg8u21m8XiimwkfSNukk
=+uBF
-----END PGP SIGNATURE-----

--Sig_/4iev0dQvO52y3YmY+_m3rjm--
