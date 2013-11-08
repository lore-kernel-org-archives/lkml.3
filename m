Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3KHMXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:23:44 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65260 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab3KHMXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:23:41 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Cohen <david.a.cohen@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        gregkh@linuxfoundation.org, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when not aligned to maxpacketsize
In-Reply-To: <Pine.LNX.4.44L0.1311071053430.1401-100000@iolanthe.rowland.org>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1311071053430.1401-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131108:linux-usb@vger.kernel.org::U0B6eOMYIQ+zT/Xv:0000000000000000000000000000000000000PjW
X-Hashcash: 1:20:131108:linux-kernel@vger.kernel.org::N27aLJme63zhJh3H:0000000000000000000000000000000000vgo
X-Hashcash: 1:20:131108:gregkh@linuxfoundation.org::bzA6ZRaLgrLZGY0l:000000000000000000000000000000000001I3F
X-Hashcash: 1:20:131108:stern@rowland.harvard.edu::uHr/hwaxHIjRCBty:0000000000000000000000000000000000002/2p
X-Hashcash: 1:20:131108:balbi@ti.com::lROQH2SCLwhRSQtR:000006H92
X-Hashcash: 1:20:131108:david.a.cohen@linux.intel.com::krLXiEQ15UM12KGU:000000000000000000000000000000005NQQ
Date: Fri, 08 Nov 2013 13:23:32 +0100
Message-ID: <xa1tzjpfxet7.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 07 2013, Alan Stern wrote:
> What happens if the userspace daemon writes to epfile but the host=20
> changes the config or altsetting before all the data can be sent?  Does=20
> the remaining data get flushed?

Each read and write is mapped to a single request, so the usual.

> I'm still a little unclear on this.  Disabling the function ought to
> have much the same effect as changing the config or altsetting: Writes
> to endpoint files should be flushed and reads should be terminated.=20=20
> Otherwise you would end up sending stale data to the host or reading=20
> data that the daemon isn't prepared for.

You may have a point here.  I'll try to prepare a patch over the weekend.

> Given that, there doesn't seem to be any need for a loop.  Copy the=20
> data; if the function was disabled in the meantime then throw away the=20
> data and return an appropriate error code.

Right.

> I don't see any reason why you should ever have to copy the same data=20
> from userspace multiple times.

That actually never happens.  The data is copied at most once.

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

iQIcBAEBAgAGBQJSfNfEAAoJECBgQBJQdR/0qQMP/2/+hOx/FDz+kpOxuNL3fvSY
zo6EF6Iwzd1FYgNBvXoGck0aDVDPBphxLh5hhptT7YmlLK0ysBVfCr1+YOfeVnvU
FO6QzNyy/2oKm7PutCbcukqq2iQWlhIQCPvTIyr1xF4lMObQRMWGKziuLUwpMqv0
FsDyXvaOXfvAatRnEgIpivzzAOdEAAymbnsjiADdNT91W/EtenXke5tBXrMuJ/54
EeHwEZ3ev2biIJJpDQYuDlpMaUtDTtDS0YunYtWUksU4Lt6iw6yh+dh7eyV7MCZ3
45UyPhKXFndYorZ/kloIdfV+54aExxXHBggQXnLb/PZ7OmJhYdvNFPIENUM/WRq5
2wwsYCaD1CCvJ4eI5uGjiAyE7NUMqgdy6GokwxHCFgrxhykeQeo16JWhh1ClRcsn
a1RsFCpoukMNXSbRxCGcOK6FXwXb2sXMUHJ/T+fhsp85f0RdXU/2NSDFgKjaroJV
kWI8q2V32ewvnZWVrFDw560IZIpJFMm958O0Rl1yOrbz6DjX+3jPwufgE8ES0S8g
IUhV6kOGQHonyR6uPV+hpQCoCs7D/1sB2n5JLEFkhEU4RqwzY+Wwt0ZZNLk0XTq0
2y0TiaBINcowNq199RNWcrjtlasMcIXBdB1JifSDLOHl1RBrQJSJhAWUn8xG/eQI
vK4SmNCGytcPNmN36iC3
=lJuX
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
