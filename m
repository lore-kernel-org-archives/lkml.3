Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3HBHrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:47:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40064 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3HBHri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:47:38 -0400
Date: Fri, 2 Aug 2013 10:46:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] usb: gadget: at91_udc: add usb_clk for transition to
 common clk framework
Message-ID: <20130802074657.GI24465@radagast>
Reply-To: <balbi@ti.com>
References: <1375376870-22747-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lCXDTVICvIQMz0h"
Content-Disposition: inline
In-Reply-To: <1375376870-22747-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6lCXDTVICvIQMz0h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 01, 2013 at 07:07:50PM +0200, Boris BREZILLON wrote:
> @@ -1851,6 +1860,12 @@ fail3:
>  fail2:
>  	free_irq(udc->udp_irq, udc);
>  fail1:
> +	if (IS_ENABLED(CONFIG_COMMON_CLK) && !IS_ERR(udc->uclk))
> +		clk_put(udc->uclk);
> +	if (!IS_ERR(udc->fclk))
> +		clk_put(udc->fclk);
> +	if (!IS_ERR(udc->iclk))
> +		clk_put(udc->iclk);

adding missing clk_put() for iclk and fclk should be part of a separate
patch. Please split this part.

--=20
balbi

--6lCXDTVICvIQMz0h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR+2PxAAoJEIaOsuA1yqREPcsP/0SXP2TsSFN0Wsw5Yz5ct6CZ
8EyBMUR5UbYyQxe8DHLVpsCq6C9VxXYjiK8LfXDqbAbHDZJhb3/it2dcTQC4+lYq
VevOwnnfVyJZntgxehGkmZsZupoUC62pN0VnST0oXQI42KtRKKZw7XyfcGT/cMk8
1nuXzLvQ/HBLZ+7jVpt2ZGshvZgSUjRKeMuimVplo4Ky1Yo2SMsUlgEKEW0FPdbR
oYdW3bExSVE5szFmp5ofIwZGmt9QqZZMVg5E6qAe1l6gRqf3MPa08kh3kV93KdLo
2Ut0UDbahwMyXGrnvREbyMFjDQm3U1TPzgcsglkaP22yDR5cP96yL+NQZ+1v//Im
0GKN3T4zFFPdtpq5Zt1IFZA0+EPwFk80sVcdzkLZ2NvkKrKgEnqFgDEnliy0iRLo
rS4zkMJEpJmsTIJ4UtabLHk1WxLu4d5yU2MmQnaTZ8FBo5d6hblLBmQuISM31gUh
sIjdQwtxb7RNMVeOpnbrfagG5NOFx6y6lxZew5I9mynXSoZxln2PeAZ5gLwnp4Bk
FyjZeTZjDuBR38GHKl45bX0mRKvHOG2FA3O25uIf8l8gd3z3VTRH7uiBBFIin/32
4qrIdrR1RRgGXAi0VnZLywS96/Fs476RUosP1DnjOh+lUgmyN6cXC9JyNMH+HHC/
C8Hk8QOBl5jcV1PvHYMx
=8ILd
-----END PGP SIGNATURE-----

--6lCXDTVICvIQMz0h--
