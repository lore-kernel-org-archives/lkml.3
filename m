Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaGUIYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:24:09 -0400
Received: from ozlabs.org ([103.22.144.67]:50959 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaGUIYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:24:07 -0400
Date: Mon, 21 Jul 2014 18:16:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>
Subject: linux-next: manual merge of the akpm-current tree with the security
 tree
Message-ID: <20140721181602.2ce40371@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/N9+as9ChQ/A/S9RAsrZgRh9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/N9+as9ChQ/A/S9RAsrZgRh9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/x86/syscalls/syscall_64.tbl between commit 48dc92b9fc39 ("seccomp:
add "seccomp" syscall") from the security tree and commit f5e74a5d7743
("kexec: new syscall kexec_file_load() declaration") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/syscalls/syscall_64.tbl
index 252c804bb1aa,6d3545914821..000000000000
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@@ -323,8 -323,7 +323,9 @@@
  314	common	sched_setattr		sys_sched_setattr
  315	common	sched_getattr		sys_sched_getattr
  316	common	renameat2		sys_renameat2
 -317	common	kexec_file_load		sys_kexec_file_load
 +317	common	seccomp			sys_seccomp
 +318	common	getrandom		sys_getrandom
++319	common	kexec_file_load		sys_kexec_file_load
 =20
  #
  # x32-specific system call numbers start at 512 to avoid cache impact

--Sig_/N9+as9ChQ/A/S9RAsrZgRh9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzMxHAAoJEMDTa8Ir7ZwV+fUP/jyO7wsAuMjOoxWSSAdIPPYz
xXL3hLHum99LksVCYYIr92VsvPYvYxLkBjBpIW6WNNVyecVblTi04KefvTCcVmeW
zGZghqZI95ioP80POC2+cPctBCN6EiKtS1/xgKccgP0Rh+86jXNL9nvUBoK5MpE9
3+NdLc59vz699wPaCto9xOYdKjvKaiIzZpvBdiUiY+FyfO9lCfZIkm6+kPRi5ATP
RiShG6x/H2FXG/8IZkgHLqpqn3Yx/4aZzlx+fNXQ9KmAQEvhEkGuY7lQBC3d49uJ
u6LIaV+pmsheDWCL+cYMJEq3wAC8rS8eza5TFj3d4Cf1obZtUDim/r02ZraR/84o
ujdPL5fTYPGBhRWaBwzIPgKCP4KqKKey6eCXpv9JvJ8CAErVclFHRR/L2h0tSZ7v
Kk8e4tLW8q7iQLYpTLPRZqc8PhEmsiUeCjNeQ/a7IqPD/jgqIk4dLEoJsHHVjcvA
7jpIE1P+LnVhd+xvKr9rA3jiouy8dQ+ACaF5T/hlF5Yq2aZZVcW+QlGVF5iciMSX
mxQJ9i6zusbq+ibLhMLUPMTUC7Fp7y08bIQI3oKn4oWU3GkjAUlYnYfU6FuGlr5B
261tldRdx8Mb5Ke9Uv7neVaETN/q002eOk/GZi2PTI7Hgp7Z7yih97W5nURF/ixq
jXFJ0eODzJfOfqhalw0Y
=NXcL
-----END PGP SIGNATURE-----

--Sig_/N9+as9ChQ/A/S9RAsrZgRh9--
