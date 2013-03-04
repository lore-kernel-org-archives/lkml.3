Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3CDWkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:40:35 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:41218 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3CDWkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:40:33 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        linux-usb@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH] usb/gadget: initialize gadget functions helper befor functions & gadgets
In-Reply-To: <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
Organization: http://mina86.com/
References: <20130206020424.GB1175@localhost> <1362432489-6325-1-git-send-email-sebastian@breakpoint.cc>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 04 Mar 2013 23:40:25 +0100
Message-ID: <xa1t621623hi.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04 2013, Sebastian Andrzej Siewior wrote:
> Fengguang Wu run into a kernel ops after he complied dummy_hcd and g_cdc
> into the kernel. The problem was that u_serial was used by g_cdc before
> u_serial was initialized. In the module case eveything is initialized in
> the correct order but if we compile it into the kernel we rely on
> Makefile order which I did wrong and now I correct this.
>
> Cc: Fengguang Wu <fengguang.wu@intel.com>

Should that be Reported-by?

> Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
> I kinda assumed that this was already fixed (i.e. a patch like this was s=
ent)
> but it seems not to be that case.
>
>  drivers/usb/gadget/Makefile |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
> index 97a13c3..1ded3d4 100644
> --- a/drivers/usb/gadget/Makefile
> +++ b/drivers/usb/gadget/Makefile
> @@ -35,6 +35,12 @@ mv_udc-y			:=3D mv_udc_core.o
>  obj-$(CONFIG_USB_FUSB300)	+=3D fusb300_udc.o
>  obj-$(CONFIG_USB_MV_U3D)	+=3D mv_u3d_core.o
>=20=20
> +# USB Functions

Should there be a comment explaining why USB functions must be placed
before gadgets?

> +obj-$(CONFIG_USB_U_SERIAL)	+=3D u_serial.o
> +obj-$(CONFIG_USB_F_ACM)		+=3D f_acm.o
> +f_ss_lb-y			:=3D f_loopback.o f_sourcesink.o
> +obj-$(CONFIG_USB_F_SS_LB)	+=3D f_ss_lb.o
> +
>  #
>  # USB gadget drivers
>  #
> @@ -74,9 +80,3 @@ obj-$(CONFIG_USB_G_WEBCAM)	+=3D g_webcam.o
>  obj-$(CONFIG_USB_G_NCM)		+=3D g_ncm.o
>  obj-$(CONFIG_USB_G_ACM_MS)	+=3D g_acm_ms.o
>  obj-$(CONFIG_USB_GADGET_TARGET)	+=3D tcm_usb_gadget.o
> -
> -# USB Functions
> -obj-$(CONFIG_USB_F_ACM)		+=3D f_acm.o
> -f_ss_lb-y			:=3D f_loopback.o f_sourcesink.o
> -obj-$(CONFIG_USB_F_SS_LB)	+=3D f_ss_lb.o
> -obj-$(CONFIG_USB_U_SERIAL)	+=3D u_serial.o



--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJRNSLZAAoJECBgQBJQdR/0jcgP/jvI4eVI2anuf/FVgrIf3ngZ
batTnAMdPDQA9N11MSQL/y+lnGwDy4Yr1HdHLeQ3U9IOEDehx4/9W0Tb43CtFoFV
Ujj2CLwJF7qAViD8RTKtZ3/fWqAf67Vq5U8iehc2JNziiDYyQokISJGAs5G3Ha0r
P0+9YcQEpL8+29Q+Z7YXIg4VuIJsznRdvVzjnX9QxIYDRh8WpsqxhLx7dKH9cibp
7TCwplnOjVMW2iZ0HbWlvdNOODm1flh0RmaTp887PfA2RhwKP0ntgz6NRTwtoHXU
BlrNxcL+cwiVV6ktAVLMIjpI52QcMmSecljRDdavS1D16PIjS0vI/23stp532LzT
Jzy8ELSBQ8fTxHQulafqYBuYHTQqrQT8knM8GloS+StGGYsMHSSOoX2SzUTZFkMY
hifDEiFqos5XhS0s7G2gIBHHNtzNTjkhlHUfCezPxnbsQrdacpP4ej+VrKh+7e/0
toUvJgR1YONP96xPq14E6FZMrYQ7wb+svwXjhPJRiySicjLFrZFXM2jTsj6bzLKj
SF9T/FxFnP7cvh0u0YMZXc45pgrp95oHSYHiPxp4We3N+OuZgjdJJ22cPd75VAde
jCuUUYoAcoE9axc9M6Elr8kE3dlNkrEbs8fBQa/6oUU8QzmG/3NY2nmGLu/xzU9/
xRsAmZBeW+2LOxp4oVE5
=12m1
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
