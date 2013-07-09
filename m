Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3GIEgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 00:36:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50849 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab3GIEgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 00:36:12 -0400
Date: Tue, 9 Jul 2013 14:36:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Grant Likely <grant.likely@linaro.org>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20130709143600.b32384457b742f54e721dc33@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Jul_2013_14_36_00_+1000_QmLtM+TxMSXe+E7m"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jul_2013_14_36_00_+1000_QmLtM+TxMSXe+E7m
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
kernel/irq/generic-chip.c between commit 1aa0dd94ca07 ("irqdomain:
Eliminate revmap type") from Linus' tree and commit 002fca5df168
("genirq: generic chip: Use DIV_ROUND_UP to calculate numchips") from the
tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/irq/generic-chip.c
index 10e663a,2f274f3..0000000
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@@ -275,7 -275,10 +275,7 @@@ int irq_alloc_domain_generic_chips(stru
  	if (d->gc)
  		return -EBUSY;
 =20
- 	numchips =3D d->revmap_size / irqs_per_chip;
 -	if (d->revmap_type !=3D IRQ_DOMAIN_MAP_LINEAR)
 -		return -EINVAL;
 -
 -	numchips =3D DIV_ROUND_UP(d->revmap_data.linear.size, irqs_per_chip);
++	numchips =3D DIV_ROUND_UP(d->revmap_size, irqs_per_chip);
  	if (!numchips)
  		return -EINVAL;
 =20

--Signature=_Tue__9_Jul_2013_14_36_00_+1000_QmLtM+TxMSXe+E7m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR25M1AAoJEECxmPOUX5FEbPUP/AhZLAZ+60O0ffnH7pnEbr1R
sOZcfmyXXwiCk5Ng37Lf1hw1fchl0DOF0RbG4eumME9OUvXFKEEq+4JGwLPva3kE
+Fk//+8NUd5EBR+PrTLSFK8MqRnNboSD7+MqdXeK8+tCaGgCV5zu05r1epXMp4Q4
F3UmfQGYBN1A1VYkW3Jwu822RqJhL08i63ax1iAgIsBX4g4+7UqzHyPJvVjArqqw
G/18kc0j30aKxoJSYfr27mT5as922TTYtUW5Ga+JFymD73syVuXYqFKu7b9dEuyg
PkifbH3fAyd4pHBERKfpvEpkIExrmrXnxktmw+bvuU7mzWANlUqjuJeXE4HuxpjW
KQbldOCrg86Bg/ZnLP5SibHo87r94cGSUXKq45oovWp7Ln5T6JmZy5mypmkR6U82
jMWqPeVAzTPybOreer3VHKU/TYDql+1l+HlV461dYJptsRBIFki/Bl34pKpZ19AJ
vQHzp7sFElrPHNceodPRfem7KQi6VNFO1sTbUiUS/aUAJ3ruDehVsx0CocQSZqom
ep1nq/f8N78tu986YYZB1qSwPhMdsPzyRa7xCtQ7DwB27kmLjVEBVuDNsNwtKHjf
VflGiapFK4xr9LjHdfZ8vQ9TOOtVRKX00pQGTohD9RyNZsPk+eSzjoOj4mcSYOTC
V7+Zvblj6pLEGscq6bRL
=uBKT
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jul_2013_14_36_00_+1000_QmLtM+TxMSXe+E7m--
