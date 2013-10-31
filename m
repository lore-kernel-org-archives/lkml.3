Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3JaJMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:12:06 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33463 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3JaJMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:12:03 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: w1: make w1_slave::flags long to avoid casts
In-Reply-To: <20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org>
Organization: http://mina86.com/
References: <5083d6c8452b765cb33acdf03fa9b20b1d15c452.1382788496.git.mina86@mina86.com> <20131030155938.0f5416fe3c5c2cbd3f9cd319@linux-foundation.org>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131031:zbr@ioremap.net::wdYnAUIISXPRfaoo:001EcB
X-Hashcash: 1:20:131031:linux-kernel@vger.kernel.org::K1ja4G+W+Iqmgwjo:0000000000000000000000000000000002xqS
X-Hashcash: 1:20:131031:akpm@linux-foundation.org::0VmgHxSLljPCUplx:0000000000000000000000000000000000004Ul3
Date: Thu, 31 Oct 2013 10:11:53 +0100
Message-ID: <xa1teh71iz3a.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30 2013, Andrew Morton wrote:
> On Sat, 26 Oct 2013 12:56:11 +0100 Michal Nazarewicz <mpn@google.com> wro=
te:
>
>> From: Michal Nazarewicz <mina86@mina86.com>
>>=20
>> Changing flags field of the w1_slave to unsigned long may on
>> some architectures increase the size of the structure, but
>> otherwise makes the code more kosher as casting is avoided
>> and *_bit family of calls do not attempt to operate on an
>> entity of bigger size than realy is available.
>>=20
>> The current behaviour does not introduce any bugs (since any
>> bytes past flags field are preserved)
>
> hm, what does this mean....
>
>> --- a/drivers/w1/w1.c
>> +++ b/drivers/w1/w1.c
>> @@ -709,7 +709,7 @@ static int w1_attach_slave_device(struct w1_master *=
dev, struct w1_reg_num *rn)
>>=20=20
>>  	sl->owner =3D THIS_MODULE;
>>  	sl->master =3D dev;
>> -	set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
>> +	set_bit(W1_SLAVE_ACTIVE, &sl->flags);
>
> ...  I'd have though that running this code on little-endian 64-bit
> would result in a scribble over ...
>
>> --- a/drivers/w1/w1.h
>> +++ b/drivers/w1/w1.h
>> @@ -67,8 +67,8 @@ struct w1_slave
>>  	struct w1_reg_num	reg_num;
>>  	atomic_t		refcnt;
>>  	u8			rom[9];
>> -	u32			flags;
>>  	int			ttl;
>
> ... w1_slave.ttl?

Now that I look at documentation, I think you are correct, but the
problem is on big-endian 64-bit architectures.  The fix is still
valid, but the commit message not so much.  Something along the
lines of the following would be better:

-------- >8 --------------------------------------------------------
drivers: w1: make w1_slave::flags long to avoid memory corruption

On architectures where long is more then 32 bits, modifying a 32-bit
field with set_bit (and other atomic bit operations) may cause bytes
following the field to by modified.

Because the endianness of the bits within a field is the native
endianness of the CPU[1], on big-endian machines, bit number zero is
in the last byte of the field.

Therefore, =E2=80=9Cset_bit(0, ptr)=E2=80=9D on a 64-bit big-endian machine=
 is
roughly equivalent to =E2=80=9C((char *)ptr)[7] |=3D 1=E2=80=9D, and since =
w1 driver
uses a 32-bit field for holding the flags, this causes bytes beyond
the field to be modified.

[1] From Documentation/atomic_ops.txt:

    Native atomic bit operations are defined to operate on objects
    aligned to the size of an "unsigned long" C data type, and are
    least of that size.  The endianness of the bits within each
    "unsigned long" are the native endianness of the cpu.
-------- >8 --------------------------------------------------------

>> +	unsigned long		flags;
>>=20=20
>>  	struct w1_master	*master;
>>  	struct w1_family	*family;

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

iQIcBAEBAgAGBQJSch7ZAAoJECBgQBJQdR/00FsP/1U1QjOHSELKJK+OAQx+C27k
3eca1v8yXte6zqm/+B45q+22MIaHxWYCKAg3JMgv8OL0ZnANPkG1eD6HJsPUd/lv
KRe61V7aQ2jLZlncrIVDZZeEHQROnoMeazlepO+dHB7/pakkeJyBucozzI4FjsEP
RWlqjuHMWn33AzK++KuZ58TzgDYeADmFLS97lQpKAyAbossqMmFa8ksfsEuyKR6f
/FQ4fWFDhVpjif9sGTO4gphUSlgKx/s6BobZu+cznTkkZ+1DFvRVkCWIM75nxz9M
oTZNK67DkWdcfpmjNGDW97brlADcS9IwCcnKqz3gnKKK/kilInP4Na7ND5npg+V0
6FDATyBY71S0QEob2wIczAOfvKwFq+LTJ8auysEtsUQ0VSNpvaXsVW0L6lVxrlfC
gtG7DspnIsSNj12qAMU8b3sx5tzYtAk7bU3syxMwhWFiZm3u4v4m1WZhkIVZf5RJ
9F6OjhAGcHM+2bRdKvphMvYgAuSFPjD+RhT3OBbDKkj/h7BYzMcg2ptvI98edsMi
LXKLYEapoFinpnKDo6a7ChQVNAl+i50zlUkQ7sQ+AXDxPWg3a9dVsngTgf4XpE2g
mI6Aj8zNUhVEX1LE1Fblhhhg4aRgJp6Uvx4BJNLfG9FcHg5K+tSe8fRnli/Kohdk
qFFekXFOZOXp6iSKTwkF
=HCaU
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
