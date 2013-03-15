Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3COOae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 10:30:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55448 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754771Ab3COOad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:30:33 -0400
Date: Fri, 15 Mar 2013 16:30:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH 2/4] usb: musb: gadget: do *unmap_dma_buffer* only for
 valid DMA addr
Message-ID: <20130315143023.GB23930@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363354132-27523-1-git-send-email-kishon@ti.com>
 <1363354132-27523-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <1363354132-27523-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 15, 2013 at 06:58:50PM +0530, Kishon Vijay Abraham I wrote:
> musb does not use DMA buffer for ep0 but it uses the same giveback
> function *musb_g_giveback* for all endpoints (*musb_g_ep0_giveback* calls
> *musb_g_giveback*). So for ep0 case request.dma will be '0'
> and will result in kernel OOPS if tried to *unmap_dma_buffer* for request=
s in
> ep0. Fixed it by doing *unmap_dma_buffer* only for valid DMA addr.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/musb/musb_gadget.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadge=
t.c
> index c454375..ec3cf29 100644
> --- a/drivers/usb/musb/musb_gadget.c
> +++ b/drivers/usb/musb/musb_gadget.c
> @@ -107,7 +107,10 @@ __acquires(ep->musb->lock)
> =20
>  	ep->busy =3D 1;
>  	spin_unlock(&musb->lock);
> -	unmap_dma_buffer(req, musb);
> +
> +	if (request->dma)

I have changed to if (!dma_mapping_error(request->dma)), is it alright ?

--=20
balbi

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQzB/AAoJEIaOsuA1yqREFvMQAKEXjKgh7XGRRfzvKeGI5nZd
f+n3tTFpOyUN4weTsvafIofY0mqbiEuQSN6iPcOKz1mPnfJemXTlmLLSNNR/tMO+
tok6MKEkPFrFeaoDHJyLdestQDFfMDMR7y2TwntoZXLiKkGxrW72WMkRG/p/931T
WH2mG64OpxDjKHQrngTG9fF39zPBAQjGGSD0laYT2lWg1RL0b7tEqMMLmP9xN4tm
gMG6Ka+Su64odhcqLoyHZNVoD5vkCCXNiGoXi7heZY5IQ/uNqTjMHA4mhQaHD6A0
18mM2QmGfbo0lZbpwwLc4fQ2pxGv8ceD4cubnlmZj7oGMfQ2yZPaDhuRdncrlLf7
MqdzBQUxFjp+M34+S4RThJM0ZlmMQyBjbOHviMcEYIdAgImPc8BVrx2iiFqyoMWl
5XpIi22s+eGaS9VIiO1gKDojnH9nVAQHV8DslfLzkVJVmoRrcPIeIu7lwI24vCCT
9MejX1yHoGtvpGN8oTErlTzrzS/Ph5uBloohXi7n9Ebm5E8nLpSOLqI4YxDJQKsI
RO/39K1/u7nGV563049PJOZ8BMhqaxetYxL0esZqVMMjtkUPleTNjYmNtwXeEPbi
ONoMTesJJIODzeImifZdrkliuxhL26Ldkngl7MRrxNaUEqDJPQwaMavq28wgyIUk
55czBhehZELNO0w9RNkr
=1tik
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
