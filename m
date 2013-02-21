Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab3BUWw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:52:57 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48220 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758793Ab3BUWwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:52:54 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: gadget: composite: Allow idVendor and other module_params to be writable
In-Reply-To: <1361485647-9439-1-git-send-email-john.stultz@linaro.org>
Organization: http://mina86.com/
References: <1361485647-9439-1-git-send-email-john.stultz@linaro.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 21 Feb 2013 23:52:44 +0100
Message-ID: <xa1tvc9lnutf.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21 2013, John Stultz wrote:
> In many cases, documentation around composite drivers suggest
> setting the idVendor and other module params as follows:
>
> $ insmod g_ffs.ko idVendor=3D<ID> iSerialNumber=3D<string>
>
> However, this won't work if the driver is not compiled in as a
> module, as the module_param permissions are S_IRUGO.
>
> Thus this patch changes the composite module_param permissions
> to S_IRUGO|S_IWUSR to allow the module_params to be set at
> runtime via /sys/modules/<driver>/parameters/

If the driver is not compiled as a module, setting those variables won't
work anyway.  Or am I missing something?

You can, however, pass them on Linux command line (with some prefix
which I can never remember).

If you want to configure things at run-time without having to compile
stuff as modules, you need to wait for the configfs based gadgets.

> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  include/linux/usb/composite.h |   16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
> index b09c37e..22b1b02 100644
> --- a/include/linux/usb/composite.h
> +++ b/include/linux/usb/composite.h
> @@ -399,24 +399,28 @@ struct usb_composite_overwrite {
>  #define USB_GADGET_COMPOSITE_OPTIONS()					\
>  	static struct usb_composite_overwrite coverwrite;		\
>  									\
> -	module_param_named(idVendor, coverwrite.idVendor, ushort, S_IRUGO); \
> +	module_param_named(idVendor, coverwrite.idVendor, ushort,	\
> +			S_IRUGO|S_IWUSR);				\
>  	MODULE_PARM_DESC(idVendor, "USB Vendor ID");			\
>  									\
> -	module_param_named(idProduct, coverwrite.idProduct, ushort, S_IRUGO); \
> +	module_param_named(idProduct, coverwrite.idProduct, ushort,	\
> +			S_IRUGO|S_IWUSR);				\
>  	MODULE_PARM_DESC(idProduct, "USB Product ID");			\
>  									\
> -	module_param_named(bcdDevice, coverwrite.bcdDevice, ushort, S_IRUGO); \
> +	module_param_named(bcdDevice, coverwrite.bcdDevice, ushort,	\
> +			S_IRUGO|S_IWUSR);				\
>  	MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");	\
>  									\
>  	module_param_named(iSerialNumber, coverwrite.serial_number, charp, \
> -			S_IRUGO); \
> +			S_IRUGO|S_IWUSR);				\
>  	MODULE_PARM_DESC(iSerialNumber, "SerialNumber string");		\
>  									\
>  	module_param_named(iManufacturer, coverwrite.manufacturer, charp, \
> -			S_IRUGO); \
> +			S_IRUGO|S_IWUSR);				\
>  	MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");	\
>  									\
> -	module_param_named(iProduct, coverwrite.product, charp, S_IRUGO); \
> +	module_param_named(iProduct, coverwrite.product, charp,		\
> +			S_IRUGO|S_IWUSR);				\
>  	MODULE_PARM_DESC(iProduct, "USB Product string")
>=20=20
>  void usb_composite_overwrite_options(struct usb_composite_dev *cdev,
> --=20
> 1.7.10.4
>

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

iQIcBAEBAgAGBQJRJqU8AAoJECBgQBJQdR/0ln0P/35/hv8pxdTVzLVyAz7rWDtE
T6ZyLPIazZXlhcr7FBGlk82oycstiLC45G3MfLjP1pqvbvTYMzizXvPB5s1eHqYO
h+Xc/3e5oMJhiOls41me5j+3dZo3cO1wlX1UDY1zzyN3ffqquD1apU0LK/vkz7Gc
YaVYeMXP+DHMbHDKrXcSYLR1PK9hujaRUN5oSLJI+fjGvesXwdwWBX14HZkJofBz
MUw5Bjhx9a9KtxjyVlIzlmX8CGBE5dE7/lBYm3I8+cDhz8pfNF32OPFicO52bXYg
0rJ+up3WIvDv2N97vAq3qpy2qYCDm3WAqpxgBuvdp9O+EnYyRGjzngEGZPLEzZ1g
sxJkoM4ZW50OT/509j24Pphsh2Vmqe2g5nO1wL/ptnl2cjopUs43xiPz2984OWh0
26NcfRsP3+ji6vOlUPRYbWr7xMJ5vJcBZbKorGQOPJH7pUChEf0np2VVaQidsAWv
wBDIMs8aZAiUbJbRUUpuIoR8xdnwPeMXhP608Y3tDJRpQegIS3bUIaeOFsBP60y2
as7LIP+IBtVdMm1jp0rE9gFU828VYlX8AIS5ZOOubxwtl+ChtK4APKdbaqiKrwnb
1qo3QwCgGnnGFWr4dyDOwaN39BlZTMafzeOOSxG+vaa4YO+hCEXgrkwymf93bhwG
+iONQ23N1xKbH/DAS5NE
=nTfh
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
