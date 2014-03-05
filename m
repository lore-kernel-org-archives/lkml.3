Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaCEGgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 01:36:09 -0500
Received: from ozlabs.org ([203.10.76.45]:48118 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaCEGgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 01:36:06 -0500
Date: Wed, 5 Mar 2014 17:35:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabian Vogt <fabian@ritter-vogt.de>
Subject: linux-next: build failure after merge of the final tree (gpio tree
 related)
Message-Id: <20140305173559.0b50971a1ab88a16bee8819c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Mar_2014_17_35_59_+1100_7=g7GB2x5dQ=JEng"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Mar_2014_17_35_59_+1100_7=g7GB2x5dQ=JEng
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/gpio/gpio-zevio.c: In function 'zevio_gpio_port_get':
drivers/gpio/gpio-zevio.c:70:2: error: implicit declaration of function 'IO=
MEM' [-Werror=3Dimplicit-function-declaration]
  return readl(IOMEM(c->chip.regs + section_offset + port_offset));
  ^
drivers/gpio/gpio-zevio.c:70:2: warning: passing argument 1 of 'readl' make=
s pointer from integer without a cast [enabled by default]
In file included from include/linux/io.h:22:0,
                 from drivers/gpio/gpio-zevio.c:15:
arch/powerpc/include/asm/io-defs.h:6:16: note: expected 'const volatile voi=
d *' but argument is of type 'int'
 DEF_PCI_AC_RET(readl, u32, (const PCI_IO_ADDR addr), (addr), mem, addr)
                ^
arch/powerpc/include/asm/io.h:577:19: note: in definition of macro 'DEF_PCI=
_AC_RET'
 static inline ret name at     \
                   ^
drivers/gpio/gpio-zevio.c: In function 'zevio_gpio_port_set':
drivers/gpio/gpio-zevio.c:77:2: warning: passing argument 2 of 'writel' mak=
es pointer from integer without a cast [enabled by default]
  writel(val, IOMEM(c->chip.regs + section_offset + port_offset));
  ^
In file included from include/linux/io.h:22:0,
                 from drivers/gpio/gpio-zevio.c:15:
arch/powerpc/include/asm/io-defs.h:11:18: note: expected 'volatile void *' =
but argument is of type 'int'
 DEF_PCI_AC_NORET(writel, (u32 val, PCI_IO_ADDR addr), (val, addr), mem, ad=
dr)
                  ^
arch/powerpc/include/asm/io.h:585:20: note: in definition of macro 'DEF_PCI=
_AC_NORET'
 static inline void name at     \
                    ^

Caused by commit 9af4d80ba566 ("gpio: New driver for LSI ZEVIO SoCs").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__5_Mar_2014_17_35_59_+1100_7=g7GB2x5dQ=JEng
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFsXUAAoJEMDTa8Ir7ZwVWjgP+gKJQJ8fmAsB54yi2Aebdgax
iMxHVY6vyceGMdWFdLeJYSag1i0e02uMHSeyzz8D8fEXr1rqpusXxjgKPkaVwZyj
stDRjzwbMzRreaz4sHdMwlIMnOv6BvAsSEZ5EoaKELLkyDNdMhyE3Ib1DlmM7zCj
o9DVfgdQPMhLhDzzN+BposA8+WfGq77HKpuzFUXtYGA8pACHANb8y+jbAyk8OPYF
DdYJbn2rx1f9oQaHZnZFHNkbcpbqLCdsGbJhdW1whpWxc5Cj/G4qouhuFJzwdUKM
VGLDBeJ3h05eDewgi+DwmIDfkOEME5LmTU+H1hkILMcuJksU5QnTdNaF2gAq+RLV
qB3H4PNHjlHWRZQrF7xO/JqU4GMhBieYc6jYAUMzKwiXp/DOHel4EmV3xCn1eY6C
HPqWQYyx3aoqjrS16xtscqZawJFBgKZ7ZPgYcFE8tCcBE17MljqGlAzjYM5sNr6S
qwuQTr4s88bHaLIdsLwhdB8hUJ/9mk08K1J7ktD3DO8euuqohIU6xrAfECxzW35B
OMm8c/yRXbXZlITYG4KlFIs1rcGAuUMxlDrIUvDqjYBgLmH1+IY0ojS1//VE3d48
69amsCSUkLq+jJT4QdkA+1iAHzleIL4Nd/Y2J/Hcx078MVOCoTiaucH657zzsen2
VYwWoEkq0tbc9qiY2k1l
=4TIf
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Mar_2014_17_35_59_+1100_7=g7GB2x5dQ=JEng--
