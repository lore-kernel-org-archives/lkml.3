Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab3KFSnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:43:49 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:58316 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3KFSnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:43:46 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>, gregkh@linuxfoundation.org,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/4] usb: ffs: check quirk to pad epout buf size when not aligned to maxpacketsize
In-Reply-To: <Pine.LNX.4.44L0.1311051324100.1360-100000@iolanthe.rowland.org>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1311051324100.1360-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131106:linux-kernel@vger.kernel.org::ESRXM6XUDqV+NB0L:00000000000000000000000000000000003mF
X-Hashcash: 1:20:131106:stern@rowland.harvard.edu::lRoJ9uf85/ocgnO5:0000000000000000000000000000000000001BIl
X-Hashcash: 1:20:131106:linux-usb@vger.kernel.org::0ZO1DWYen8U93JN3:0000000000000000000000000000000000001jCU
X-Hashcash: 1:20:131106:david.a.cohen@linux.intel.com::P+P0RXQfFE1JI1hq:000000000000000000000000000000001oTi
X-Hashcash: 1:20:131106:balbi@ti.com::99GDtDjuCM/veXjW:0000038zC
X-Hashcash: 1:20:131106:gregkh@linuxfoundation.org::ZjGpncyRqKzco9dq:000000000000000000000000000000000003qj/
Date: Wed, 06 Nov 2013 19:43:38 +0100
Message-ID: <xa1t1u2t1icl.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 05 2013, Alan Stern wrote:
> Maybe Michal can enlighten us.

Sorry for late response, this thread fell under my radar for some
reason.

So here's how it works:

epfile represents an end point file on the fuctionfs file system,
i.e. what user space is seeing.  It's numbering is independent of which
USB configuration is chosen.

A FunctionFS user space daemon may read/write to those files regardless
of whether the function is enabled.  If it is not, the operation will
block until host enables the function.

epfile->ep represents an actual USB end point, and it's number does not
have to correspond to the epfile file name, and may be different in
different configuration.  FunctionFS hides all that from the user space
daemon.

epfile->ep is set when host changes configuration (i.e. function's
set_alt or disable callbacks).  IIRC this implies that epfile->ep cannot
be protected by a mutex, and therefore is protected by a spinlock.

Since it is protected by a spinlock, the ffs_epfile_io function cannot
lock it and then proceed to allocating memory and copying data from user
space.  That's why there is the need for the loop since there is no way
to guarantee that while the memory was allocated and data was read from
user space (if it is a write), the function has not been disabled and
re-enabled.

However, I'm not sure whether maxpacketsize can change.  It is part of
endpoint's descriptor and even though the endpoint number can change
while ffs_epfile_io is running, all the other descriptor fields should
stay the same.

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

iQIcBAEBAgAGBQJSeo3aAAoJECBgQBJQdR/0VFMP/2o/jF5xH37Xi5f9sVczCBvk
KLyCdrjHshzWbh0+MyjoiEuJfiFTCCD4YVIWHE50VkeKwiLhGRZNlG4NHVzS6HNm
HmHf60MihDARs0cD0c9J9vhiflctIRGPT+dh+Cca8MzDQ5/SSN5tLP68FwwJ/xRj
F+tPQjVlRaNKz8ZZb5zOk9n98MTqig2Cvq/+74nsKR8eSh9ZthKG/rCMSnY199G9
T2kA29fLk2SzGS6vVrrgMXZzqjG8vGz/eRiuOwpVQgxu/1EizIOAvmWKsvh0+YDS
YxMv3eyR0jQ08hJdvKWJkNDvMqcm11bNbLGg//o+bNzc5P9twNS+PIChLRke9xES
cpt0SRdZ1mkbfsqW4A9mT64GisDoJYd9Kkn5N8coVuX8KZCK8+7kqXfLpR42Tx4E
AtnY10xWLwtpLYC7Xu6cHoHRi7+ULOiLkbipqAJ/UD9jsx6eNXbVoGcXkOnkNq+p
w4/ggEKvTxzNJvbhVxODf3ZwbNiaiHI2HxLH7/gAklccvh04CC3Iay8O/FLlxNda
5dyM2P14GnvQc6b1OW1RrN5LWFEaFYjDkSkMgz/Fnzfoy+DM7VBVl0vlSsPBN2U6
7WOmzWRtMetIj3aNCYBVKzmXbVrLIFcawUbsRRlyWulZYlWq7eE3htThcKhS7xqQ
bVDCtEMRb6PkzA2FSzMH
=OHCi
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
