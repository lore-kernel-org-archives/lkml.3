Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbaCQJ2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:28:37 -0400
Received: from ozlabs.org ([203.10.76.45]:42374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbaCQJ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:28:35 -0400
Date: Mon, 17 Mar 2014 20:28:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: linux-next: manual merge of the akpm-current tree with the gfs2
 tree
Message-Id: <20140317202829.53f008e41e3ab6fdbeaa3345@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_20_28_29_+1100_K7bsOFAEe.LLovkR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_20_28_29_+1100_K7bsOFAEe.LLovkR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/fs-writeback.c between commit 774016b2d455 ("GFS2: journal data
writepages update") from the gfs2 tree and commit c830ee18343d ("bdi:
avoid oops on device removal") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/fs-writeback.c
index 648d5db14e2c,a16315957ef3..000000000000
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@@ -89,8 -89,14 +89,16 @@@ static inline struct inode *wb_inode(st
  #define CREATE_TRACE_POINTS
  #include <trace/events/writeback.h>
 =20
 +EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepage);
 +
+ static void bdi_wakeup_thread(struct backing_dev_info *bdi)
+ {
+ 	spin_lock_bh(&bdi->wb_lock);
+ 	if (test_bit(BDI_registered, &bdi->state))
+ 		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
+ 	spin_unlock_bh(&bdi->wb_lock);
+ }
+=20
  static void bdi_queue_work(struct backing_dev_info *bdi,
  			   struct wb_writeback_work *work)
  {

--Signature=_Mon__17_Mar_2014_20_28_29_+1100_K7bsOFAEe.LLovkR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJsBCAAoJEMDTa8Ir7ZwVTTgP/jKyOwcP8Rc639zy0A/5SCNc
fc2Wpud7qcbQ14GGr14w47DLLTu6JQIADTLHCeTbXRATXpcpDQKa+14ZJQOduN+E
6GcP4OQxgFaEBkcAtDc6eY3gJ3evbzKJc+qn4USo8agiseNJQNBOacunZHk7sT/y
nmdECdOtNu5nwehSHAuS/KLl7jUpi1wBycEsIDIJOxdXWQYd8Z7i0sL/h7zUPcvl
//CmKqYGH4cH3cWPT+grTCxY2IZFu2DKZ/+Q4RvYuu+IniM8DsoL/YGsKgv9ZAa2
mZfUEj2Nxp8k1nl0kkTW5i7YaB7oLz9nc0V6TFpCIF9vqNCWecl+Ieti41YLnmEW
adE9lGewpcZjPdbwtQXmjixxiZhi+gVr8reH57EiowHJOamPcKWUwKhwMZIb4bZ8
if/yiPvUfXtPHUo+Y3sKvStUxXYijfDNxzRrSfl6L9uruklPVto7FnifUqC5RqDC
HiPxIc5mSEGWXw/K0CdIhy5oQxSmR1+BNwLdn/MCwRSYR5N0Ns9gOKM+0TOYymBN
6rrjfekYIWeNjsEy/Jm7ud47Q0T2kM7us5QKsrUaeBzl6IRwMMI9oAf10snPWvKX
TIyaae+AvVQtZRavRL/dlecgJ4IsUnt1gP7dmcBc/CRnK//ejJLbamaZZKiB2pS7
k5IJ3GJUdHdOoksKXTGN
=WjV9
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_20_28_29_+1100_K7bsOFAEe.LLovkR--
