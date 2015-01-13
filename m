Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbbAMEGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 23:06:30 -0500
Received: from ozlabs.org ([103.22.144.67]:39067 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbbAMEG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 23:06:28 -0500
Date: Tue, 13 Jan 2015 15:06:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20150113150621.67d395ce@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/JuHi1Gn_ADuhPYK4l/pWOrN"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/JuHi1Gn_ADuhPYK4l/pWOrN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/gadget/udc/bdc/bdc_ep.c between commit f26d29e34e20 ("usb:
gadget: udc: avoid dereference before NULL check in ep_queue") from the
usb.current tree and commit d71b0d7764a7 ("usb: gadget: udc: remove
bogus NULL check") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/udc/bdc/bdc_ep.c
index d4fe8d769bd6,fdc0e9fc39d0..000000000000
--- a/drivers/usb/gadget/udc/bdc/bdc_ep.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_ep.c
@@@ -718,11 -718,10 +718,11 @@@ static int ep_queue(struct bdc_ep *ep,=20
  	struct bdc *bdc;
  	int ret =3D 0;
 =20
- 	if (!req || !ep || !ep->usb_ep.desc)
 -	bdc =3D ep->bdc;
+ 	if (!req || !ep->usb_ep.desc)
  		return -EINVAL;
 =20
 +	bdc =3D ep->bdc;
 +
  	req->usb_req.actual =3D 0;
  	req->usb_req.status =3D -EINPROGRESS;
  	req->epnum =3D ep->ep_num;

--Sig_/JuHi1Gn_ADuhPYK4l/pWOrN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtJnBAAoJEMDTa8Ir7ZwVNB0P/i/nYQEPR3Ap6aVCh0loaI3t
HfuwOhNaQz07nBNcq29d95Tw+ydJ334apNQznLLCPomtG0p0gOQSRf/jdTGIvs3q
cSCIRkneiYPYeBF+K25yj7ixMCM+g+Q7KfD3YDw0ZVGQc5vggzkK7qYVV5Zl3x1p
ER9PKqSOdV/gauYCnrDZiz7H3Hyqg5Qn0ceoOfb/VXerYEYehEE3CVAo6tRhu02z
MyUwYNxOG8eNtLVJB4oaVHtbZTxXFvd2oCloVB/wBnbnxE6WkgAHGzlGc6W/IqHX
T5s+PZLelMSWMA0WZoRztCaCJx8DeA+AZy7bgaS/hC0geQSB8hc3+Gk9rv+HgC5w
1vRmPrtPu3rVi6thEZTwhTnJu1IGg7n/SPEO3AyRfVqHFLga+TvqmlKJOWLOvGUM
TtALD/0xlnZUsuHshpviTQYZXaiBoctbVGJ02IRiu9b8gOci1qieUwqLy06jqitj
sgqwQpx+dwVCE+TDYIaH66p1zCXXeWmpptrj/G1/3JtWpSvzET8Z1hmyzfPttZdC
IbLB949W1rbrilrLd9xOKsCN5/yXbYTPlmFNDVZuL6mDdonHPN/g1Nt/K1IG6INg
0rUJEkpKu7vphzrK5aRHShWAeCYrZesTJsp0NtL+7hO1tynztai8V2P+/nkGn9x1
ZjjhQvBZEhO2CKuYu4zL
=jihR
-----END PGP SIGNATURE-----

--Sig_/JuHi1Gn_ADuhPYK4l/pWOrN--
