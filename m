Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3DVD1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 23:27:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35133 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab3DVD1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 23:27:17 -0400
Date: Mon, 22 Apr 2013 13:27:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>
Subject: linux-next: build failure after merge of the net-next tree
Message-Id: <20130422132702.ae3555302ac9025d3773e6e3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Apr_2013_13_27_02_+1000_HUFp1U2AH1HIBibL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Apr_2013_13_27_02_+1000_HUFp1U2AH1HIBibL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'ehea_proc_rwqes':
drivers/net/ethernet/ibm/ehea/ehea_main.c:728:5: error: too few arguments t=
o function '__vlan_hwaccel_put_tag'
include/linux/if_vlan.h:237:31: note: declared here

Caused by commit 86a9bad3ab6b ("net: vlan: add protocol argument to
packet tagging functions").  Grep is your friend.  :-(

drivers/net/ethernet/ibm/ehea/ehea_main.c: In function 'ehea_setup_single_p=
ort':
drivers/net/ethernet/ibm/ehea/ehea_main.c:3027:9: error: expected expressio=
n before '|' token

Caused by commit f646968f8f7c ("net: vlan: rename NETIF_F_HW_VLAN_*
feature flags to NETIF_F_HW_VLAN_CTAG_*").

I have used the net-net tree from next-20130419 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__22_Apr_2013_13_27_02_+1000_HUFp1U2AH1HIBibL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRdK4GAAoJEECxmPOUX5FE/0kP/32Eo0Fn046kCx4vq28sFqJZ
4lUu5ENJ0G4Y5meR3GPv5+NqNrkcD1x24GPhKeu/IoSLjy/DG1DEqa5YVu5A2Dje
kYmPu7u3xvRCmy72V26FS360QHgDM2LWd8860uxejN9L8DAedKilyFk0l+ZDY/hF
T1EcR01ZjCYAAh81x+ZyKxIqmk4C+Kqxut5CVssa45rrT6lyZdjhPRJmwn5ynpKG
rNOhCM0lGsyn2idTm47y1K9yK5WJ4pZfsaOitfISdmsz13tL4d13youlHu0PfIZ5
d/eFNzN13tO9a1ja1zpfvWJ+uFK8yD/yNEXgj2PJgodHzog/IBJzZZovO0/OjMzP
dez9k8UjN1l0AcjIWEJP/ER1dKd3B+h0p0zU7dPcM9wRbVjAaliW1fdZKMNs48Ly
QGhjpsU6+hJzFKhC+uLcfzkk3JRYfM3kQkU/WrKljU+MLv5ZgZbWEkGnUkI09xUR
ILPdlTVDyphFojusZm0kgyNZQM1Hdq8F7+8P5Um/TnlxJbWRcGqrjyoCsdWy+u1C
s8DB0eE+EshafABSAhFq2iLglCNLWAXnd/CFN3SmFZm53IvcniHbcL26ndlJ2Fgy
vQ8Mj60wShrmyT8rXTyvDzh6Hl8LPC9yxEBvG2tqV/srwIsEMMLisbVbKGDe605A
sO7tq5tR+kZM8Nzf3RDa
=bQIU
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Apr_2013_13_27_02_+1000_HUFp1U2AH1HIBibL--
