Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3HGLbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:31:40 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36983 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3HGLbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:31:38 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Jaeger <christophjaeger@linux.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Jon Mason <jon.mason@intel.com>, tech.support@emulex.com,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/1] module: fix sprintf format specifier in param_get_byte()
In-Reply-To: <87y58eov9u.fsf@rustcorp.com.au>
Organization: http://mina86.com/
References: <1375823532-24153-1-git-send-email-christophjaeger@linux.com> <87y58eov9u.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:130807:jon.mason@intel.com::yMcfI9eaaAYeGlLf:0000000000000000000000000000000000000000000EB/
X-Hashcash: 1:20:130807:christophjaeger@linux.com::Rhj6TwvH8Fw6Vrn8:00000000000000000000000000000000000001uv
X-Hashcash: 1:20:130807:dwmw2@infradead.org::7AkCVV7+lPop0gRp:0000000000000000000000000000000000000000000vqP
X-Hashcash: 1:20:130807:linux-kernel@vger.kernel.org::H1y+xplIrHY3LdHb:0000000000000000000000000000000000iEr
X-Hashcash: 1:20:130807:rusty@rustcorp.com.au::Kh5sM5H6ei8JSRiZ:00000000000000000000000000000000000000000ry7
X-Hashcash: 1:20:130807:dmitry.tarnyagin@lockless.no::tDR+LPGUbuIPCvd7:0000000000000000000000000000000008Bh9
X-Hashcash: 1:20:130807:tech.support@emulex.com::exF+Sx1u7VOkabrv:00000000000000000000000000000000000000CPHD
Date: Wed, 07 Aug 2013 13:31:30 +0200
Message-ID: <xa1tli4d20vh.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 07 2013, Rusty Russell wrote:
> Christoph Jaeger <christophjaeger@linux.com> writes:
>> In param_get_byte(), to which the macro STANDARD_PARAM_DEF(byte, ...) ex=
pands,
>> "%c" is used to print an unsigned char. So it gets printed as a characte=
r what
>> is not intended here. Use "%hhu" instead.
>>
>> Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

for g_ffs.c:

> drivers/usb/gadget/g_ffs.c:95:module_param_named(bDeviceClass,    gfs_dev=
_desc.bDeviceClass,    byte,   0644);
> drivers/usb/gadget/g_ffs.c:97:module_param_named(bDeviceSubClass, gfs_dev=
_desc.bDeviceSubClass, byte,   0644);
> drivers/usb/gadget/g_ffs.c:99:module_param_named(bDeviceProtocol, gfs_dev=
_desc.bDeviceProtocol, byte,   0644);

I don't think it breaks anything for g_ffs since those properties are
most likely write-only and I don't expect many people reading them.

>> ---
>>  kernel/params.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/params.c b/kernel/params.c
>> index 440e65d..59f7ac7 100644
>> --- a/kernel/params.c
>> +++ b/kernel/params.c
>> @@ -252,7 +252,7 @@ int parse_args(const char *doing,
>>  	EXPORT_SYMBOL(param_ops_##name)
>>=20=20
>>=20=20
>> -STANDARD_PARAM_DEF(byte, unsigned char, "%c", unsigned long, strict_str=
toul);
>> +STANDARD_PARAM_DEF(byte, unsigned char, "%hhu", unsigned long, strict_s=
trtoul);
>>  STANDARD_PARAM_DEF(short, short, "%hi", long, strict_strtol);
>>  STANDARD_PARAM_DEF(ushort, unsigned short, "%hu", unsigned long, strict=
_strtoul);

Actually, are those =E2=80=9Ch=E2=80=9D specifiers even necessary?  I'm fai=
rly certain
that =E2=80=9C%u=E2=80=9D for byte, =E2=80=9C%i=E2=80=9D for short, and =E2=
=80=9C%u=E2=80=9D for ushort would work just
fine since the argument gets promoted to (unsigned) int anyway and
indeed vsnprintf reads an int for all those types.

>>  STANDARD_PARAM_DEF(int, int, "%i", long, strict_strtol);

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
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSAjASAAoJECBgQBJQdR/0sXcQAIeMyWWDCSTyYtXTGQUyF4gp
cjr1jyEvU5jRCnYAJXpmlaLG4qtfTkUiLluuFS/NMyZFNZoN2YjT2AeRVyjm6Kv4
iICDf1uaSqgqkUtCGjXjxHxagSwg7EYQxYmWZfg5TsayPLdrf7Ojo5F47/lo0V/L
37pXgj2AOoV/ygEY6ZgjxWub4CGzqZAzboqwRHLGffKc1oneNM1lC0NjQeek/mwz
yBp37w2UOCgs8HDiHZ3Tv6vEHPCRFMZhCgBBYRSw0Dd7hGJJcOgL5TbetckFOaHN
kL2JwSdLCJHpBJ2kaqkkGoWF2Cyg2MZEXI70dkWXyIqqMTYo/lNlxHmuBUrXQlbu
YS4zdL9E4rHTf58dppFTpgQSFLBmgNlrFm+M44GUL9Eu9EZL1cl2iXYfEu/6ExFG
+qfT1gW3DcGYbxUA0w+sjJD7W+GmkGWJ36cIFZTGEBE/eguEPVFW2fFlUCobJW6I
zUIscbvYYcu5sBBbJOnECFAeu+EWT4YjgUpXK2LOk6MmS/ihNN5K1SrX/iqD7iPW
vlWpsAhHnP4lOSeEwF8SNOd+WA8/v6oCnYOEYrnJjJAWiIN4QjtM7gpi7Lby1+4B
SJbeZh7ljAsvpd+21D2iuk5sYt8IaHkHp8upzp0wI0rMr0Ppkahy6TiKvDQAFbsW
gnfpd45pS7n63hC6Zph/
=NO1Z
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
