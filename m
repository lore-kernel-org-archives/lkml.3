Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaDQBe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 21:34:27 -0400
Received: from ozlabs.org ([103.22.144.67]:36381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455AbaDQBeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 21:34:25 -0400
Date: Thu, 17 Apr 2014 11:34:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: linux-next: manual merge of the ipsec tree with Linus' tree
Message-Id: <20140417113415.62f5b5ef44784891c087def9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Apr_2014_11_34_15_+1000_jX6fd5l0Q0Tie54U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Apr_2014_11_34_15_+1000_jX6fd5l0Q0Tie54U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steffen,

Today's linux-next merge of the ipsec tree got a conflict in
net/ipv4/ip_vti.c between commit 8d89dcdf80d8 ("vti: don't allow to add
the same tunnel twice") from Linus' tree and commit a32452366b72 ("vti4:
Don't count header length twice") from the ipsec tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/ipv4/ip_vti.c
index afcee51b90ed,cd62596e9a87..000000000000
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@@ -349,7 -348,7 +349,6 @@@ static int vti_tunnel_init(struct net_d
  	memcpy(dev->dev_addr, &iph->saddr, 4);
  	memcpy(dev->broadcast, &iph->daddr, 4);
 =20
- 	dev->hard_header_len	=3D LL_MAX_HEADER + sizeof(struct iphdr);
 -	dev->type		=3D ARPHRD_TUNNEL;
  	dev->mtu		=3D ETH_DATA_LEN;
  	dev->flags		=3D IFF_NOARP;
  	dev->iflink		=3D 0;

--Signature=_Thu__17_Apr_2014_11_34_15_+1000_jX6fd5l0Q0Tie54U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTy+dAAoJEMDTa8Ir7ZwVbzkQAIyGIIzzzHLrjSQEXIwTyA9Q
xVvrS7fWyXyQd57/Mln6GGVvALQVeExKIHjkV8fAhRo9HkOyHnhbR95hd9/havJ+
qAN4N+4lPaCjOc6d60HmEFAm5PHnjwyuanvziVGygTxzbTKkiSS78igfYPEHJ6p6
E7oNWoh2TG5jfySwt6VUvkur2u+E1nNc24j/BLSBLmK85CzGyJalEUVNfgGWEwSR
9/jtzi/T9m7AlNIV206ePEFIv1ADef8X3oRGxOOvqJpDvZTJL2nDIEvNrtimSRr0
LoKR3EjWgVZArM65pAaR2ZhkQtVE28sGJbb0yKHTfz+IxZJYPUGDIPXIvnhxQCeW
/raTUnOtF5HucykxZUy3Bechv7R0b9pwYngrAXUypnJcyq7ME4Q+iP15Qv51vu9X
12tSrrySVkpGDSEnG1KIVuv4Ss8GhJIcqx31yUPIBEJwAC9wWqT1v+srmPaHKuV+
n4aUkx9TYI+rrr7ebD22gZNcGzfanrWf+LCT6XxzjUJfoG3s43+CcpS0yDr4g4Sl
HYL1FIc3PruTzHSV5FuSnFxkWtGw/UGJMQszm2jC2xQH/m964k04mzegoQjAkCyO
1IAai6vshwv4ku0NbYSDh6kXsD0R1cy8h2eP/bxg0OrsVYckEW6gZZ8T+tPgQkbN
jRvzCQvrTA+LtRIfP/zN
=5ENa
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Apr_2014_11_34_15_+1000_jX6fd5l0Q0Tie54U--
