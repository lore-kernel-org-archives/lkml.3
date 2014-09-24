Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaIXBIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 21:08:45 -0400
Received: from ozlabs.org ([103.22.144.67]:52654 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaIXBIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 21:08:43 -0400
Date: Wed, 24 Sep 2014 11:08:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: linux-next: build failure after merge of the samsung tree
Message-ID: <20140924110836.209bc8e2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ORd1ovzNsNEEbmYX6il_y_K"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ORd1ovzNsNEEbmYX6il_y_K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

After merging the samsung tree, today's linux-next build (arm multi_v7_defc=
onfig)
failed like this:

arch/arm/boot/dts/exynos5250-snow.dts:13:46: fatal error: dt-bindings/clock=
/maxim,max77686.h: No such file or directory
 #include <dt-bindings/clock/maxim,max77686.h>
                                              ^

Caused by commit c04c92ed5614 ("ARM: dts: Add rtc_src clk for s3c-rtc on ex=
ynos5250-snow").

In file included from arch/arm/mach-tegra/cpuidle-tegra114.c:17:0:
arch/arm/mach-tegra/cpuidle-tegra114.c: In function 'tegra114_idle_power_do=
wn':
arch/arm/include/asm/firmware.h:64:24: error: too few arguments to function=
 'firmware_ops->do_idle'
  ((firmware_ops->op) ? firmware_ops->op(__VA_ARGS__) : (-ENOSYS))
                        ^
arch/arm/mach-tegra/cpuidle-tegra114.c:52:6: note: in expansion of macro 'c=
all_firmware_op'
  if (call_firmware_op(do_idle) =3D=3D -ENOSYS)
      ^

Caused by commit f5217f3b9332 ("ARM: EXYNOS: add AFTR mode support to
firmware do_idle method").

I have used the samsung tree from next-20140923 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ORd1ovzNsNEEbmYX6il_y_K
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUIhmYAAoJEMDTa8Ir7ZwVNn8P+gNGIhSUNlxImewT3Laemmie
Sn/eFI/pO4+uK6oR7W2C46c8vlFBDeGJLhcS2hSgrvhRD4X2Nv7l8iRkW4HZDEgR
vBofZj4Y1C0c8C/ZuC33COxerEMYoBqVnApVnosNMCU1VQZFX1I5FYA+esnt25MK
7nVcMeFVdsAUkbpiUkAGt6q4/iqncxpfwatCmFUH3or7s2huZWTMS5ScdY7qjssG
43cg0WGmWA/+MsZkKkBoEU22059uwvNQCaMKW8N5OqHujOq+lOVQ+tHipaqym8e1
ymDdiq4Em4qOwR318dEB55BBg/AFBrsmEmaVcgDgzLL4H90ugbwlVTYqMorAvTSR
MxYfNHer+WyQIUR2zCu1WeyMlaqd/2bTjkh9dHP8hlxY7Wh/00soF5Jjcp9mzlFv
1S0gA21bkLkshwYBUcxW+rg0OyXLtY3Gks8cPfqAecdFBu4RNA9rLgctqoyj9SSL
z4y7bJzaPTOt5DaiO0fykaEzvCvLr1K49gj/PVn0yrDuO4JUbjnBCjCxTp+/gyUg
v9Jf0tJNtAhaT8AI0MeUV4uonadca6WUoRYLA3HTt+Fr4oBQOtwsGxd6X9NrBeU0
hOuw9NQQJXFkZmybSgVvyiUxOJhN/vx7JEBFElAJQpEpU5s30azbeDe7UXbPuayf
nJADVflJgVLEH0Jj+5NJ
=qLzR
-----END PGP SIGNATURE-----

--Sig_/ORd1ovzNsNEEbmYX6il_y_K--
