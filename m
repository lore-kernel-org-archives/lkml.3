Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3HMFnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:43:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46837 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3HMFns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:43:48 -0400
Date: Tue, 13 Aug 2013 15:43:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: linux-next: manual merge of the tty tree with the tile tree
Message-Id: <20130813154346.fb2e52f791fb6e2e3e2fbfcc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Aug_2013_15_43_46_+1000_=DCbKSS.NfcdotNm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Aug_2013_15_43_46_+1000_=DCbKSS.NfcdotNm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
include/uapi/linux/serial_core.h between commit 002abee2d681 ("tilegx:
Add tty serial support for TILE-Gx on-chip UART") from the tile tree and
commit c4b058560762 ("serial:st-asc: Add ST ASC driver") from the tty
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/uapi/linux/serial_core.h
index b466487,e40ebe1..0000000
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@@ -232,7 -232,7 +232,10 @@@
  /* SH-SCI */
  #define PORT_HSCIF	104
 =20
 +/* Tilera TILE-Gx UART */
 +#define PORT_TILEGX	105
 +
+ /* ST ASC type numbers */
 -#define PORT_ASC       105
++#define PORT_ASC       106
+=20
  #endif /* _UAPILINUX_SERIAL_CORE_H */

--Signature=_Tue__13_Aug_2013_15_43_46_+1000_=DCbKSS.NfcdotNm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCceSAAoJEECxmPOUX5FE5FQP/jbxBDprazepjGdJ3IqQxSqH
l4H2tXb2TcpwGAhiBy/+6QZx5e1YfKr2lP4As/wjU/NFymajYq3e1cFxZFBYi8Lh
Jkq4SRkGjz9VSOaymxq940bXFcACMnWUmkfuZMxIyaO1mb54dD09GBgFmtm5+hU1
Kr9Blwoeo+yXnK2hLxyZLw3nHd7JdPR71Ec4XMncQzm7mPuVWFiCIYjXlgv89II1
+B0zOfJJnnYM/EMd5MPXDte/ijk8BMryNxUTy2vBrqvaUBlQR6+GUUjA26I0MJoO
m5ZNDk50g2Z38ezT6ob6kisVytzTZDmuKg9filR6So3gbb55W7gDfEuCwHUaBFTl
kg7cwFs1/TE5y2ssss8LsjtoyrfS8ViYH+V6hZw5Phx7Ia4hCf2ujGTT81gLx2GM
LhaqaldAyqA1U8l+K8BwPE1r8b94EuvsahaSvBfZD9m+3IYziWkglzDV+kmdzj42
Tn9TJ/d789mulWHh/U/NbioH5y60hFZAcb0G+gpgm5s4FVKAWT1URj9z8+qmU/jI
uEciwYM0/k8q/njsttcSVRHBEHAWiZRu8zVtVdCwzisjRn6RwpokZs5ZA2zuD/2l
f4Wz9U9SkFOcfYJCVgE+qoUYlvj8fXvWe0k3QFV65Svc7pa+u8olLhMLIYZ3Dzbt
8UURrQTcf45gO2XOl9yL
=k9Kq
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Aug_2013_15_43_46_+1000_=DCbKSS.NfcdotNm--
