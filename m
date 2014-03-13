Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaCMP1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:27:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43788 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbaCMP1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:27:12 -0400
Date: Thu, 13 Mar 2014 10:25:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Suresh Gupta <suresh.gupta@freescale.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH] USB: Gadget: fsl driver pullup fix
Message-ID: <20140313152517.GG4599@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394716255-26963-1-git-send-email-suresh.gupta@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9/eUdp+dLtKXvemk"
Content-Disposition: inline
In-Reply-To: <1394716255-26963-1-git-send-email-suresh.gupta@freescale.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--9/eUdp+dLtKXvemk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 13, 2014 at 06:40:55PM +0530, Suresh Gupta wrote:
> Attached is a small fix for the fsl usb gadget driver. This fix the
> driver in a way that the usb device will be only "pulled up" on requests
> like other usb gadget drivers do.
> This is necessary, because the device information is not always
> available until an application is up and running which provides this
> datas.
>=20
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
> ---
>  drivers/usb/gadget/fsl_udc_core.c | 38 +++++++++++++++++++++------------=
-----
>  1 file changed, 21 insertions(+), 17 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_u=
dc_core.c
> index 35cb972..9a93727 100644
> --- a/drivers/usb/gadget/fsl_udc_core.c
> +++ b/drivers/usb/gadget/fsl_udc_core.c
> @@ -153,6 +153,21 @@ static inline void fsl_set_accessors(struct fsl_usb2=
_platform_data *pdata) {}
>  /********************************************************************
>   *	Internal Used Function
>  ********************************************************************/
> +static int can_pullup(struct fsl_udc *udc)
> +{
> +	return udc->driver && udc->softconnect && udc->vbus_active;
> +}
> +
> +static void set_pullup(struct fsl_udc *udc)
> +{
> +	if (can_pullup(udc))
> +		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
> +				&dr_regs->usbcmd);
> +	else
> +		fsl_writel((fsl_readl(&dr_regs->usbcmd) & ~USB_CMD_RUN_STOP),
> +				&dr_regs->usbcmd);
> +}

why is this a "fix", you just re-factored some code into set_pullup().

--=20
balbi

--9/eUdp+dLtKXvemk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTIc3dAAoJEIaOsuA1yqREc8EP/0e/sWw33FwlUbZdUwpIF3TI
dsWrPlxq9Itq7PqtUuqWnaH4vIeyxJfkvfVFBU8eKXwLZjYpbsH9UkS3kqMuRh3+
II24xFWE1nSXbIC+itcd72dvdGaY2W4H3fDGrxyLkqivGB+kmFXYQarlXzcXZ6nt
F4qciapy+cg9uoYheDYswQS+40Ja/b3QEUE3ooAdOvEzS7r3ZF0QRvjRTR8C8nFr
+2VgQGBHBkxCwxhEb3FtlrfJTOhjyRXxbpVbMOXhP25aBIBr7rU2J49z454BSdk6
GDm+67r44MwbjikK7fHp+NCKXfAhdSTfmKqbn0gu662wMijWY5LuJMauYVi+GGap
LLoAiWllOlL+MIkuv5VhZnfpr0m5e6AN2FeQ0HaN5LQJ8p+8RNpKp/KW626mJBbv
rlRICa21foul0j1sYu4Y/T5a10FJjKIk81NvEBZo6NcVARX32XoKnXYmXekW7Z6n
yWJRyW7FcWIjsvdewxbUyEuT3CTurb5iKZKHwTgUVVVzIFrXfec97rihRmTG+s5n
IpqOBXEr7KcXvnhJWm/Vs0hySu/X3y2TZpeXD0yFSNlJWisg77xBeR0/lYl+LrIm
u/f0lqXqjunsIv5TkQ9ov1GEl01gP/gxyVXtySPFt3ilPXoTVjrStt7ZpVn2gBcz
lH39mfWfMAK991yhyxa4
=yLlX
-----END PGP SIGNATURE-----

--9/eUdp+dLtKXvemk--
