Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3HMGOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:14:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52640 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3HMGOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:14:07 -0400
Date: Tue, 13 Aug 2013 16:13:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: linux-next: manual merge of the usb tree with the net-next tree
Message-Id: <20130813161359.0613bddf9bbf983253333f30@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Aug_2013_16_13_59_+1000_q2NBtoo=EXcmLy5y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Aug_2013_16_13_59_+1000_q2NBtoo=EXcmLy5y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
include/linux/usb/usbnet.h between commit a88c32ae15f2 ("USBNET:
centralize computing of max rx/tx qlen") from the net-next tree and
commit 638c5115a794 ("USBNET: support DMA SG") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/usb/usbnet.h
index 8fbc008,2b47e63..0000000
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@@ -34,7 -34,7 +34,8 @@@ struct usbnet=20
  	struct mutex		phy_mutex;
  	unsigned char		suspend_count;
  	unsigned char		pkt_cnt, pkt_err;
 +	unsigned short		rx_qlen, tx_qlen;
+ 	unsigned		can_dma_sg:1;
 =20
  	/* i/o info: pipes etc */
  	unsigned		in, out;

--Signature=_Tue__13_Aug_2013_16_13_59_+1000_q2NBtoo=EXcmLy5y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCc6rAAoJEECxmPOUX5FE2ukP/jGIGxaMvyFbQ1WgLw57jIcq
xM70s2Yp0kK8MOOcfWjUA8f2EV/e2B3vDmNH8bRd9+rpJNqB10JgWNSoQTC6H4Jv
aQsrD6PpOUWVOfxOanmjBSDOCLriYWyqqIAtvhPaJxLMZc++yQx+mCizfCqz6OJd
+vw2JkCr1Wghmhs2ZYwgkU3aRjBaZyNf0z8Ex8K0l9rvK3C6FQSftTFZjVq4tYGa
4uBc9dtV4H8NjqZQsDuntlScqY/LlV5zEvQv5gaFm7DUzCyDpRKgdc6CFCooEfn3
xkmOArnPdZtXoC95Sy9r4x8onrHUCsAb17mBOxVD2OJ0fB+RsnAPp8thveSOsFRs
3G7sOnOXjMTIX3wN4yWtMZOppkm/aqWuqLTNlEwjIoyMMWeov4Cvg2XwPdCS2Aum
aXOHE6Qq6B8rckSPy/V6GKwjlUPd+mFa7s7lD2hdHC7McNTUfRmPcSDKf+c8eiWy
AfrLrgCtjGI0Xc5t2jYpFovowByrz7C/SZ9o2rhUTcyF/Q2/KX/Q6zzJuLlRiVrn
PcbFv929l40vSW/D7bu8aHRuMTdhUWdG+VRJqt7/M+Im3RL7fkr1cjYYClIQKh04
Hr5vZFhoD5beeHs1U3yLSs2164p3uLtBHoMBNoeEw1jycgfNXUhuwJwwogo83eQ2
tM2tp6+tbtSn61KVjRvq
=e0S0
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Aug_2013_16_13_59_+1000_q2NBtoo=EXcmLy5y--
