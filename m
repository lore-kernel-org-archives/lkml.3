Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab3KZRRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 12:17:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48413 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264Ab3KZRQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 12:16:59 -0500
Date: Tue, 26 Nov 2013 11:16:06 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        <freemangordon@abv.bg>, Sebastian Reichel <sre@ring0.de>
Subject: Re: BUG: usb: obex in g_nokia.ko causing kernel panic
Message-ID: <20131126171606.GO24310@saruman.home>
Reply-To: <balbi@ti.com>
References: <201311191151.17153@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m46qSNjkc66Ye11q"
Content-Disposition: inline
In-Reply-To: <201311191151.17153@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--m46qSNjkc66Ye11q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 19, 2013 at 11:51:12AM +0100, Pali Roh=E1r wrote:
> Hi!
>=20
> For a long time (since 3.5 or 3.8? - I do not remember) obex
> subdriver in g_nokia usb gadget module causing kernel panic after
> module is loaded on Nokia N900. I do not know where is problem
> and due to immediatelly kernel crash when loading driver I was
> not able to see any dmesg output. Now I was able to store
> something into mtd log and here is crash backtrace:
>=20
> Log Entry 437 (at position 52)
> <4>[   18.606414] [<c037eac0>] (__schedule+0x5c/0x50c) from [<c037d3bc>] =
(schedule_timeout+0x1f4/0x25c)
> <4>[   18.623809] [<c037d3bc>] (schedule_timeout+0x1f4/0x25c) from [<c037=
f12c>] (wait_for_common+0xc8/0x1ac)
> <4>[   18.649291] [<c037f12c>] (wait_for_common+0xc8/0x1ac) from [<c028c1=
c0>] (omap_i2c_xfer+0x338/0x488)
> <4>[   18.674499] [<c028c1c0>] (omap_i2c_xfer+0x338/0x488) from [<c028814=
4>] (__i2c_transfer+0x40/0x74)
> <4>[   18.692047] [<c0288144>] (__i2c_transfer+0x40/0x74) from [<c0288a2c=
>] (i2c_transfer+0x6c/0x90)
> <4>[   18.709320] [<c0288a2c>] (i2c_transfer+0x6c/0x90) from [<c02351c8>]=
 (regmap_i2c_read+0x48/0x68)
> <4>[   18.726715] [<c02351c8>] (regmap_i2c_read+0x48/0x68) from [<c023161=
c>] (_regmap_raw_read+0x128/0x220)
> <4>[   18.752685] [<c023161c>] (_regmap_raw_read+0x128/0x220) from [<c023=
17b4>] (regmap_raw_read+0xa0/0x130)
> <4>[   18.779052] [<c02317b4>] (regmap_raw_read+0xa0/0x130) from [<c02319=
3c>] (regmap_bulk_read+0xf8/0x16c)
> <4>[   18.805694] [<c023193c>] (regmap_bulk_read+0xf8/0x16c) from [<c0238=
ea8>] (twl_i2c_read+0xa4/0xe0)
> <4>[   18.823730] [<c0238ea8>] (twl_i2c_read+0xa4/0xe0) from [<c0274d34>]=
 (__twl4030_phy_power.isra.12+0x1c/0x58)
> <4>[   18.850921] [<c0274d34>] (__twl4030_phy_power.isra.12+0x1c/0x58) fr=
om [<c0274df0>]=20
> (twl4030_phy_power.part.14+0x80/0xc8)
> <4>[   18.879699] [<c0274df0>] (twl4030_phy_power.part.14+0x80/0xc8) from=
 [<c0274f9c>]=20
> (twl4030_set_suspend+0x54/0x1e8)
> <4>[   18.908325] [<c0274f9c>] (twl4030_set_suspend+0x54/0x1e8) from [<c0=
27c8c4>]=20
> (omap2430_runtime_resume+0x5c/0x64)
> <4>[   18.937042] [<c027c8c4>] (omap2430_runtime_resume+0x5c/0x64) from [=
<c0225dd0>]=20
> (pm_generic_runtime_resume+0x2c/0x38)
> <4>[   18.966461] [<c0225dd0>] (pm_generic_runtime_resume+0x2c/0x38) from=
 [<c0229fe0>] (__rpm_callback+0x54/0x80)
> <4>[   18.995117] [<c0229fe0>] (__rpm_callback+0x54/0x80) from [<c022a04c=
>] (rpm_callback+0x40/0x74)
> <4>[   19.013610] [<c022a04c>] (rpm_callback+0x40/0x74) from [<c022b3c8>]=
 (rpm_resume+0x448/0x63c)
> <4>[   19.031921] [<c022b3c8>] (rpm_resume+0x448/0x63c) from [<c022b2e4>]=
 (rpm_resume+0x364/0x63c)
> <4>[   19.050140] [<c022b2e4>] (rpm_resume+0x364/0x63c) from [<c022b874>]=
 (__pm_runtime_resume+0x48/0x74)
