Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaKLG0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 01:26:43 -0500
Received: from ozlabs.org ([103.22.144.67]:46774 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbaKLG0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 01:26:40 -0500
Date: Wed, 12 Nov 2014 17:26:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Burton <paul.burton@imgtec.com>
Subject: linux-next: build warnings after merge of the mips tree
Message-ID: <20141112172633.2b0c9cae@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//1bjOwy8=0Xy7v/DVrvJZjT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//1bjOwy8=0Xy7v/DVrvJZjT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

After merging the mips tree, today's linux-next build (powerpc64
allnoconfig) produced these warnings:

In file included from fs/compat_binfmt_elf.c:145:0:
fs/binfmt_elf.c: In function 'load_elf_binary':
fs/binfmt_elf.c:718:13: warning: passing argument 1 of 'arch_elf_pt_proc' f=
rom incompatible pointer type
    retval =3D arch_elf_pt_proc(&loc->elf_ex, elf_ppnt,
             ^
In file included from include/linux/elfcore-compat.h:4:0,
                 from fs/compat_binfmt_elf.c:20:
include/linux/elf.h:81:19: note: expected 'struct elf64_hdr *' but argument=
 is of type 'struct elf32_hdr *'
 static inline int arch_elf_pt_proc(struct elfhdr *ehdr,
                   ^
In file included from fs/compat_binfmt_elf.c:145:0:
fs/binfmt_elf.c:718:13: warning: passing argument 2 of 'arch_elf_pt_proc' f=
rom incompatible pointer type
    retval =3D arch_elf_pt_proc(&loc->elf_ex, elf_ppnt,
             ^
In file included from include/linux/elfcore-compat.h:4:0,
                 from fs/compat_binfmt_elf.c:20:
include/linux/elf.h:81:19: note: expected 'struct elf64_phdr *' but argumen=
t is of type 'struct elf32_phdr *'
 static inline int arch_elf_pt_proc(struct elfhdr *ehdr,
                   ^
In file included from fs/compat_binfmt_elf.c:145:0:
fs/binfmt_elf.c:747:14: warning: passing argument 1 of 'arch_elf_pt_proc' f=
rom incompatible pointer type
     retval =3D arch_elf_pt_proc(&loc->interp_elf_ex,
              ^
In file included from include/linux/elfcore-compat.h:4:0,
                 from fs/compat_binfmt_elf.c:20:
include/linux/elf.h:81:19: note: expected 'struct elf64_hdr *' but argument=
 is of type 'struct elf32_hdr *'
 static inline int arch_elf_pt_proc(struct elfhdr *ehdr,
                   ^
In file included from fs/compat_binfmt_elf.c:145:0:
fs/binfmt_elf.c:747:14: warning: passing argument 2 of 'arch_elf_pt_proc' f=
rom incompatible pointer type
     retval =3D arch_elf_pt_proc(&loc->interp_elf_ex,
              ^
In file included from include/linux/elfcore-compat.h:4:0,
                 from fs/compat_binfmt_elf.c:20:
include/linux/elf.h:81:19: note: expected 'struct elf64_phdr *' but argumen=
t is of type 'struct elf32_phdr *'
 static inline int arch_elf_pt_proc(struct elfhdr *ehdr,
                   ^
In file included from fs/compat_binfmt_elf.c:145:0:
fs/binfmt_elf.c:761:11: warning: passing argument 1 of 'arch_check_elf' fro=
m incompatible pointer type
  retval =3D arch_check_elf(&loc->elf_ex, !!interpreter, &arch_state);
           ^
In file included from include/linux/elfcore-compat.h:4:0,
                 from fs/compat_binfmt_elf.c:20:
include/linux/elf.h:104:19: note: expected 'struct elf64_hdr *' but argumen=
t is of type 'struct elf32_hdr *'
 static inline int arch_check_elf(struct elfhdr *ehdr, bool has_interp,
                   ^

Probably introduced by commit 7b76fe94c0e4 ("binfmt_elf: allow arch
code to examine PT_LOPROC ... PT_HIPROC headers") and maybe the
preceeding commits as well.

binfmt_elf.c is included by compat_binfmt_elf.c after defining some
things to build the compat versions of things.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_//1bjOwy8=0Xy7v/DVrvJZjT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYv2eAAoJEMDTa8Ir7ZwV5RUP+wVj0Ej1Q8MAQdDeRKwRdjK0
uMnDfjfKp75IoB7KC/gcMlXqzbVlcR+hvsM2g8h2EmQr30ZqcDhmXZw92qOh8oQQ
4SiYC4qwbGlBOV0xSHI2ZyvFvpfLkSzpiGJe9eTw1KniRfHd74OJFOMq6NfVT/2l
wnZr3y21MWroK4gzkTmPTZ1MQ9OLIbQi7Y8nx1uluk6g4O0h/E2WrrTvNpyPOQeE
xEEgZSlH7OMjOxSJNXq5YK/PxI61+Ijjqfkxds8NnxC1YfHNeg4Z0q/54StFOZ/A
hjLwAjBc+Tr8jtcJ0AyXlUfzLhC1BqVoJdOR0BdAv7Rs9SncVaxoGsTq/az5Mmr+
NlmyuzYW1w84/YSjiOEjhU4dsNB0NhEkkXSWlwwLPYhMP2c3tj41pwFX5duqfxnH
vA8SujtP3iJPn0NMu+OTfuRyTQzj31lS4D2uDPQTDYtRU14jyN1I3a03dl6x1Ptq
wlD4gfTcuhVDo7+KfLMq7dEW0B4xXPK5MgBx2S1ah9yqG0UBxcnsijJ6rAvUBhUp
8pYMx8Y6imnAYPxOIEpeoSRo/fEzo5It+q0IigZGsFXTYQe4ZJHbAaxqo5yv+ftA
eQcW2GMsp0wBHA+8uUCsmFuXsyEk/rw6YkFerrFHdJ1OGvj0J1oltvLE5bf1HiW3
8aZx+Q/2cowegvkYiF8X
=Gnih
-----END PGP SIGNATURE-----

--Sig_//1bjOwy8=0Xy7v/DVrvJZjT--
