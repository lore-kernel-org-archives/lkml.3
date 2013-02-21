Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab3BUXxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 18:53:30 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:64507 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab3BUXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:53:28 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: gadget: composite: Allow idVendor and other module_params to be writable
In-Reply-To: <5126ADD6.6040006@linaro.org>
Organization: http://mina86.com/
References: <1361485647-9439-1-git-send-email-john.stultz@linaro.org> <xa1tvc9lnutf.fsf@mina86.com> <5126ADD6.6040006@linaro.org>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Fri, 22 Feb 2013 00:53:16 +0100
Message-ID: <xa1tobfdns0j.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On 02/21/2013 02:52 PM, Michal Nazarewicz wrote:
>> If the driver is not compiled as a module, setting those variables
>> won't work anyway.  Or am I missing something?

On Fri, Feb 22 2013, John Stultz wrote:
> Huh. It worked in my testing. But maybe that's only the first time its=20
> set? I'll play around with it some more, but yea, on further thought,=20
> without unloading the module those values probably shouldn't change.=20
> Sorry for the confusion on my part here.

If you are using g_ffs than yes, it's a bit different, since the module
is initialised only after the user space daemon is active, but for all
other gadgets, setting those won't work.

>> If you want to configure things at run-time without having to compile
>> stuff as modules, you need to wait for the configfs based gadgets.
>
> Heh. I thought I was just sorting things out between the out-of-tree=20
> android composite, ccg in staging, and functionfs. And now there's=20
> *another*?
>
> Any details on configfs based gadget? Is there a git tree somewhere?

There are patches from Andrzej Pietrasiewicz and Sebastian Andrzej
Siewior on the list.  I'm a bit lost in the fate of them and all the
namings.

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

iQIcBAEBAgAGBQJRJrNsAAoJECBgQBJQdR/0sY8P/2otqY6OiJWJOZMYRRUjC8as
7/8YjCmV1Qn6XmsXNr8n+exYu+IYSxAo8E6ULZ/SATUr/n5qm5nYTVlJ+OZN6Ioi
OaQ0Kb1V02z38QVz0JFpP2C8jyt5XRohI1y3VwI+Uogr41khgtXii5FG2vayy7Ak
9NaDGQTSs7KP3AoC4eRtBrBcbelK1PMgF4HaGy8jlf/a9h2tJOHvKCd0/jto45fY
X9lZCJcclJoZpmDETTqS67MRttDRsNPp9D/ua0EU6sB12R9mBYaCFHnoB2+H4QgS
99L9sIpsNeOxRivtpVoRaLnjtGs15BQk4TX7GaodJklGDHoloj8uinrh7TH4X46i
knM8VV/aHQDsjQhMAhEqiSq05QNR6Ixdizo6v2eTjFSKVpyIUotBFeO85KIMsFqn
CzXT18mSb3gqOIOphxJQrqDHqqH+PCcZbIkHaNpk357fTY6oSBw+j4nkBKkfJAxC
HlYWa9BQdqgJb/D1PBSMOpSs04C+8xjux5U5pFK6VOKrnsvcl3oj5kTLgZAhAy5Y
9SJPaoLddCM0BQZFwU3TX3w+Fr2QtI6qV16sS+OYFxU17qsrI+TQD9w3w/9dP/IX
2Zn7i4Xg21XJVLk2871Pvd5yz7Ekdfe8knHD7hGC5yEZer7U/nW8jH1woIZ5mX2c
9vwUw/nLaSEPcbJdl3nU
=BzOf
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
