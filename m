Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3KGAa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:30:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53764 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941Ab3KGAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:30:20 -0500
Date: Thu, 7 Nov 2013 11:30:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vfs tree
Message-Id: <20131107113005.d068960eda157921c9a302e2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Nov_2013_11_30_05_+1100_Ih/3eENMydsNvUnr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Nov_2013_11_30_05_+1100_Ih/3eENMydsNvUnr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the vfs tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

fs/built-in.o: In function `dump_align':
file.c:(.text+0x4a7e8): undefined reference to `__aeabi_ldivmod'

Presumably caused by commit 3812867c5fcb ("new helper: dump_align()").  I
assume that there is a 64/32 bit mod operation in there somewhere?

I used the vfs tree from next-20131106 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Thu__7_Nov_2013_11_30_05_+1100_Ih/3eENMydsNvUnr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSet8SAAoJEMDTa8Ir7ZwVFFsP/3bCWVpNPdTnv9xb6M5bc98g
6O0Ep1sgr70U1Zxgt6CbbSGNf/BT2vlo0gYcjdV+4Xtd7KKwojFmVMB9OjRUhs/S
yrx6zDI7PqmeTocrYAlwvUMXoYVb+qq1GjEsDQYYy9aYhaj1bDkIfi9lI3pUKqhX
isJrxWxr6AG8ITWWL0v0HiMKOJ3cxkStWa89Z7nQR2lB6EPn+3hVm5ew0g0rr2Qq
d0SWlgZeFPUzP27ruo59PAJrMqBxTJ4nG9+5n7UPNA26Pj10ehrvRb1eKi12dgNo
DCA983cxhcwKukv/rsXDWmfAM0tS1wYsJGh2He/2hYye7bcQOZRPymopRYqhRFVP
O5XKk4iXyUfCu+86fJM7bhGzJisb+Rdk2KrS5Pg9YoAiq1Zkz13btFNQ+IU7E5vc
ue74Im8OWKq6hcTHz16pTlFZoV5jUbpenc21IxeBBjB8SFjTCwgHU65caopMWMcU
oj32Ji03nYcBGwMmfr+PqpFuPMMvxDW6INUm0P4z3HMy3FTPH9AdJ73G2j/+sSL4
CxaBRo2TkHD36K0EpBwHMegxuyRH7EZmw3XuXZYa4e/E014C7r22bAy8/vtKuIbW
EAkdCccDU3gXRDv2R+9DTGIK94TL38kyZRFOiKj7V5zy8PenqMJwVndl3opub4Ix
W5a12iGqWCJ5OcbayCyH
=kdRt
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Nov_2013_11_30_05_+1100_Ih/3eENMydsNvUnr--
