Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab3FDGzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:55:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44698 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FDGzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:55:45 -0400
Date: Tue, 4 Jun 2013 16:55:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <koverstreet@google.com>, Tejun Heo <tj@kernel.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130604165533.d3704b1927cefe6413c52ea7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Jun_2013_16_55_33_+1000_MYv7Nk7=+CTuqp+f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Jun_2013_16_55_33_+1000_MYv7Nk7=+CTuqp+f
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/aio.c: In function 'put_ioctx':
fs/aio.c:386:6: error: void value not ignored as it ought to be
  if (percpu_ref_put(&ctx->users))
      ^
fs/aio.c: In function 'ioctx_alloc':
fs/aio.c:427:2: error: too few arguments to function 'percpu_ref_init'
  percpu_ref_init(&ctx->users);
  ^
In file included from fs/aio.c:40:0:
include/linux/percpu-refcount.h:69:5: note: declared here
 int percpu_ref_init(struct percpu_ref *, percpu_ref_release *);
     ^
fs/aio.c: In function 'kill_ioctx':
fs/aio.c:510:6: error: void value not ignored as it ought to be
  if (percpu_ref_kill(&ctx->users)) {
      ^
fs/aio.c: In function 'exit_aio':
fs/aio.c:577:8: error: void value not ignored as it ought to be
    if (percpu_ref_kill(&ctx[i]->users)) {
        ^
fs/aio.c: In function 'aio_read_events':
fs/aio.c:978:2: error: implicit declaration of function 'percpu_ref_dead' [=
-Werror=3Dimplicit-function-declaration]
  if (unlikely(percpu_ref_dead(&ctx->users)))
  ^
cc1: some warnings being treated as errors

Caused by commit 215e262f2aeb ("percpu: implement generic percpu
refcounting") from the percpu tree interacting with commit 4a375d552122
("aio: percpu ioctx refcount") from the akpm tree.

I removed the following patches from the akpm tree:

aio: reqs_active -> reqs_available
aio: percpu reqs_available
aio: percpu ioctx refcount
aio: use xchg() instead of completion_lock
block: prep work for batch completion
block-prep-work-for-batch-completion-fix-2
block-prep-work-for-batch-completion-fix-3
block-prep-work-for-batch-completion-fix-3-fix
block-prep-work-for-batch-completion-fix-99
block-prep-work-for-batch-completion-fix-4
block-prep-work-for-batch-completion-fix-101
block, aio: batch completion for bios/kiocbs
aio: fix kioctx not being freed after cancellation at exit time
block-aio-batch-completion-for-bios-kiocbs-fix
virtio-blk: convert to batch completion
mtip32xx: convert to batch completion
aio: convert the ioctx list to radix tree

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Jun_2013_16_55_33_+1000_MYv7Nk7=+CTuqp+f
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRrY9pAAoJEECxmPOUX5FEPAsP+wZELsjMPi+fxBJEmz1cuHZE
XmvC+zHrtFJepDyiN9o38/Ia2hxpFtIfNiIJTCF1I7acTbGLhP4CA8gtX7Bie9Xc
T7n5SZaycFbRo4DB8DmvLylg5bZ/gd+OslpzP+XrKHhHLIx5zeBZpwfRrR73yJ+l
pfbubLZ0wpbA08eh1ERtrhVLzZQvKJWe1QDS0ovCbSqHSWrHQjOLyD/e575tQzED
/c+gom+yqSpw0fi8kXrQGUj74TUUFNuPgX4R4ab5FXLJqlzRmeH0UroH+Gdb1YxY
UJ9Z595cdvIJZzUaPyiar5A1WMKSOLx8WkC55MKw6r9+R1AKpztC/yHLrk8F9jI9
q0UgZAaW+GyBUrq33vpdr+WYQfkJTpKBA+ilYJWux0Sji/wwoO/8P9GrlOIYktMa
cNTb05S/64Hlp3G0fkSf6F7S9hfbR0ZOZKNwRIS14X2++p8CMB4VhA8p9wHnoYx6
QGpdHpBD48rEvEkmF9Zi25ThLaTauZMrrfSxUMLJPT0szZrGihtyRXDbgUaEfWqK
HEiqPtoRBx9cPxtH3VhlA+UcvG+UD/glESS88b7lBk4pUBxKcx9WB7XkEGh4fNCZ
uPUMg5R2mqpUqlEpSktSrG5pOD/38faTo7PAeBJ7l88WWfG6ha3f+jzhibPT1+1g
Cqn3lYceJeVd1V+zi49v
=yXWi
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Jun_2013_16_55_33_+1000_MYv7Nk7=+CTuqp+f--
