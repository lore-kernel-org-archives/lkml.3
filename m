Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaDGUKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:10:53 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:40388 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaDGUKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:10:52 -0400
Message-ID: <53430646.40507@archlinux.org>
Date: Mon, 07 Apr 2014 22:10:46 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
        Andi Kleen <ak@linux.intel.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, tpowa@archlinux.org
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <52E4CF03.8030208@archlinux.org> <5339F739.2060207@archlinux.org> <20140331233450.GI32556@tassilo.jf.intel.com> <5339FC62.8060207@archlinux.org> <20140405011332.GR32556@tassilo.jf.intel.com> <5340134B.4010705@archlinux.org> <20140407173016.GU32556@tassilo.jf.intel.com> <5342E46B.4080603@archlinux.org>
In-Reply-To: <5342E46B.4080603@archlinux.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IBjtP6pDi2aSsNFghw68b9u67OFH9Wsqg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IBjtP6pDi2aSsNFghw68b9u67OFH9Wsqg
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 07.04.2014 19:46, schrieb Thomas B=E4chler:
> Am 07.04.2014 19:30, schrieb Andi Kleen:
>>>> Do you have a specific config?
>>>> Specific compiler version?
>>>
>>> Using gcc 4.8 from Arch Linux with the configuration at [1] and Linux=
 3.14.
>>
>> I tested this configuration (with gcc 4.8 on FC20/19) and it loads
>> ext4 and all the other modules without any problems.
>>
>> Base tree:=20
>>
>> commit e06df6a7eae1ab1ef4deb076aeeaed90e948e5c0
>> Merge: c0fc3cb 9dd721c
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Mon Mar 31 12:34:49 2014 -0700
>>
>> Must be something really archlinux specific. Please do some debugging.=

>> Also please double check that all your test procedures are correct.
>=20
> Tetsuo was so kind to install Arch Linux and reproduce the exact
> procedure I use to create the kernel (which includes the automated
> creation of a pristine build environment) - his kernel booted just fine=
=2E
> I will do more tests today on two of my own computers to narrow this do=
wn.

I think I found out why nobody could reproduce the problem.

I did a few more tests and it turns out that the problem only occurs
when I boot the kernel with UEFI (using Gummiboot+EFISTUB). Now, except
for OVMF virtual machines, there are barely any 32 Bit UEFI machines
around, so nobody noticed. When I boot the kernel with 32 Bit BIOS, it
boots fine.

Just to clarify: As mentioned in my first mail, some symbols still get a
0x0 CRC (which I still think is wrong), but the mismatch does not occur
in BIOS mode.

On x86_64, the problem does not occur at all.



--IBjtP6pDi2aSsNFghw68b9u67OFH9Wsqg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTQwZIAAoJEChPw0yOSxolydUQAMlqW+SSvpwxC60euqj9ALA1
FSpMhkEYYh1xeIKUVM2gJfZA3CP8arcArFe6pBCRRfG5vuBSNzAA6SUBQM14Gjuy
zLWmMnUZeKWI6OyVusUEAyzm4wyMAwo/ADNmJBd+bt3M+3K2/TpdozsDzc/hsDAF
dGSBvfeOMHjJ+5kBY3myFQ/yCjMM929+Pa24i+mC4XM/DxWruBMjC/k3C8pU+C5C
2zF3DLbZU/Rgm5VsP0gK9Q/1x78zah4zBBhp0Ov3zJd1K+r7uSDL2UOQ9XJKui99
uAnUsQTOd+tg7HKudBqnxSLX/wcvrTRsvukKXEl6Oy1z4pbi7ESpftuDfQ1k9vfc
C5hI4q8yMY71y/d2tZXfaDYL3PCHmc/aVkf4nzZMgpsu6zwv6r6YJBySPFgMqW0F
xLCptuMGmEadrORPPPdo7dTmelZ11w/CB7AcKxsS8k0kpuCCRhXr8rEiZN0AluoW
XQwlY5sD4OPkdISn7d+AfALps/72WYBKvVxeMSNcyqnYAou6FddQLwtPsSVKIov1
kjKpMiDkmFn+46J5dc2kx6xhOcHTKFVoC5YT3ojKh0qod70mXE2dHOkfPQ8jHDUV
CExBEHFAiLmUZU48dqxKjbDqIHsGtDdi2vE15dRNWzZ974jT290buZtJ8hS1Ykog
jGGgo6ygwB72wPtDiJyF
=jBEI
-----END PGP SIGNATURE-----

--IBjtP6pDi2aSsNFghw68b9u67OFH9Wsqg--
