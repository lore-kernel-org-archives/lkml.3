Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab3KKXzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 18:55:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36277 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384Ab3KKXza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 18:55:30 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH v5 2/5] usb: gadget: add quirk_ep_out_aligned_size field to struct usb_gadget
In-Reply-To: <1384201011-11114-3-git-send-email-david.a.cohen@linux.intel.com>
Organization: http://mina86.com/
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com> <1384201011-11114-3-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::jiKxz90zqjCNP08N:000000000000000000000000000000000pk0
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::u1nf1kv+NsJAh9Hr:000000000000000000000000000000000cMD
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::R9e2ZoE48aU34U/R:0000000000000000000000000000000001zbA
X-Hashcash: 1:20:131111:gregkh@linuxfoundation.org::HiC1dfwK7zMhFxtM:000000000000000000000000000000000002mzL
X-Hashcash: 1:20:131111:balbi@ti.com::w9LPrmTn1A32smOr:000003VFw
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::IhmtEKhVYeXXmQBu:0000000000000000000000000000000000004dCb
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::V7U0x+O3D+ppeEBn:0000000000000000000000000000000000004eb3
Date: Tue, 12 Nov 2013 00:55:22 +0100
Message-ID: <xa1tzjpawl1x.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11 2013, David Cohen wrote:
> Due to USB controllers may have different restrictions, usb gadget layer
> needs to provide a generic way to inform gadget functions to complain
> with non-standard requirements.
>
> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> to inform when controller's epout requires buffer size to be aligned to
> MaxPacketSize. A helper is also provided to align buffer size when
> necessary.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>
> Michal,
>
> I added prefix 'usb: f_fs: ' to patch's subject. I did not add 'usb: gadg=
et:
> f_fs' due to it would be too long.
>
>
>  include/linux/usb/gadget.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 23b3bfd0a842..41e8834af57d 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -441,6 +441,19 @@ static inline void usb_ep_fifo_flush(struct usb_ep *=
ep)
>  		ep->ops->fifo_flush(ep);
>  }
>=20=20
> +/**
> + * usb_ep_align_maxpacketsize - returns @len aligned to ep's maxpacketsi=
ze
> + * @ep: the endpoint whose maxpacketsize is used to align @len
> + * @len: buffer size's length to align to @ep's maxpacketsize
> + *
> + * This helper is used in case it's required for any reason to align buf=
fer's
> + * size to an ep's maxpacketsize.
> + */
> +static inline size_t usb_ep_align_maxpacketsize(struct usb_ep *ep, size_=
t len)
> +{
> +	return round_up(len, (size_t)ep->desc->wMaxPacketSize);
> +}
> +

Come to think of it, perhaps even better helper would be:

static inline size_t usb_ep_align_maybe(
	struct usb_gadget *gadget, struct usb_ep *ep, size_t len) {
	return gadget->quir_ep_out_aligned_size ?
		round_up(len, (size_t)ep->desc->wMaxPacketSize) : len;
}

>=20=20
>  /*----------------------------------------------------------------------=
---*/
>=20=20
> @@ -502,6 +515,8 @@ struct usb_gadget_ops {
>   *	only supports HNP on a different root port.
>   * @b_hnp_enable: OTG device feature flag, indicating that the A-Host
>   *	enabled HNP support.
> + * @quirk_ep_out_aligned_size: epout requires buffer size to be aligned =
to
> + *	MaxPacketSize.
>   *
>   * Gadgets have a mostly-portable "gadget driver" implementing device
>   * functions, handling all usb configurations and interfaces.  Gadget
> @@ -541,6 +556,7 @@ struct usb_gadget {
>  	unsigned			b_hnp_enable:1;
>  	unsigned			a_hnp_support:1;
>  	unsigned			a_alt_hnp_support:1;
> +	unsigned			quirk_ep_out_aligned_size:1;
>  };
>  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
>=20=20
> --=20
> 1.8.4.rc3
>

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSgW5qAAoJECBgQBJQdR/0ETUP/0fzjfHVF2hD23RsvPShkZaD
v6TqVkXhGP5QJrng3Ix5Pv1fdA21yP4mpQbxNUhn6545ajUo6bxsM95KcJTxlnEE
MqYL0eaEpR/vTF9Aqx4rxNNvz0FBk6fMkPuyuZ0V9MmUdvBSXs7wHPtQPazZRp6c
ovRZBhSqses5jFQ/ta+ERATuFE6CjHYmL2Svq/Ww1CIGPwxU5oW0cFyX/WNF+8Fk
XwKmUB+tszRw7STwtLl3f0Xgg5GjXmvdYataHxxJJNfvR4mMjpp4EWWLyoc6KOKI
jOP3A0+/JemkfhAz3PbhlM3yZL3SMjxl95DusYoCqpoCq3fdlY3G1yhYgY71JLR6
Cj8dYJ5kDHJaIYSdvDEfEm5Cq8cNV9ED+CHx8+Al+6dkjvVAK5jAznLBGNi29BNf
znn2HDllEveXhPnMcaEW8RCXrAoig0yEvZWXjzY5NhTLAtaPQ+q1sOEfuNLdErHN
OTIYlG65HIG276e5Af8/PbHbzLPBhiAXWNl1HKiqWlx95TJag2lmoJ0P/xlDbeh2
xqZCEwKI6tYLzjF0Tb3JqnJ2A/VA9po9pdb7o66A6Xl6/7Pj7qSRQjw0+uAMWf6Y
ZTUwyIaFLmGu0gJZVW0ujkV56s4gdgQlZpj3s0llWLLLmxw8kHr5laFmm3skNPc6
kUV8ij3wLZvPnim0mB0+
=Arl1
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
