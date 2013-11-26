Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab3KZR2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:28:11 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36318 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317Ab3KZR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:28:09 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Date: Tue, 26 Nov 2013 18:28:05 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        freemangordon@abv.bg, Sebastian Reichel <sre@ring0.de>
References: <201311191151.17153@pali> <20131126171606.GO24310@saruman.home>
In-Reply-To: <20131126171606.GO24310@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3362009.eVJ3pPRsDJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311261828.05990@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3362009.eVJ3pPRsDJ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 26 November 2013 18:16:06 Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Nov 19, 2013 at 11:51:12AM +0100, Pali Roh=C3=A1r wrote:
> > Hi!
> >=20
> > For a long time (since 3.5 or 3.8? - I do not remember) obex
> > subdriver in g_nokia usb gadget module causing kernel panic
> > after module is loaded on Nokia N900. I do not know where
> > is problem and due to immediatelly kernel crash when
> > loading driver I was not able to see any dmesg output. Now
> > I was able to store something into mtd log and here is
> > crash backtrace:
> >=20
> > Log Entry 437 (at position 52)
> > <4>[   18.606414] [<c037eac0>] (__schedule+0x5c/0x50c) from
> > [<c037d3bc>] (schedule_timeout+0x1f4/0x25c) <4>[ =20
> > 18.623809] [<c037d3bc>] (schedule_timeout+0x1f4/0x25c) from
> > [<c037f12c>] (wait_for_common+0xc8/0x1ac) <4>[   18.649291]
> > [<c037f12c>] (wait_for_common+0xc8/0x1ac) from [<c028c1c0>]
> > (omap_i2c_xfer+0x338/0x488) <4>[   18.674499] [<c028c1c0>]
> > (omap_i2c_xfer+0x338/0x488) from [<c0288144>]
> > (__i2c_transfer+0x40/0x74) <4>[   18.692047] [<c0288144>]
> > (__i2c_transfer+0x40/0x74) from [<c0288a2c>]
> > (i2c_transfer+0x6c/0x90) <4>[   18.709320] [<c0288a2c>]
> > (i2c_transfer+0x6c/0x90) from [<c02351c8>]
> > (regmap_i2c_read+0x48/0x68) <4>[   18.726715] [<c02351c8>]
> > (regmap_i2c_read+0x48/0x68) from [<c023161c>]
> > (_regmap_raw_read+0x128/0x220) <4>[   18.752685]
> > [<c023161c>] (_regmap_raw_read+0x128/0x220) from
> > [<c02317b4>] (regmap_raw_read+0xa0/0x130) <4>[   18.779052]
> > [<c02317b4>] (regmap_raw_read+0xa0/0x130) from [<c023193c>]
> > (regmap_bulk_read+0xf8/0x16c) <4>[   18.805694]
> > [<c023193c>] (regmap_bulk_read+0xf8/0x16c) from
> > [<c0238ea8>] (twl_i2c_read+0xa4/0xe0) <4>[   18.823730]
> > [<c0238ea8>] (twl_i2c_read+0xa4/0xe0) from [<c0274d34>]
> > (__twl4030_phy_power.isra.12+0x1c/0x58) <4>[   18.850921]
> > [<c0274d34>] (__twl4030_phy_power.isra.12+0x1c/0x58) from
> > [<c0274df0>] (twl4030_phy_power.part.14+0x80/0xc8)
> > <4>[   18.879699] [<c0274df0>]
> > (twl4030_phy_power.part.14+0x80/0xc8) from [<c0274f9c>]
> > (twl4030_set_suspend+0x54/0x1e8)
> > <4>[   18.908325] [<c0274f9c>]
> > (twl4030_set_suspend+0x54/0x1e8) from [<c027c8c4>]
> > (omap2430_runtime_resume+0x5c/0x64)
> > <4>[   18.937042] [<c027c8c4>]
> > (omap2430_runtime_resume+0x5c/0x64) from [<c0225dd0>]
> > (pm_generic_runtime_resume+0x2c/0x38)
> > <4>[   18.966461] [<c0225dd0>]
> > (pm_generic_runtime_resume+0x2c/0x38) from [<c0229fe0>]
> > (__rpm_callback+0x54/0x80) <4>[   18.995117] [<c0229fe0>]
> > (__rpm_callback+0x54/0x80) from [<c022a04c>]
> > (rpm_callback+0x40/0x74) <4>[   19.013610] [<c022a04c>]
> > (rpm_callback+0x40/0x74) from [<c022b3c8>]
> > (rpm_resume+0x448/0x63c) <4>[   19.031921] [<c022b3c8>]
> > (rpm_resume+0x448/0x63c) from [<c022b2e4>]
> > (rpm_resume+0x364/0x63c) <4>[   19.050140] [<c022b2e4>]
> > (rpm_resume+0x364/0x63c) from [<c022b874>]
> > (__pm_runtime_resume+0x48/0x74) <4>[   19.077728]
> > [<c022b874>] (__pm_runtime_resume+0x48/0x74) from
> > [<c027b4fc>] (musb_gadget_pullup+0x1c/0xb4) <4>[ =20
> > 19.105895] [<c027b4fc>] (musb_gadget_pullup+0x1c/0xb4) from
> > [<bf025c14>] (usb_function_deactivate+0x54/0xa4
> > [libcomposite])
> > <4>[   19.135955] [<bf025c14>]
> > (usb_function_deactivate+0x54/0xa4 [libcomposite]) from
> > [<bf05b3b8>] (obex_bind+0x124/0x1d8 [usb_f_obex])
> > <4>[   19.166870] [<bf05b3b8>] (obex_bind+0x124/0x1d8
> > [usb_f_obex]) from [<bf025794>] (usb_add_function+0x58/0xf4
> > [libcomposite])
> > <4>[   19.197143] [<bf025794>] (usb_add_function+0x58/0xf4
> > [libcomposite]) from [<bf037420>]
> > (nokia_bind_config+0x204/0x250 [g_nokia])
> > <4>[   19.227905] [<bf037420>]
> > (nokia_bind_config+0x204/0x250 [g_nokia]) from [<bf0263fc>]
> > (usb_add_config+0x28/0xc0 [libcomposite])
> > <4>[   19.258483] [<bf0263fc>] (usb_add_config+0x28/0xc0
> > [libcomposite]) from [<bf03709c>] (nokia_bind+0x9c/0x21c
> > [g_nokia])
> > <4>[   19.288421] [<bf03709c>] (nokia_bind+0x9c/0x21c
> > [g_nokia]) from [<bf0275bc>] (composite_bind+0x74/0x180
> > [libcomposite])
> > <4>[   19.318420] [<bf0275bc>] (composite_bind+0x74/0x180
> > [libcomposite]) from [<c027d658>]
> > (udc_bind_to_driver+0x2c/0xc4)
> > <4>[   19.348114] [<c027d658>]
> > (udc_bind_to_driver+0x2c/0xc4) from [<c027d764>]
> > (usb_gadget_probe_driver+0x74/0x94) <4>[   19.377166]
> > [<c027d764>] (usb_gadget_probe_driver+0x74/0x94) from
> > [<c00086f8>] (do_one_initcall+0x94/0x138) <4>[   19.406005]
> > [<c00086f8>] (do_one_initcall+0x94/0x138) from [<c007a460>]
> > (load_module+0x113c/0x13c4) <4>[   19.434051] [<c007a460>]
> > (load_module+0x113c/0x13c4) from [<c007a7b4>]
> > (SyS_init_module+0xcc/0xec) <4>[   19.462127] [<c007a7b4>]
> > (SyS_init_module+0xcc/0xec) from [<c000dd40>]
> > (ret_fast_syscall+0x0/0x30) <0>[   19.490753] Code:
> > 0a00002e e1a00004 eb001438 e598300c (e5d3202c) <4>[ =20
> > 19.506805] ---[ end trace 060b62ec0d68a78b ]--- <0>[ =20
> > 19.523132] Kernel panic - not syncing: Fatal exception in
> > interrupt
> >=20
> > (above dump is from 3.12-rc5 kernel)
>=20
> looks like it's trying to do i2c transfers from atomic. But
> why only when obex is enabled ? Makes no sense. What do you
> have on userland ? Is there anything trying to access the
> obex interface ? Was the USB cable attached at that time ?

Yes, only when initliaizing obex. Other is ok. Problem is there=20
with Maemo userland and also with clean userland (rescueOS) where=20
is only busybox and some simple init scripts. On Maemo maybe=20
something is trying to access obex, but on rescueOS for sure=20
nothing. Problem happends when cable is attached and also when=20
not =3D always.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart3362009.eVJ3pPRsDJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKU2iUACgkQi/DJPQPkQ1JslwCgnJ0FPNNDJGpwo9QMYtXzDZFT
KqkAnRaYm3+yyIzrM1wEnWHv88IotJj5
=g88J
-----END PGP SIGNATURE-----

--nextPart3362009.eVJ3pPRsDJ--
