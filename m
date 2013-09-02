Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab3IBDkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 23:40:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44316 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab3IBDkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 23:40:45 -0400
Date: Mon, 2 Sep 2013 13:40:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fan Du <fan.du@windriver.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: linux-next: manual merge of the ipsec-next tree with Linus' tree
Message-Id: <20130902134036.94e1a4c9d6b2453dd99d4100@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Sep_2013_13_40_36_+1000__B/wI3fmgtJDqFLn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Sep_2013_13_40_36_+1000__B/wI3fmgtJDqFLn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steffen,

Today's linux-next merge of the ipsec-next tree got a conflict in
include/net/xfrm.h between commit 628e341f319f ("xfrm: make local error
reporting more robust") from Linus' tree and commit aba826958830
("{ipv4,xfrm}: Introduce xfrm_tunnel_notifier for xfrm tunnel mode
callback") from the ipsec-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/net/xfrm.h
index e253bf0,c7afa6e..0000000
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@@ -1499,9 -1501,8 +1505,9 @@@ extern int xfrm4_output(struct sk_buff=20
  extern int xfrm4_output_finish(struct sk_buff *skb);
  extern int xfrm4_tunnel_register(struct xfrm_tunnel *handler, unsigned sh=
ort family);
  extern int xfrm4_tunnel_deregister(struct xfrm_tunnel *handler, unsigned =
short family);
- extern int xfrm4_mode_tunnel_input_register(struct xfrm_tunnel *handler);
- extern int xfrm4_mode_tunnel_input_deregister(struct xfrm_tunnel *handler=
);
+ extern int xfrm4_mode_tunnel_input_register(struct xfrm_tunnel_notifier *=
handler);
+ extern int xfrm4_mode_tunnel_input_deregister(struct xfrm_tunnel_notifier=
 *handler);
 +extern void xfrm4_local_error(struct sk_buff *skb, u32 mtu);
  extern int xfrm6_extract_header(struct sk_buff *skb);
  extern int xfrm6_extract_input(struct xfrm_state *x, struct sk_buff *skb);
  extern int xfrm6_rcv_spi(struct sk_buff *skb, int nexthdr, __be32 spi);

--Signature=_Mon__2_Sep_2013_13_40_36_+1000__B/wI3fmgtJDqFLn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJAi4AAoJEECxmPOUX5FEI+MP/0KWu2zhR0TRSDbFh1F50E63
r/izeB2MuJ+i2ABwqXvIOvSfM1z7GXRxMqdRUnl7Fa5PD3iinJzcJvhCThSfXynV
Qp2nGFhmO766gaxGJ3sv+0uu1h7naHDDWOTFb1WAbBNfOZ3xUcTE1cxjC4tG3lB1
VGxcSh7AvJ3njIFhg3vIz48sTFlqWaQELqTamK74Q7szE54oi37WKbz+XYKT5aAE
CQjtiqxAzY4kXiScq8pe12jm41V+lAGwgSM+VRsqDYEkevfMQdCFUolZzArt5TqX
rhI9qiTkZHibp96T34lVffHP/h+Z5DwfHL8aUEWvPk27HHG3U2SBnxY8rbIW/emP
tVy1XDadwonz7/unCFnnnXRrhrcWUNorOEsvWrwEXNL+54qDXB404vjCKNU/2KEk
k8ZAl6pGL1V+7oxhVGsleMgMTAMYeHqlEz6fdLrs3MsshI9Mj9LLXDdnFkZoJ934
ev2zY+zWVMEifJ6ZiZhiEBSfdqkDvMr2+8DWgv2HqzgpPS84gABqkR6eXwYiigI5
dObwtzAlPBpuRfpRxDWU1rmUKNnPi6ZkpG+w/Wb4AJAXbYLpPhLEr/+FSvuxYPTZ
MxdiCV2vIH2asNTGWJ9+jqOL9/72DzsblDl8fc1yThPiPO6mWdijgO/9ianGnNYi
FGF1iiAIIJQcaO0AGAZZ
=IK2W
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Sep_2013_13_40_36_+1000__B/wI3fmgtJDqFLn--
