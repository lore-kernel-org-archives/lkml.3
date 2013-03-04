Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab3CDB7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 20:59:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49162 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab3CDB7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 20:59:01 -0500
Date: Mon, 4 Mar 2013 12:58:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the signal tree with Linus' tree
Message-Id: <20130304125851.9c4742ac4c8d0061fa71e0c0@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Mar_2013_12_58_51_+1100_yGE3P+.mTy1H9fTC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Mar_2013_12_58_51_+1100_yGE3P+.mTy1H9fTC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/tile/Kconfig between commit 887cbce0adea ("arch Kconfig: centralise
CONFIG_ARCH_NO_VIRT_TO_BUS") from Linus' tree and commit 15d9a5d9296a
("make HAVE_SYSCALL_WRAPPERS unconditional") from the signal tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/tile/Kconfig
index 1404497,4069d87..0000000
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@@ -16,8 -16,6 +16,7 @@@ config TIL
  	select GENERIC_PENDING_IRQ if SMP
  	select GENERIC_IRQ_SHOW
  	select HAVE_DEBUG_BUGVERBOSE
- 	select HAVE_SYSCALL_WRAPPERS if TILEGX
 +	select HAVE_VIRT_TO_BUS
  	select SYS_HYPERVISOR
  	select ARCH_HAVE_NMI_SAFE_CMPXCHG
  	select GENERIC_CLOCKEVENTS

--Signature=_Mon__4_Mar_2013_12_58_51_+1100_yGE3P+.mTy1H9fTC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRM//bAAoJEECxmPOUX5FEG+UQAKZRfQBv0nt602RNmZnqIhcr
goDHrNg6wDOVigIiBQdgPAUmUhSNqEntgnxfRcM2woojzuAAAF48W6chjG56UKrz
oftfH0bHhGjGfUJH5co2sV4iurRZ1nuUWnCTzIDwP0rsezMGUXeP3/26D1o/3WKs
wX81RGISDcqy6Ly5zaZaq1blQCoPjHy+V2oWKtZ6yGecw39zJ+rmM0mPa/QGMlbz
+SQhzjQ2FVuM5KU9mdqr04unULOTr5FjVZ8ZrGMxV7SopFZOmJUAblGEClQOhvlU
a6Ukm9eT/bvoY/w0dWhwykevjLoE9bDb8wscuKOM76oK0jsDQl1vbL7TIb0OgVWn
+FLV8Ok+42NqY6Ox5gAHv+rZh16JEdZxR52lJtjYiOeZ/O/5ergWAz6K11aNOlFj
ihn9C+Yvq1SfGbbpYhdlYetVLsxp9FqtkaRt/xrzWTPTN48ZokGcSMStpRUyoG0y
DKKhB6+h3zg1HT05BT8ES6iW6RVF8BJxbyMDLPxcGShT0LlgJ9Vk46YfSP8qwTbh
1Wq4vIR//N8Z27dTJOX1TR74X1GaMBRej9x/7FMUJJSn/3SEEcrRlXjbAjpgGdHk
5bybT2LQkBLz+1XpsXxnn+Vdwg4WE3kJ7g7YzQBkr8ppNtBaCZFF0r+tRhtgLtID
uM9wysrQWXks2iUayQxB
=eT64
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Mar_2013_12_58_51_+1100_yGE3P+.mTy1H9fTC--
