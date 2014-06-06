Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaFFDpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 23:45:55 -0400
Received: from ozlabs.org ([103.22.144.67]:41035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbaFFDpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 23:45:54 -0400
Date: Fri, 6 Jun 2014 13:45:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zoltan Kiss <zoltan.kiss@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        "Andrew J. Bennieston" <andrew.bennieston@citrix.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20140606134547.7efed8a0@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/YHucQCCqC3ys5Xyt/XyZ8KS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YHucQCCqC3ys5Xyt/XyZ8KS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
drivers/net/xen-netback/netback.c between commit 59ae9fc67007
("xen-netback: Fix handling of skbs requiring too many slots") from the
net tree and commit e9ce7cb6b107 ("xen-netback: Factor queue-specific
data into queue struct") from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/xen-netback/netback.c
index a160b4ef5ba0,49efff9b99f4..000000000000
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@@ -556,12 -548,18 +563,12 @@@ static void xenvif_add_frag_responses(s
  	}
  }
 =20
- void xenvif_kick_thread(struct xenvif *vif)
 -struct xenvif_rx_cb {
 -	int meta_slots_used;
 -};
 -
 -#define XENVIF_RX_CB(skb) ((struct xenvif_rx_cb *)(skb)->cb)
 -
+ void xenvif_kick_thread(struct xenvif_queue *queue)
  {
- 	wake_up(&vif->wq);
+ 	wake_up(&queue->wq);
  }
 =20
- static void xenvif_rx_action(struct xenvif *vif)
+ static void xenvif_rx_action(struct xenvif_queue *queue)
  {
  	s8 status;
  	u16 flags;

--Sig_/YHucQCCqC3ys5Xyt/XyZ8KS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTkTlvAAoJEMDTa8Ir7ZwVt6IQAJQc/o54dMJALj7j3ZzKF2L6
BPtPjUs1YX5nSgX9pK0xHw0cZ1GOgE8i255uABFqU79EXFvE0KN2IBgQKH+UPAsm
NvwNMxJlycaqGwTM6P88hsw/IIQF0lUXZyz2iFC6vLIdXqQ6F1W60ZJLSUJNFd5b
e7AXmNRXd1k8QJD0mUoTEOfPKgburpR292dC4ddL+0mrueorslPeGfPGnWmZRzKN
5TxPqfOB89PTc7Sj0n1QBC2Blww9zScV68b+7VFtZqtpnFXWazQGxIJ+NyDM6BHI
VqRLlezUxkKFeW0/0VrXLPwmffgKLUhs1vebYhgjA+hC8NYw9D+xwH8Z7dx+q97T
AhWzCboFXhtCXZStiGG4UG4Tl7CtoanpVvZ4voN197EfrFW1tT4KQJJzYjSP2fkw
Ke9gGCUsVUT5SrL12cWuFynBQrjfK60HRjGzbykpHXx//pUZGgPp/FicwBp0jdpW
KPLrnYZxcCWrNj0xfUjvJZJyVnwG47sZaW6z4ZEz9tpOqw7IzlfvTV3GlXmxtTje
plqjqOK58zGRoO39d9aKetQRZQ/XXRM8CFzcu2zSL1Mrd7qNj29Cz1MAKaEMJbRK
3enzdLqiTS+0V0i1DEaYQI/6q4di6a2cEOgEZWQJS83e9pYB8IuMQmc6gx6090y0
kvOrtfmoglKLWPPVdFCV
=apKh
-----END PGP SIGNATURE-----

--Sig_/YHucQCCqC3ys5Xyt/XyZ8KS--
