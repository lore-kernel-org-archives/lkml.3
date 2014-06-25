Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaFYHEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:04:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaFYHEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:04:22 -0400
Message-ID: <53AA746A.3030303@canonical.com>
Date: Wed, 25 Jun 2014 09:04:10 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: fs/stat: Reduce memory requirements for stat_open
References: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com> <20140612134149.GC4296@osiris> <5399B301.9030108@canonical.com> <alpine.DEB.2.02.1406241642280.22030@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406241642280.22030@chino.kir.corp.google.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="NNBg5ngqFCgUwKnOX5CsvgJAuGCVA4DR0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NNBg5ngqFCgUwKnOX5CsvgJAuGCVA4DR0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 25.06.2014 01:44, David Rientjes wrote:
> On Thu, 12 Jun 2014, Stefan Bader wrote:
>=20
>> doh, so you guys have been hit by that before. And I have missed the f=
act that
>> single_open is special. Which makes the change for the upper limit do =
the wrong
>> thing. While long-term it sounds like changing it to vmalloc or iterat=
ive reads
>> sounds better, maybe the change from possible to online cpus might be =
something
>> that is better acceptable as a quick fix... Not sure. At least this gi=
ving back
>> a bit of attention to the matter and it is not only affecting zSeries.=
 x86
>> starts to see hw that requires a similar high possible cpus... :)
>>
>=20
> Heiko's patches that should fix this problem are now in -mm, so it woul=
d=20
> be nice to know if there are any existing issues that haven't been=20
> addressed yet with your bug report.  See=20
> http://www.ozlabs.org/~akpm/mmotm/
>=20

Heiko and I both had the same issue. Since some x86 hardware also reaches=
 a lot
of CPUs (hyperthreads included), we bumped the possible number of CPUs to=
 256 at
least for the 64bit kernel. And that resulted in failed accesses to /proc=
/stat
when memory became fragmented.
So the first patch will avoid this on most systems. I have not seen this =
myself,
but I would expect him to be happy with 1/2 already. For really excessive=

hardware 2/2 will close the gap.
Since this is no critical bug, I am fine with 3.17, too. I have not done =
so,
yet, but I could let our reporter try the patches (again, probably not ve=
rifying
the second part). Just waited to do so to see whether the code settles do=
wn to
these changes.

-Stefan


--NNBg5ngqFCgUwKnOX5CsvgJAuGCVA4DR0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTqnRzAAoJEOhnXe7L7s6jLlsP/37pLWV3+B3kJ2CStZ7bvQ+T
FBw6xpLjzu5ayIQuzvN6amSqyAmpjc6GrbzBH75oaKP+NP9900sizIrD88Kjv4PC
Cs3fvx2f8CBv/08p/LexmawlWz+dIeW3R8lDv87AZHmYDEEaVuqLKCUnhuzAmjf+
gbQB6H8PMtsPMoFv8B/+ptnB0UcT9gEpZxYI7S65DIUuRb85i6m7/57pUKfurekr
cbt33Yl2wDyLhYqw5tXs/miGGi3psGwL+r4VRWAk72+daYVo0uaf7w9rkO+5mLC2
AOCGyU8wjMaXH9ZoUcLFSB+m33Of2/qUzYsM6mglX/3k97pMTDU/a4GCgwQJV97/
BEUlABTP9/DbNgpV1RbtkxfdCzs3wds3n1wnnUi/kyzilgDrF3cCgRgMTzeiJbK7
nvj6UpHEBRiTlgTS6af0Av5GhgAVnArY0tUQ8MveABv8nV3xG8S/V7mc/g4vIDQ2
E8aHwAoMOm6VluTB9NJJWu+h8fR2G/P1KVhFSlSmV7Zis1KnoRWZQT7v+crx1T6Q
QR9B02nZFuy6EIfI91x5RqwXQLm0X9xduufNaFORdiI29aUrn9+ylYgSJ9fFD7sF
jrB22djaceieMnOZzOUokQrcrcAKoshrJ5+vPDtTZsdrGrRyJyDXKjr138MWudre
k8jQ+c75NBkwBlhtkRpH
=/XxE
-----END PGP SIGNATURE-----

--NNBg5ngqFCgUwKnOX5CsvgJAuGCVA4DR0--
