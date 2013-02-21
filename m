Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3BUGoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:44:55 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:46238 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3BUGox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:44:53 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: "Maxin B. John" <maxin.john@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: matt.fleming@intel.com, matthias.fend@wolfvision.net, balbi@ti.com,
        linux-usb@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH] tools: usb: ffs-test: Fix build failure
In-Reply-To: <CAMhs6YxGWaLgt58HeumVzstU=373WRYMTsf8uFKnQ9nEFboj7w@mail.gmail.com>
Organization: http://mina86.com/
References: <1361404671-11713-1-git-send-email-maxin.john@gmail.com> <20130221000649.GB14395@kroah.com> <CAMhs6YxGWaLgt58HeumVzstU=373WRYMTsf8uFKnQ9nEFboj7w@mail.gmail.com>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Thu, 21 Feb 2013 07:44:42 +0100
Message-ID: <xa1tfw0qdv39.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21 2013, Maxin B. John wrote:
> Hi,
>
> On Thu, Feb 21, 2013 at 2:06 AM, Greg KH <gregkh@linuxfoundation.org> wro=
te:
>> On Thu, Feb 21, 2013 at 01:57:51AM +0200, maxin.john@gmail.com wrote:
>>> From: "Maxin B. John" <maxin.john@enea.com>
>>>
>>> Fixes this build failure:
>>> gcc -Wall -Wextra -g -lpthread -I../include -o testusb testusb.c
>>> gcc -Wall -Wextra -g -lpthread -I../include -o ffs-test ffs-test.c
>>> In file included from ffs-test.c:41:0:
>>> ../../include/linux/usb/functionfs.h:4:39: fatal error:
>>> uapi/linux/usb/functionfs.h: No such file or directory
>>> compilation terminated.
>>> make: *** [ffs-test] Error 1
>>
>> This is a build failure where, 3.8, or linux-next, or somewhere else?
>
> It is in 3.8

This also happens in 3.7.  [commit
5e1ddb481776a487b15b40579a000b279ce527c9: UAPI: (Scripted) Disintegrate
include/linux/usb] is the culprit.

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

iQIcBAEBAgAGBQJRJcJbAAoJECBgQBJQdR/0l/cP/0y0J53fNlWImm608L4eNiKa
e2ZaEm62ZR6h9qFlW86UP+08sv+FUcKnibU/WQZOPfhDNvgYjrsD41fQwpEYYc7g
CPB/+9bWPgmiYfr3o6VfdHk4qTnmB+0vO7zXfmf2jqGetDLPrqBcDqscJoCcdofm
OTmU4VhyTvR5v7T15u+KlI/en+F4gK6L3EVbHUyhPioZmPZDfGJNmTp+86L53bx8
tBlcOBkNP8Tz2XvaAunbDHUkLRejOz5YUpbWvMYrfQjvIpA+Kq5uNa3/Irs6c0cZ
ST+tbneZDk3MJx7QD9U5T6KPHTJz5JrBf8BuL+j72JF4tGT96JVSsFDzeu9rbNM/
9GKiyt9CM2rpse+/HLst5FXQ5G3gy1zNP9toe93SRutR2ikdYIKqzLg2+QCTcK6E
w7LLq6sghfOwvn3kkU0cqbLFM+Uf3WM76lbbmH886NApv+NxL0ysZSbNywyPFndm
bcHOJe/43awp7wRxi8noi1X8uwULR3eXl3u1e+yIXHYyCzEEpJNjYADUQKzIQ3wc
MDOPKzR4SbVTP9o0FxJclaWdiuolLMdNd9qfyLx23QvW+3QEgEKWeOZZN8FMcBAa
o0xS4/DUEE7DhT41qX6J7QbBxktCeOGOaoD6lEdKj0IKEBiSRzMK1Xn386jQjEA9
sGKzPpISe1CMptk5VKsj
=qO6r
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
