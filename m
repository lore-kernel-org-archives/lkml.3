Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3KKVOE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:14:04 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:53399 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3KKVNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:13:51 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: gadget: f_fs: remove loop from I/O function
In-Reply-To: <5281390F.9080104@linux.intel.com>
Organization: http://mina86.com/
References: <1383603177-4624-4-git-send-email-david.a.cohen@linux.intel.com> <1384102237-19784-1-git-send-email-mpn@google.com> <5281390F.9080104@linux.intel.com>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::oF2f79CPYPgX1QPN:0000000000000000000000000000000000Ro3
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::c9c3GSuEodYMutd7:0000000000000000000000000000000000000GTk
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::pb0p6a0oB7QsjnXl:0000000000000000000000000000000000000b8Z
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::5j5J26dvCZnLphID:0000000000000000000000000000000035TA
Date: Mon, 11 Nov 2013 22:13:43 +0100
Message-ID: <xa1tbo1qy73s.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On 11/10/2013 08:50 AM, Michal Nazarewicz wrote:
>> +		if (wait_event_interruptible(epfile->wait, (ep =3D epfile->ep))) {

On Mon, Nov 11 2013, David Cohen wrote:
> FYI this line fails checkpatch:
> ERROR: do not use assignment in if condition
> #70: FILE: drivers/usb/gadget/f_fs.c:777:
> +		if (wait_event_interruptible(epfile->wait, (ep =3D epfile->ep))) {
>
> total: 1 errors, 0 warnings, 121 lines checked

This is intentional.

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

iQIcBAEBAgAGBQJSgUiHAAoJECBgQBJQdR/0/AgP/06Mz62TWNfyQMCVPSh3qjPH
45xB7SQXM6t3Ou2Ti5a2piE+7r8fRAfOHbbX0zI8w/lY+h2XeM0wMAAU4N5lMqub
enwAGToCbFngzJF7x6h32JOSvZr0UyKWUzhvTd/MPkrGhoxHureFvFXft/h9Bkas
A6+pwrc7cbiFrpPyJM1v1+rAi3psrI7loxmB+qkMOlbF5tvjIHy3IaQ7QYChU/hX
xpdAZKAg4ziKLPArdU6C94cjJTTQXYbMG4rBvYclQakPWxYAzi8iy7lP9zciJ3lt
Rc2WUcsNWXq2uw5CGqIEDyC6QRSQ5OvwBERC8RPGjxVzRZ+esAvas7yZRo4avr2U
IH0JeXx7icp9IWghnbToQdfIf7J8sMXiz/7SnMUtHJeVS/93NuySEaCGgGCGJ3Zd
D8CehxQV7mUFw2F/JUhnx0OYLneUOXByPBAukluDTJVtt9f2sI0MoE/0jul0P7lg
7fUH6GFr6KcMa2WA/pWEpMQCRuL60rvlT68EGGF2pB5bJwfo08xjc5uP23pmiDyY
18ImFK5aQd5zdvlJd6ZRXOMXq+QhVCQHij3IA0dlzhS2ZOtzw/ZBx9a1CjKur6fn
Os7i9tF3KVfdeasdSbvTR6A2VaV8sFwZIw1jVqVq7lHf0Fl+Vvc2WMorjNgjuzYJ
Kb2xkcsajDb/Pu+O9oZ/
=r3D6
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
