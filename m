Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637Ab3DCGKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:10:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44442 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760912Ab3DCGKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:10:43 -0400
Date: Wed, 3 Apr 2013 17:10:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130403171032.9a50cf0a827508fe5ea82e8a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Apr_2013_17_10_32_+1100_cdknf74bePeQ7Lha"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Apr_2013_17_10_32_+1100_cdknf74bePeQ7Lha
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in ipc/msg.c
between commit 2dc958fa2fe6 ("ipc: set msg back to -EAGAIN if copy wasn't
performed") from Linus' tree and commit "ipc: remove msg handling from
queue scan" from the akpm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc ipc/msg.c
index 4eaf3fd,628c6ea..0000000
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@@ -860,17 -860,8 +860,9 @@@ long do_msgrcv(int msqid, void __user *
  						walk_msg->m_type !=3D 1) {
  					msgtyp =3D walk_msg->m_type - 1;
  				} else if (msgflg & MSG_COPY) {
- 					if (copy_number =3D=3D msg_counter) {
- 						/*
- 						 * Found requested message.
- 						 * Copy it.
- 						 */
- 						msg =3D copy_msg(msg, copy);
- 						if (IS_ERR(msg))
- 							goto out_unlock;
+ 					if (copy_number =3D=3D msg_counter)
  						break;
- 					}
 +					msg =3D ERR_PTR(-EAGAIN);
  				} else
  					break;
  				msg_counter++;

--Signature=_Wed__3_Apr_2013_17_10_32_+1100_cdknf74bePeQ7Lha
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRW8fYAAoJEECxmPOUX5FElJEP/RzBwdKUjymLn1YYWzConncN
LDuRNWFFHTfSNc3jhViIATQ4jiHzMjS3GOlE2nJY1Dg6Z2srdPCeVkGjFNS4fG/j
1AKQu52/wzwfcteck0zwZg0prIAntEASwAnolRqRQd2UqYozZ1f11zbxIot52NbT
EAOiI4h4pQuNJv9f01d6iLncmcW3h+F+Zb8lKXGDRUFXAyiYV+fMpeq8kkM2a7wJ
GZXAyMo0M3UPRu3G1BvxkIByYlNBdMoynY26dXRNHty4rbbdfF2RsqA7Hqjy+I5A
TnT8El7+8hoI62cjzkKf4c0bk5ZPVOAslbc08m351PPIWnHtLrkO5bHw400xycja
LSaakV7BU1aSbWSORoGK8Rvwqw8YWQQXCOk9ZwtG7rPWP2QU5oIt2dBO4+bQbyhW
3kNJU3TXXDyO1dBezC7F1j6wB70VMA496Uf2qKTN04ugeyH7LFB9BR80NsHQVZrO
1nE4452Xu+q/nhihg3A7wD89D763sd13EdWegJPSuOLo51YDu7WxmXk75jDDcwXB
WLxBPNEY2rtoCqilWeSQo8wzLTVtJCLbFUR5FDP31J9P9NKXv7eQjtrsBp0lZIU7
0L7jiZX2YSBLtHZBAXgJsX3b3IpMmsgW/Or+H/+NtEP2bDYI8Rg54VfU/Jebqn95
VdMiSvJHncitJVDNEMSr
=KFIT
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Apr_2013_17_10_32_+1100_cdknf74bePeQ7Lha--
