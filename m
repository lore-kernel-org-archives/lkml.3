Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaDICkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:40:07 -0400
Received: from ozlabs.org ([203.10.76.45]:53892 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187AbaDICkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:40:04 -0400
Date: Wed, 9 Apr 2014 12:40:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: linux-next: manual merge of the userns tree with Linus' tree
Message-Id: <20140409124002.35ff7d69c75f7332d0feb57a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Apr_2014_12_40_02_+1000_bvEDmizje7w9lspV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Apr_2014_12_40_02_+1000_bvEDmizje7w9lspV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the userns tree got a conflict in fs/dcache.c
between commit da1ce0670c14 ("vfs: add cross-rename") from Linus' tree
and commit f43d102a391d ("vfs: Lazily remove mounts on unlinked files and
directories") from the userns tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).  This matches the conflict resolution you sent to Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/dcache.c
index 40707d88a945,5b78bd98649c..000000000000
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@@ -2701,10 -2631,8 +2663,8 @@@ static struct dentry *__d_unalias(struc
  		goto out_err;
  	m2 =3D &alias->d_parent->d_inode->i_mutex;
  out_unalias:
- 	if (likely(!d_mountpoint(alias))) {
- 		__d_move(alias, dentry, false);
- 		ret =3D alias;
- 	}
 -	__d_move(alias, dentry);
++	__d_move(alias, dentry, false);
+ 	ret =3D alias;
  out_err:
  	spin_unlock(&inode->i_lock);
  	if (m2)

--Signature=_Wed__9_Apr_2014_12_40_02_+1000_bvEDmizje7w9lspV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTRLMCAAoJEMDTa8Ir7ZwVZIwP/jaXQ2Xb0pjqVQRbZopYxRgD
XHQwN0SS/DG+ViXxM5D3PCk2aWsDtJofAVy3+xueqfwD49trRLuH33SwsUgAILKK
pXYA4ym8gO/Nvqo5uCn8ruSvmGzMuKFD2kHd6sQ/6EfhUZ+r2N7lNdPtEiYn7kHo
ab//fgw5CYahOd1YiKtBgwhC7GmTWtlg8ABhCsCuetbeduiiI8R/sVqPZzV/8dXv
CRZ1q4DJZfXYTJIpK9AJY1coIIUldDAE6q0w0sKoS7kdanqtgTqHTt2s5MCPRVk+
PaCL/5wJzcTz62b/oyuMRXPVnjkALim1payt/m72W/5mgubSaoT1xFi3AZBkgd32
tDC8JUY8UxoVJ+oSN4LOhS5fmHNJR5gD9PBYl8Wrt5B9KjDMUJMXEK9PEkvoTbsF
fuYumoY9rRxqU3iJSu1KqtYgw1gHdFB80CeMYExUFjX3YLQr/nc7SHTQLFw4K77W
blgbVKo3Ta/D4w1/pupBu+UcIVjrn7wWuiSJJLFsHHoHJ5jSczJpnrAodbll8mrs
Lz5hvS7BstN2wFaes1DFakRQa7YymhkFuJN5OmQ8NN25VepWtrT2WzafzjDFhjDE
3gTPp+H6qdMYEf7XcAnIACZY/ak13m0Xqp9GZUeiVC8CGlvlP2tDEWTQLg5sVDfP
07De3p11GLdRyuVBWk8D
=peNH
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Apr_2014_12_40_02_+1000_bvEDmizje7w9lspV--
