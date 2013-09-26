Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3IZBPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:15:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53916 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3IZBPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:15:13 -0400
Date: Thu, 26 Sep 2013 11:15:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        majianpeng <majianpeng@gmail.com>,
        Kent Overstreet <koverstreet@google.com>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: linux-next: build failure after merge of the ceph tree
Message-Id: <20130926111500.cb583a5fe861bd4699a4e9d7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__26_Sep_2013_11_15_00_+1000_iq6LVudnh/wlCoo3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Sep_2013_11_15_00_+1000_iq6LVudnh/wlCoo3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sage,

After merging the ceph tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/kernel.h:14:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from fs/ceph/file.c:3:
fs/ceph/file.c: In function 'ceph_sync_read':
fs/ceph/file.c:421:21: error: 'struct kiocb' has no member named 'ki_left'
       (unsigned)iocb->ki_left,
                     ^
include/linux/dynamic_debug.h:79:10: note: in definition of macro 'dynamic_=
pr_debug'
        ##__VA_ARGS__);  \
          ^
include/linux/ceph/ceph_debug.h:17:2: note: in expansion of macro 'pr_debug'
  pr_debug("%.*s %12.12s:%-4d : " fmt,    \
  ^
fs/ceph/file.c:420:2: note: in expansion of macro 'dout'
  dout("sync_read on file %p %llu~%u %s\n", file, off,
  ^
fs/ceph/file.c:430:17: error: 'struct kiocb' has no member named 'ki_left'
       off + iocb->ki_left);
                 ^
fs/ceph/file.c:436:25: error: 'struct iov_iter' has no member named 'iov'
    void __user *data =3D i->iov[0].iov_base + i->iov_offset;
                         ^
fs/ceph/file.c:437:18: error: 'struct iov_iter' has no member named 'iov'
    size_t len =3D i->iov[0].iov_len - i->iov_offset;
                  ^
fs/ceph/file.c:458:20: error: 'struct kiocb' has no member named 'ki_left'
   size_t len =3D iocb->ki_left;
                    ^
fs/ceph/file.c:471:26: error: 'struct iov_iter' has no member named 'iov'
     void __user *data =3D i->iov[0].iov_base
                          ^
In file included from include/linux/cache.h:4:0,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from fs/ceph/file.c:3:
fs/ceph/file.c:473:14: error: 'struct iov_iter' has no member named 'iov'
     l =3D min(i->iov[0].iov_len - i->iov_offset,
              ^
include/linux/kernel.h:670:9: note: in definition of macro 'min'
  typeof(x) _min1 =3D (x);   \
         ^
fs/ceph/file.c:473:14: error: 'struct iov_iter' has no member named 'iov'
     l =3D min(i->iov[0].iov_len - i->iov_offset,
              ^
include/linux/kernel.h:670:21: note: in definition of macro 'min'
  typeof(x) _min1 =3D (x);   \
                     ^
include/linux/kernel.h:672:17: warning: comparison of distinct pointer type=
s lacks a cast [enabled by default]
  (void) (&_min1 =3D=3D &_min2);  \
                 ^
fs/ceph/file.c:473:9: note: in expansion of macro 'min'
     l =3D min(i->iov[0].iov_len - i->iov_offset,
         ^
fs/ceph/file.c:496:7: error: 'struct kiocb' has no member named 'ki_left'
   iocb->ki_left -=3D ret;
       ^
fs/ceph/file.c: In function 'ceph_sync_direct_write':
fs/ceph/file.c:588:24: error: 'struct iov_iter' has no member named 'iov'
   void __user *data =3D i.iov->iov_base + i.iov_offset;
                        ^
fs/ceph/file.c:589:14: error: 'struct iov_iter' has no member named 'iov'
   u64 len =3D i.iov->iov_len - i.iov_offset;
              ^
fs/ceph/file.c: In function 'ceph_aio_read':
fs/ceph/file.c:839:7: error: 'struct kiocb' has no member named 'ki_left'
   iocb->ki_left =3D len;
       ^
fs/ceph/file.c:870:8: error: 'struct kiocb' has no member named 'ki_left'
    iocb->ki_left) {
        ^

Caused by commit e6c9af8b8f11 ("ceph: implement readv/preadv for sync
operation").  ki_left was removed by commit 73a7075e3f6e ("aio: Kill
aio_rw_vect_retry()") during the merge window ... basing new work for
v3.13 on v3.11 is a bit problematic.

I have used the ceph tree from next-20130925 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__26_Sep_2013_11_15_00_+1000_iq6LVudnh/wlCoo3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSQ4qZAAoJEECxmPOUX5FE+8YP/2E3UmPwilzIyq9JL8o/0G3d
TR2b8kBb/e9CQqFaPFsxZwSm2Th1UUSaITWisnTrxXIyTuYKPO1qhtV03+Lwa/uZ
crriDkV4oeVzC5rR8lxv5s8IRnjGcTN4CDwkY2NIqHxzVMBaOc23gjf3L6fxdMge
XgTVtt1dkQAyDey5mV6epSQcNgfhdbqyL8k6vzK/MJxVwzi8IzF4lW2Ne+giXKYv
sQa0niovjMItIk6U1QJF1F8wyCNVq7PHuxm4i6ac7lXiYkNYA5mk3OAIoOEXf3ZD
98ykc154NFycnacNGwT26qHmZ8Dru+XwTYrrJ48N9Gty28G0+NXbbUnCQxw7grmt
H786XAWELc8LSVgs2Nc3vdTo3H1pHwLVVAbj9wj2qNtpAK+1QfCIapLgg4fTAChi
Rni0b5PRU4z2gpGdtOsAC2ARBIXeD50qCsZfv1i2+4qeHBZwl6T84EUaD151nN/6
zc3+hwUtz9guDWj63CzgvrJsHA90UpQLypi3PVAqlTfIYkjqruuh5Q4GUVTpUQJN
w8AjP/zctCE1dK7Xo1Vdx4ch5RDe8X76G6sLPmlpucMyxTSRgs3ysCwOgxvCih0V
5KsyR59LkHbI06RzLhnpScMfTMFzdJvneis7Pj7q1mzsE3LSwkYTkn4TnazAknSV
snSgWwBuSEEaj8XvXPng
=aXfx
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Sep_2013_11_15_00_+1000_iq6LVudnh/wlCoo3--
