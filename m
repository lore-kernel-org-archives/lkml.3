Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3CSNXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:23:09 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43407 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3CSNXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:23:06 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: oskar.andero@sonymobile.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Radovan.Lekanovic@sonymobile.com,
        Truls Bengtsson <truls.bengtsson@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: Re: [RFC PATCHv2 1/1] usb: f_rndis: Avoid to use ERROR macro if cdev can be null
In-Reply-To: <1363691503-15581-2-git-send-email-oskar.andero@sonymobile.com>
Organization: http://mina86.com/
References: <1363691503-15581-1-git-send-email-oskar.andero@sonymobile.com> <1363691503-15581-2-git-send-email-oskar.andero@sonymobile.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Tue, 19 Mar 2013 14:22:56 +0100
Message-ID: <xa1t7gl3a5hr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19 2013, oskar.andero@sonymobile.com wrote:
> The udc_irq service runs the isr_tr_complete_handler which in turn
> "nukes" the endpoints, including a call to rndis_response_complete,
> if appropriate. If the rndis_msg_parser fails here, an error will
> be printed using a dev_err call (through the ERROR() macro).
>
> However, if the usb cable was just disconnected the device (cdev)
> might not be available and will be null. Since the dev_err macro will
> dereference the cdev pointer we get a null pointer exception.
>
> Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> Signed-off-by: Truls Bengtsson <truls.bengtsson@sonymobile.com>
> Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

I think this is the best solution.  Adding if statements around it would
just add noise.

> ---
>  drivers/usb/gadget/f_rndis.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_rndis.c b/drivers/usb/gadget/f_rndis.c
> index 71beeb8..cc9c49c 100644
> --- a/drivers/usb/gadget/f_rndis.c
> +++ b/drivers/usb/gadget/f_rndis.c
> @@ -447,14 +447,13 @@ static void rndis_response_complete(struct usb_ep *=
ep, struct usb_request *req)
>  static void rndis_command_complete(struct usb_ep *ep, struct usb_request=
 *req)
>  {
>  	struct f_rndis			*rndis =3D req->context;
> -	struct usb_composite_dev	*cdev =3D rndis->port.func.config->cdev;
>  	int				status;
>=20=20
>  	/* received RNDIS command from USB_CDC_SEND_ENCAPSULATED_COMMAND */
>  //	spin_lock(&dev->lock);
>  	status =3D rndis_msg_parser(rndis->config, (u8 *) req->buf);
>  	if (status < 0)
> -		ERROR(cdev, "RNDIS command error %d, %d/%d\n",
> +		pr_err("RNDIS command error %d, %d/%d\n",
>  			status, req->actual, req->length);
>  //	spin_unlock(&dev->lock);
>  }

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

iQIcBAEBAgAGBQJRSGawAAoJECBgQBJQdR/0aV4P/1XCh7KcCo01UlznrAXr2rb2
BPsIiPlIp23VWEqhlb2NPevqo93RObZtM/83IMZVoRJ+YukPUT8g2IW2oEn7GiLW
M4YiT6kpj+MzSZaP8swza58fAT9vqEb9qGgGXcJubybwYsOas1mEF2DgnOMEOoyE
t1HOdJGU+zrj7r07z6wPP06XFHLf6A4S6LFGQny+FjHF6RQcDs68kZDLTLbCf8iT
VNlvUCpItHIi+zyGg/u9BE16koGY4/NrppURqbuiiwouHZ/i/Jn5K3IDGS5QgBmX
QM60hzD4MyZHXTTJsC2PycLSv9kunrJHOFm8fRxf1c2xAJquhe4qLskjssZTmSHo
42wDTT8nZEeBEFwcZAfhq88Wms+2xEJZo1vfCLAaxAPnccoHSni4vbah6xPgPD1T
ZJg/HOXW5+qFVTAw+VSBVL8jmU5PTwbsybZ/JFs14jYbzkz5qsFcfICpMZ1H0Nto
Igb6K5bJaFSOorJXgo28q/s6OXS0N5mjV5C1vHurQiadnHI8u8gFp4Nzy+7bD2T4
cKpNhhdRxg80MbLv6zIk93qKxqcE+BJF/PVyJMTTjJWg47oYLToGBeOvKvjeQjr/
5XJMRh1drPnKXL4qFkZQ8t73i1ETNwOi7oR4QeZZ6wRJbE4gUjoqjKCiw0ABM2A8
dDDc5ikNIQofUgTUqBBX
=qP8K
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
