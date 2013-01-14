Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3ANI2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:28:09 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63040 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3ANI2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:28:07 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Andy Whitcroft <apw@shadowen.org>, Alexander Nyberg <alexn@dsv.su.se>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 2/2] Enhance read_block of page_owner.c
In-Reply-To: <20130114023338.GB18097@blaptop>
Organization: http://mina86.com/
References: <1357871401-7075-1-git-send-email-minchan@kernel.org> <1357871401-7075-2-git-send-email-minchan@kernel.org> <xa1t8v7zbteu.fsf@mina86.com> <20130114023338.GB18097@blaptop>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.3.50.5 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
Date: Mon, 14 Jan 2013 09:27:57 +0100
Message-ID: <xa1t6230p3si.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14 2013, Minchan Kim <minchan@kernel.org> wrote:
> I'm not familar with Python but I can see the point of the program.
> It's very short and good for maintainace but I have a concern about the s=
ize.
> For working it in embedded side, we have to port python in that
> machine. :(  [...]
> In case of that, just small C program when we release product would be
> good choice.

But is this program intended to be used as is? Or rather to serve as an
example?  If the former, than I think it should be in tools/ rather than
in Documentation/.  If the latter, than I think it does not really
matter whether it's C or some scripting language, since the purpose is
to show how /proc/page_owner can be used, and in fact showing the
general idea may be simpler with a shorter program which does not have
to deal with memory management.

And if Python is not your fancy, you can always use some shell: ;)

	awk -vRS=3D '{ gsub("\n", "\\n"); print $0 }' |sort |uniq -c

> But I'm not strong aginst on your simple python program. If it is merged,
> we will just continue to use C program instead of python's one.
> If you have a strong opinion, send it to akpm as separate patch.

Not at all.  I'm just throwing ideas.

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

iQIcBAEBAgAGBQJQ88GOAAoJECBgQBJQdR/0vBAP/3tMBO+KCy5wCcPUSzHoyzhH
hVSM08dGFqas5Vn7UlhzcQX6PIbps7Hle508r5iIdoo9QcHkykUm4q6+2RLRe3oV
uSb/zjPE6x7gkAl8AvkLaHlsUVMbURGVzj2F4+nbtf/CBxJjMsAJq7cXYnP8wiOH
NKRlHwNS2JHcwyRtYS2lotsoObzgaZ7mpb5iAb9ChNhC/DI+NJmDrc9AXywxuTfb
LldhtXv7bMs5n9nKhiu++93B+zdaqzWc99BDREtYesFXXNb21d9PJNypCKGQOaGl
5UK16cgoBTTekxD7MpZdMhr0dV6oZ1p7XnZrZjkOZGuZbp1ZeifYnc2hqxxJ1h8S
zZxxRh6rXYqPYBSLRVsTH+CyN3FIi/jNn0aopHi2Xx+/GL5QXk1uN0kk7vl67ra/
oGQz5Nuo3htJNhSDXFhj8nuvFqzTPQeldDMlGkPrJQYuJ80qi6ymWbJ9f/5eSzMU
nqr/U/NYU6YyP9DJr9pRacDV3Zjc2KJVq9w8LCQSrhDEUOFNUok1QMs5k04G4uEo
yscnWfIr4vcD0HFVo+xf/mitMFR2t330z9AFM+0VNx7b3yyDmjOY/MNsw1ce8lQY
KLn7mS1LrDLPQgdkMyjexGyxJFsAqkhK0sVstE0Th9H3gQkzx/gIR5aTpEA83XsQ
BmTTsZXY+aMtX2PEdS4O
=9ZHj
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