> <4>[   19.077728] [<c022b874>] (__pm_runtime_resume+0x48/0x74) from [<c02=
7b4fc>] (musb_gadget_pullup+0x1c/0xb4)
> <4>[   19.105895] [<c027b4fc>] (musb_gadget_pullup+0x1c/0xb4) from [<bf02=
5c14>] (usb_function_deactivate+0x54/0xa4=20
> [libcomposite])
> <4>[   19.135955] [<bf025c14>] (usb_function_deactivate+0x54/0xa4 [libcom=
posite]) from [<bf05b3b8>]=20
> (obex_bind+0x124/0x1d8 [usb_f_obex])
> <4>[   19.166870] [<bf05b3b8>] (obex_bind+0x124/0x1d8 [usb_f_obex]) from =
[<bf025794>] (usb_add_function+0x58/0xf4=20
> [libcomposite])
> <4>[   19.197143] [<bf025794>] (usb_add_function+0x58/0xf4 [libcomposite]=
) from [<bf037420>]=20
> (nokia_bind_config+0x204/0x250 [g_nokia])
> <4>[   19.227905] [<bf037420>] (nokia_bind_config+0x204/0x250 [g_nokia]) =
=66rom [<bf0263fc>] (usb_add_config+0x28/0xc0=20
> [libcomposite])
> <4>[   19.258483] [<bf0263fc>] (usb_add_config+0x28/0xc0 [libcomposite]) =
=66rom [<bf03709c>] (nokia_bind+0x9c/0x21c=20
> [g_nokia])
> <4>[   19.288421] [<bf03709c>] (nokia_bind+0x9c/0x21c [g_nokia]) from [<b=
f0275bc>] (composite_bind+0x74/0x180=20
> [libcomposite])
> <4>[   19.318420] [<bf0275bc>] (composite_bind+0x74/0x180 [libcomposite])=
 from [<c027d658>]=20
> (udc_bind_to_driver+0x2c/0xc4)
> <4>[   19.348114] [<c027d658>] (udc_bind_to_driver+0x2c/0xc4) from [<c027=
d764>] (usb_gadget_probe_driver+0x74/0x94)
> <4>[   19.377166] [<c027d764>] (usb_gadget_probe_driver+0x74/0x94) from [=
<c00086f8>] (do_one_initcall+0x94/0x138)
> <4>[   19.406005] [<c00086f8>] (do_one_initcall+0x94/0x138) from [<c007a4=
60>] (load_module+0x113c/0x13c4)
> <4>[   19.434051] [<c007a460>] (load_module+0x113c/0x13c4) from [<c007a7b=
4>] (SyS_init_module+0xcc/0xec)
> <4>[   19.462127] [<c007a7b4>] (SyS_init_module+0xcc/0xec) from [<c000dd4=
0>] (ret_fast_syscall+0x0/0x30)
> <0>[   19.490753] Code: 0a00002e e1a00004 eb001438 e598300c (e5d3202c)=20
> <4>[   19.506805] ---[ end trace 060b62ec0d68a78b ]---
> <0>[   19.523132] Kernel panic - not syncing: Fatal exception in interrupt
>=20
> (above dump is from 3.12-rc5 kernel)

looks like it's trying to do i2c transfers from atomic. But why only
when obex is enabled ? Makes no sense. What do you have on userland ? Is
there anything trying to access the obex interface ? Was the USB cable
attached at that time ?

--=20
balbi

--m46qSNjkc66Ye11q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlNdWAAoJEIaOsuA1yqREORoQAJcuGpjdxUNlfyqxNQ+QvXwS
btnnzoi31kiUPXY7+YV5laNH4LQHL6MFiRl/hyxAhmBO/vjEHEewVWUVUyG5piH0
PHaEpafoLWhNhdSTPZQbmr4SiaphtUnLTP9H4C7Meusea6MLVY/d9uCE/yJ1bse7
7m3WIsvCn6FnedNDK9VE9f6FLnkDx7NxgVgoFsOXx26N73Fb/j2q0rVXzVfm6OYP
Dv0GZIVrmcWF4vvF6jVfF51h1TaTIs5eSyWjjJn9F8VX7cEzpH5aYBxUhFLukTeQ
DnnKi3u2m28b4hErWqugYy3uEQMAy26ot1+EuaOUH0Vhg4I737GG1bZZM8hPxwYK
tGPvfGpQ0TQwuzF9Mb5oQ49EtdUXMXmcfZysea4zMKMOXjDIVcWQENBfODSOK2h2
VAHHVoSTwbUbCGkQKhuPozgPeJPU5m1450bYw6xI9KmJKsxUGShaz7ADVD+L/6UZ
4VUyHc6Iay2nnzqMv1jBS7LKOTz6D4G4J3GHLP9eKsU1fe8XCPtd6Sr77E/rwWM5
EVA31/Ac6N4bAeUvFcVxt05mGfLyW1dCzSTjaJYFWqEa4uwmmVJgJq76YxX2zJXe
dvGzTxbiPxSKNpziiAaigWy5afoRirbqQ1TxgB+hoYvw000S1M5MWKgq9087e+Sd
Dsg4nrpN6suTDp7Diiz4
=MPJo
-----END PGP SIGNATURE-----

--m46qSNjkc66Ye11q--
