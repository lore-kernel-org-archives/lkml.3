Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbaDHUE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:04:57 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:51334 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbaDHUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:04:56 -0400
Message-ID: <53445660.1010908@archlinux.org>
Date: Tue, 08 Apr 2014 22:04:48 +0200
From: =?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: matt.fleming@intel.com, ak@linux.intel.com, viro@zeniv.linux.org.uk,
        geert@linux-m68k.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tpowa@archlinux.org, hpa@zytor.com
Subject: Re: 3.13: <module> disagrees about version of symbol <symbol>
References: <20140407173016.GU32556@tassilo.jf.intel.com> <5342E46B.4080603@archlinux.org> <53430646.40507@archlinux.org> <20140407204221.GW32556@tassilo.jf.intel.com> <CAL01qpvjZz-XnVT+S3E5E2XGcuFoetE5cwnArYfW-TwYZVKtKw@mail.gmail.com> <201404080646.BID87018.SOOVJMFOLFtQHF@I-love.SAKURA.ne.jp> <20140408121400.GI5222@console-pimps.org> <53444681.1070902@archlinux.org>
In-Reply-To: <53444681.1070902@archlinux.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oCDD6ktKvemfxMuTXju8lgL4biWWmHBrX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oCDD6ktKvemfxMuTXju8lgL4biWWmHBrX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 08.04.2014 20:57, schrieb Thomas B=E4chler:
>>>> Thomas, you mention you're running in a 32-bit vm earlier in this
>>>> thread. Any chance you're using ovmf because that would make it much=

>>>> easier to track this down?
>>>>
>>>
>>> I'm not familiar with UEFI boot, but it could happen because what
>>> I experienced with BIOS boot was an address dependent behavior.
>>>
>>> https://lkml.org/lkml/2013/9/4/188
>>
>> OK, that's a pretty good clue, thanks Tetsuo.
>>
>> Thomas, could you try this patch? It seems the use of code32_start in
>> the EFI boot stub was totally wrong for the case where the boot stub
>> relocates the kernel - you're likely to hit this path if using the EFI=

>> boot stub directly from the EFI shell or gummiboot.
>>
>> It was pointing at the start of the kernel image and not the protected=

>> mode code.
>=20
> Hello Matt,
>=20
> I am unable to backport this to 3.14 for lack of assembler magic. While=

> I can test this with git master, I eventually still need a version that=

> is backported to 3.14. Any chance you could provide that, too?

Hello again Matt,

with linux.git master, I cannot reproduce the problem at all (with or
without your patch). In fact, all the 0x0 CRCs on symbols are gone, and
those were the symbols that were broken after all.

FWIW, with your patch the kernel still boots.



--oCDD6ktKvemfxMuTXju8lgL4biWWmHBrX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTRFZjAAoJEChPw0yOSxol/hwP/3vtjDzUbFDmOCoPNO1Qps3y
jvMS0cRb2Ss5azlqNC8BQrgJQncRXjcpMRG85+5CFyOBdQ10bRNGiGGE4EytSCLq
madDztZmDNthq4gJ6lCRZ2EH9Cv5pTFkf2kK/54Ai3zN4nEmgkm9E93SL6899UjD
8QaYZGbsleaw0D6ObVFM8+nHkDft1/063xJUSizgkmMTSfgRKsBaC5LxTr0h51Vk
gTjIpOqNZG2hyh1VzW5B8JMBUPzet0D8KfhCrrrxhXVaJIvAtd+tY63ZXaG/Gnht
8pWxg0W0x6YttB49zKPd5cWwYas/pM9ROWwOZm3/ByoBwqQrWP5ALUr5eCoxEBFl
Hqbqw4UZe4ukCU4yjcZw/qH3S6vcV35y4i989rPah/ZN1zWc1jep1HMgCGh+ji/h
1PYnugezx6hZNgoi6+uJEOFAf7x4/ihpnGt43ypQKthgYRefOjiMH98O9YWgB7Ut
/x/U+n/OWu+EWVr4vjNUfH5+G6rFAWZOBgtD0ov1FnY9dUJOzNy+MqM4xgzG1Vxf
b8si4sIqrOeQhoVD8GFIu5356YW96l43Wd8akT0wh7A5CljlhWHLlb3fjTkY4E/1
581DcGenW9X5RoAsipHkFhqiKYrg200OxfcsFzAMWSK8veAqLoM283eipimGBcFC
/S8ljzgAAo2U5rphGw3x
=lGKE
-----END PGP SIGNATURE-----

--oCDD6ktKvemfxMuTXju8lgL4biWWmHBrX--
