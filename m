Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBXF4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:56:30 -0500
Received: from ozlabs.org ([203.10.76.45]:36095 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaBXF41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:56:27 -0500
Date: Mon, 24 Feb 2014 16:56:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20140224165621.843089bb746605469e016e5d@canb.auug.org.au>
In-Reply-To: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Feb_2014_16_56_21_+1100_Ps8xTYS//EHHoWgh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Feb_2014_16_56_21_+1100_Ps8xTYS//EHHoWgh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 24 Feb 2014 15:17:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I guess that there may be more places where "asmlinkage" is used with
> "static" - I assume that they are all incorrect?
>=20
> $ git grep -l 'static.*asmlinkage'
> arch/x86/crypto/sha1_ssse3_glue.c
> arch/x86/crypto/sha256_ssse3_glue.c
> arch/x86/crypto/sha512_ssse3_glue.c

In fact, my x86_64 allmodconfig build produces these:

arch/x86/crypto/sha1_ssse3_glue.c:43:1: warning: 'externally_visible' attri=
bute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha1_transform_asm)(u32 *, const char *, unsigned=
 int);
 ^
arch/x86/crypto/sha256_ssse3_glue.c:56:1: warning: 'externally_visible' att=
ribute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha256_transform_asm)(const char *, u32 *, u64);
 ^
arch/x86/crypto/sha512_ssse3_glue.c:55:1: warning: 'externally_visible' att=
ribute have effect only on public objects [-Wattributes]
 static asmlinkage void (*sha512_transform_asm)(const char *, u64 *, u64);
 ^
mm/process_vm_access.c:422:1: warning: 'externally_visible' attribute have =
effect only on public objects [-Wattributes]
 {
 ^

That last is added by commit 700d00f85598 ("mm/process_vm_access.c: mark
function as static") from the akpm-current tree.

So is "static asmlinkage" not allowed?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Feb_2014_16_56_21_+1100_Ps8xTYS//EHHoWgh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTCt8JAAoJEMDTa8Ir7ZwVQhUP/jvRl/dKkzKay9jMWvxw/5wQ
gs7vi1q6rdjLMT8GRWf3n4xTNZJHjg8M3FE3COFcACLoZEyWfobhPGbiblZVZB4m
OTEaW09ucGWSSkhm6zjDPjSgAPZF7SlGYIejJyjAHq4u7QvlcFFhsOIPOBJ2wpFC
MvL7wpEXDC2EmUZ6RpN2aci/bsKp0QTQfKljk/8h/6SwjM8SL8BPFcVH+ffD9aJJ
8USVsOs/IpzFonu3q+8QsfILP0WXIoQ5+MHiJkSgwgw78ejk2F+iLEG8NSAhzdYq
lUcJb5MJYTs1si+xLLrXneWMYhuruk2NQ/tMSVIigy6zrfRGxWdwo/wcg33+sPNF
bpaibOJN1Wuqp3f/3goAUIg4y51v8tgzoBHGNxebWObZH3xfEF5au2bYypay2pBK
joS1txQ4q71xrw3PriqWHNlXSMq4xQVpN51MlMQWWeUQZF3FINOOXbFzmGFX5X/m
ro6NtfUDLzwIUigxn1vwvg7aEglubusUQJtZZJSW+MgZjVXlJf89z/DyRU71I2pl
1CrtsynbQDJzsmVbB/Q5p7YBehlA6EzH/p/Blo18CUMTAB9bzPSRC1dux91giivf
LBwz9Y/sHjd9laODCeEiPDLzO3lZ7ODb020kxGnYfox5NK7g6b/23xH4DfaKMv68
aVtM9d4HQlBBgzdxFeSJ
=e1kR
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Feb_2014_16_56_21_+1100_Ps8xTYS//EHHoWgh--
