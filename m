Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3AUCMp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 21:12:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38821 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3AUCMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 21:12:43 -0500
Date: Mon, 21 Jan 2013 13:12:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: linux-next: manual merge of the security tree with Linus' tree
Message-Id: <20130121131230.9f79cf5dcd8a8ac069594111@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__21_Jan_2013_13_12_30_+1100_ZZLU9HpXdIcywDSR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Jan_2013_13_12_30_+1100_ZZLU9HpXdIcywDSR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
security/integrity/ima/ima_main.c between commit a7f2a366f623 ("ima:
fallback to MODULE_SIG_ENFORCE for existing kernel module syscall") from
Linus' tree and commit 750943a30714 ("ima: remove enforce checking
duplication") from the security tree.

I think I fixed it up (see below).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc security/integrity/ima/ima_main.c
index dba965d,cd00ba3..0000000
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@@ -291,18 -275,10 +275,18 @@@ EXPORT_SYMBOL_GPL(ima_file_check)
   */
  int ima_module_check(struct file *file)
  {
- 	int rc =3D 0;
-=20
 -	if (!file)
 +	if (!file) {
 +		if (ima_appraise & IMA_APPRAISE_MODULES) {
 +#ifndef CONFIG_MODULE_SIG_FORCE
- 			rc =3D -EACCES;	/* INTEGRITY_UNKNOWN */
++			return -EACCES;	/* INTEGRITY_UNKNOWN */
++#else
++			return 0;
 +#endif
 +		}
- 	} else
- 		rc =3D process_measurement(file, file->f_dentry->d_name.name,
- 					 MAY_EXEC, MODULE_CHECK);
- 	return (ima_appraise & IMA_APPRAISE_ENFORCE) ? rc : 0;
+ 		return -EACCES;	/* INTEGRITY_UNKNOWN */
++	}
+ 	return process_measurement(file, file->f_dentry->d_name.name,
+ 				   MAY_EXEC, MODULE_CHECK);
  }
 =20
  static int __init init_ima(void)

--Signature=_Mon__21_Jan_2013_13_12_30_+1100_ZZLU9HpXdIcywDSR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/KQOAAoJEECxmPOUX5FEwAMQAImZ8LdFFDOxwtvRgIwTEa8H
Brg6vMWmm6rSXESspIBob4UGI3VI1pB7J27x28K4Tl4Xpa4GJmbkiNqnedmrA+Js
lEXpY1v2tcU+9uFTgjSOJrVkpY9ERCwCfwfi923J5230RGlkemW9xHFoMXPx+XvV
Pd6kEC08ivSjCwMPitC1ZuNw0dI1RcNu5uEmPlQ0D9M/x7RdpMitsSspc4kU/ZuC
scZvzDXj1sOVwf5kx4bKhOuQMoFpgMidhhvfXaeRNc8q9olXiQ+hQ/c2zMd6c/k2
IuZICj5wwt1hhmF1bl+WIup2NrT9qnJgY/6WppeDUzyzDs3EfIdY8QerMwy2eHje
mac/ATddYM9IHmymhNmqtyxoC08Rhpdt7Rx/js3Q2Q5CC0Dv5QZLDqrS/bs9X7+h
ZJWH7e99IBWN6wSewwUKPdjU/+a9wLAMZygsUB5eboj0GV7xi18cjU3Xf5iUSl/C
jBRIT17ZDI4laS7LlnHG2bGDN9QIeoj04z2nhmerox5+4YQWMpjBs9Tfbx0CClcn
QV5lEw3rK2EZmM7QrTyJgRPrS/mbZGKNpg8BERrj+TcL+zdU8vKz5PGo11SrIJtA
k9VSUELoMKaSgqjAFH2zZE8aoVx0npPCnVOXUFrouYIvJpI7kNp1vjqN4a0Pg7iH
Wg+88C2E0mznqmQbT2qL
=MsA6
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Jan_2013_13_12_30_+1100_ZZLU9HpXdIcywDSR--
