Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3FZJCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 05:02:13 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:42094 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3FZJCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 05:02:08 -0400
Message-ID: <51CAAE0C.4040809@monstr.eu>
Date: Wed, 26 Jun 2013 11:02:04 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Graeme Smecher <gsmecher@threespeedlogic.com>
CC: linux-kernel@vger.kernel.org,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>
Subject: Re: [PATCH] microblaze: Don't mark arch_kgdb_ops as const.
References: <1370710328-15011-1-git-send-email-gsmecher@threespeedlogic.com> <51B39B11.8030900@threespeedlogic.com> <51C765C3.403@threespeedlogic.com>
In-Reply-To: <51C765C3.403@threespeedlogic.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2UBFVMSFWXKQOOTFBOQQL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2UBFVMSFWXKQOOTFBOQQL
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Graeme,

On 06/23/2013 11:16 PM, Graeme Smecher wrote:
> Hi Michal,
>=20
> On 08/06/13 01:58 PM, Graeme Smecher wrote:
>> Hi all,
>>
>> On 08/06/13 09:52 AM, Graeme Smecher wrote:
>>> Other architectures don't do it, and it conflicts with the extern'd d=
efinition
>>> in include/linux/kgdb.h.
>>>
>>> Signed-off-by: Graeme Smecher<gsmecher@threespeedlogic.com>
>>> CC: Michal Simek<monstr@monstr.eu>
>>> CC:linux-kernel@vger.kernel.org
>>> ---
>>>   arch/microblaze/kernel/kgdb.c |    2 +-
>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/microblaze/kernel/kgdb.c b/arch/microblaze/kernel/k=
gdb.c
>>> index 8adc9244..09a5e82 100644
>>> --- a/arch/microblaze/kernel/kgdb.c
>>> +++ b/arch/microblaze/kernel/kgdb.c
>>> @@ -141,7 +141,7 @@ void kgdb_arch_exit(void)
>>>   /*
>>>    * Global data
>>>    */
>>> -const struct kgdb_arch arch_kgdb_ops =3D {
>>> +struct kgdb_arch arch_kgdb_ops =3D {
>>>   #ifdef __MICROBLAZEEL__
>>>       .gdb_bpt_instr =3D {0x18, 0x00, 0x0c, 0xba}, /* brki r16, 0x18 =
*/
>>>   #else
>>
>> It's worth noting that this patch is flagged by checkpatch:
>>
>>    WARNING: struct kgdb_arch should normally be const
>>    #25: FILE: arch/microblaze/kernel/kgdb.c:144:
>>    +struct kgdb_arch arch_kgdb_ops =3D {
>>
>>    total: 0 errors, 1 warnings, 8 lines checked
>>
>>
>> However, without it, my kernel fails to compile:
>>
>>       CC      arch/microblaze/kernel/kgdb.o
>>    arch/microblaze/kernel/kgdb.c:144:24: error: conflicting type
>>    qualifiers for 'arch_kgdb_ops'
>>    include/linux/kgdb.h:284:26: note: previous declaration of
>>    'arch_kgdb_ops' was here
>>    make[1]: *** [arch/microblaze/kernel/kgdb.o] Error 1
>>    make: *** [arch/microblaze/kernel] Error 2
>>
>>
>> The checkpatch test was a response to this (rejected) patch series:
>>
>> http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/02659.html
>>
>> I'm the lucky victim, here, since I'm using gcc 4.6.4 (which notices t=
he conflicting qualifiers), while other Microblaze users are still workin=
g with gcc 4.1.2 (which didn't care.) All other architectures (including =
mn10300, arc, and hexagon, which were accepted after the checkpatch commi=
t) ignore the checkpatch rule and declare arch_kgdb_ops non-const.
>>
>> In any case, I wanted to point out (a) that the patch fails checkpatch=
, (b) that I'm submitting it anyway, and (c) that I'm utterly ambivalent =
about how the struct is declared, provided I can compile working kernels =
on Microblaze.
>=20
> Can you give me an update on including this patch in linux-2.6-microbla=
ze? I realize the "const" was added as a result of a checkpatch.pl compla=
int (see 6bd55f0bbaebb79b39e147aa864401fd0c94db82), but it seems like a n=
on-compiling kernel (even for trivial reasons) is worse than a noisy Perl=
 script.

Sorry for delay.
Yes, you are right. I will extend description to connect it with that cle=
anup patch
and will also create follow up to enable kgdb in defconfig to be sure tha=
t it is tested regularly.

Applied.

Thanks,
Michal



--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2UBFVMSFWXKQOOTFBOQQL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHKrg0ACgkQykllyylKDCEAsQCfWrHfbSdYcSuDdhTtp/E0UnHo
SPYAoIvQzgVgJs1nojMzUGdQn9vXMdsN
=tpz5
-----END PGP SIGNATURE-----

------enig2UBFVMSFWXKQOOTFBOQQL--
