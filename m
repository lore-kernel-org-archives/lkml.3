Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab3FZM64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:58:56 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:34706 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3FZM6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:58:55 -0400
Message-ID: <51CAE58B.8040705@monstr.eu>
Date: Wed, 26 Jun 2013 14:58:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] dma-mapping: Add BUG_ON for uninitialized dma_ops
References: <f35c5051a207b0a117f2fff27365d0ea892d1610.1370263476.git.michal.simek@xilinx.com> <201306141636.29390.arnd@arndb.de> <1371226483.2726.19.camel@dabdike> <201306191720.47185.arnd@arndb.de>
In-Reply-To: <201306191720.47185.arnd@arndb.de>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2KIGTFMMRSCPOBBFWCDGL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2KIGTFMMRSCPOBBFWCDGL
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 06/19/2013 05:20 PM, Arnd Bergmann wrote:
> On Friday 14 June 2013, James Bottomley wrote:
>> This is the MMAP_PAGE_ZERO exploit.  The original exploit relied on a
>> leaky personality capability clearing mask and was fixed in 2.6.31 by
>>
>> commit f9fabcb58a6d26d6efde842d1703ac7cfa9427b6
>> Author: Julien Tinnes <jt@cr0.org>
>> Date:   Fri Jun 26 20:27:40 2009 +0200
>>
>>     personality: fix PER_CLEAR_ON_SETID
>>
>> So it's not really relevant to 3.x kernels, is it?
>=20
> Probably not. There is always a risk that something like this
> can turn into an exploit, but it needs a combination with a couple
> of other bugs.

ok. Let me refresh this thread.
We have middle solution where some functions have this checking
and some not.
Based on get_maintainer scripts Arnd should do that decision
to accept or reject this patch.

Arnd: Can you please decide if you want it or not?
Based on that you can just add this one or we can create new one
which remove BUG_ON(!ops) from that file.

Thanks,
Michal


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2KIGTFMMRSCPOBBFWCDGL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHK5YsACgkQykllyylKDCEb9wCfUf7eEr7loL10RfpNXv2PiTWm
w4QAoJXx9NxrObW9GZV9r9LZSHc9zZcS
=3hxx
-----END PGP SIGNATURE-----

------enig2KIGTFMMRSCPOBBFWCDGL--
