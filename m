Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3FZI03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:26:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43908 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3FZI01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:26:27 -0400
Date: Wed, 26 Jun 2013 11:26:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Ravi Babu <ravibabu@ti.com>
CC: <linux-usb@vger.kernel.org>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/3] usb: musb: core: added babble recovery func-ptr
 to musb->ops
Message-ID: <20130626082620.GN12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
 <1369832824-29071-3-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tuFXEhzhBeitrIAu"
Content-Disposition: inline
In-Reply-To: <1369832824-29071-3-git-send-email-ravibabu@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tuFXEhzhBeitrIAu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 29, 2013 at 06:37:03PM +0530, Ravi Babu wrote:
> Adding babble_recovery operation as part of musb->ops, used
> to recover from babble condition during babble interrupt.
>=20
> Signed-off-by: Ravi Babu <ravibabu@ti.com>
> ---
>  drivers/usb/musb/musb_core.c |    6 ++++++
>  drivers/usb/musb/musb_core.h |    7 +++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
> index ab6fa39..411c29d 100644
> --- a/drivers/usb/musb/musb_core.c
> +++ b/drivers/usb/musb/musb_core.c
> @@ -857,6 +857,12 @@ b_host:
>  		}
>  	}
> =20
> +	/* handle babble condition */
> +	if (int_usb & MUSB_INTR_BABBLE) {
> +		pr_info("babble: restarting the musb controller..");
> +		musb_babble_recovery(musb);
> +	}
> +
>  #if 0
>  /* REVISIT ... this would be for multiplexing periodic endpoints, or
>   * supporting transfer phasing to prevent exceeding ISO bandwidth
> diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
> index f96e899..bf37dc9 100644
> --- a/drivers/usb/musb/musb_core.h
> +++ b/drivers/usb/musb/musb_core.h
> @@ -213,6 +213,8 @@ struct musb_platform_ops {
>  	int	(*adjust_channel_params)(struct dma_channel *channel,
>  				u16 packet_sz, u8 *mode,
>  				dma_addr_t *dma_addr, u32 *len);
> +
> +	void	(*babble_recovery)(struct musb *musb);

I don't get why can't 'babble_recovery' be generic. Why do we need each
glue layer to implement it ?

--=20
balbi

--tuFXEhzhBeitrIAu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyqWsAAoJEIaOsuA1yqREj10P/1h5hNhaOh8abdZudOId0WDh
jPI87Xdmf1cDC6WAxjJ4UAQsDURVIImlYwZ3dTqGb+8I+OSP7GFZwrLrUP4TICP6
0q7d+aXQaA0HqYXAtZpd/bvZvfwEz8QYbgtX3cm08SCCoYa1Uj6mPVA1lTAvVIui
66rV/AW0LKQdhYzj/HaLG/JeAssttP7tfVJ5ilD1mDBGyAikeJ/+oVxfiOXaOs7M
38EHsHo3GX7CDNr6IAe5MVbMeHp7P86HkaL+50QQFpksWSlGOf2sN8TdijHNWU4+
QBNgsz0IR0EvASviZ1nis0WIYXaAA4vT/Cs3tP5vfCy4k8loneRsNClhPo69onhN
XlOvX5nalbIsdJa689mywBOt7wIOA3N+sk5ooGNggzvQ1jsO1HEVKQXCjoXk8rb9
Z57zwJatoHgRCLLMeezr+pmXeD6jLSDqdVVLuVIuqhFa3cUhVwonJUJRtbySo24T
0YsBo6NjIaOvZ27FRCHDmoBVZwbVnB38sxyYdwIuPUsDZYnpc31v36eT+qhPFEKX
DtKCCbQWjUC2Gd14WTN4JpPmDJ//1Xg4EkFuMnuls99Zh8my5xOmkELU7YVPyX07
wwXdUSg7kIU4i+43kyg4AO77WVBMv/xOo7y2HZnplNZi+2VFfPe3ph6Xul7FSz2t
Su/dxbmKmniUqMEr9u8K
=3IoT
-----END PGP SIGNATURE-----

--tuFXEhzhBeitrIAu--
