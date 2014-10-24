Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbaJXQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:09:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35102 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756015AbaJXQJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:09:57 -0400
Date: Fri, 24 Oct 2014 11:08:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Felipe Balbi <balbi@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        <nsekhar@ti.com>, <t-kristo@ti.com>, <j-keerthy@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/20] rtc: omap: fixes and power-off feature
Message-ID: <20141024160845.GM26941@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1413913086-12730-1-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HxQt9wRz9wbL5Edg"
Content-Disposition: inline
In-Reply-To: <1413913086-12730-1-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HxQt9wRz9wbL5Edg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 21, 2014 at 07:37:46PM +0200, Johan Hovold wrote:
> This series fixes a few issues with the omap rtc-driver, cleans up a
> bit, adds device abstraction, and finally adds support for the PMIC
> control feature found in some revisions of this RTC IP block.
>=20
> Ultimately, this allows for powering off the Beaglebone and waking it up
> again on RTC alarms.
>=20
> Changes since v1 include:
>=20
>  - add device abstraction
>  - add structured device-type info
>  - fix interrupt disable at probe separately
>  - register interrupts after class device as before
>  - add helper to read raw bcd time
>  - more clean ups
>  - add copyright entry
>  - enable pmic control only for Beaglebone Black
>=20
> I realised that it was better to keep this patch series self-contained
> and include the device abstraction in it, rather than rely on some
> patches yet to be posted (contrary to what I proposed in v1). It should
> now be straight forward to add deferred-probing and regulator support on
> top of this series instead. [1]
>=20
> I've kept Felipe's Reviewed-by tags only on the first and last couple of
> patches which have not changed (in any significant way).
>=20
> For the record, the new functionality is easily tested on BBB with:
>=20
> 	echo +30 >/sys/class/rtc/rtc0/wakealarm; poweroff
>=20
> There are some patches floating around to add power-off handler
> call chains [2] as well as an RFC for a generic "poweroff-source"
> property [3]. Since it is unclear if, when (and through which tree) this
> will eventually go in, I suggest merging this series as-is now and do
> the trivial updates to use these new interfaces once the infrastructure
> is in place.

I tested this entire series with my BBB and it still works fine. However
I still get below panic. This time without any DRM errors:

[   63.087832] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000000
[   63.087832]=20
[   63.097399] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.18.0-rc1-0=
0095-g8524e69 #556
[   63.106060] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_stac=
k+0x20/0x24)
[   63.114160] [<c00132f0>] (show_stack) from [<c0657404>] (dump_stack+0x8c=
/0xa4)
[   63.121706] [<c0657404>] (dump_stack) from [<c0654f70>] (panic+0xa0/0x22=
0)
[   63.128895] [<c0654f70>] (panic) from [<c0049e64>] (do_exit+0x974/0x9d0)
[   63.135900] [<c0049e64>] (do_exit) from [<c006775c>] (SyS_reboot+0x14c/0=
x1e8)
[   63.143361] [<c006775c>] (SyS_reboot) from [<c000f080>] (ret_fast_syscal=
l+0x0/0x48)
[   63.151596] ---[ end Kernel panic - not syncing: Attempted to kill init!=
 exitcode=3D0x00000000

Then again, this also happens by simply calling poweroff without
enabling wakealarm.

In any case, for the whole series:

Tested-by: Felipe Balbi <balbi@ti.com>


--=20
balbi

--HxQt9wRz9wbL5Edg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSnmNAAoJEIaOsuA1yqREp18P/iLnSEuLHjHKG9Uf2i/cuu4f
jW0RkduPYcTZ6zMlk1hoVIyXI1m7TL5gysD0887DoxotclFE/XWuNrz5EKectWIX
nd1T6IcAgDiFP93SWRJEzL5wRNEaurkiQpifj0/00WcDEsCD8agivPk63KxWcOG4
bTs9m0WRI+PjVhul5spR1rxkZMyLt4yhzIcePpsOqZefK9sVK+o+7dnl0kSyOZo0
vwYVLSjAyKbySslxOIxDMNvbfjwdPcBh2L/A+qnkjGzfFCd9Ylnpg7XH7CCgpCXL
dlcILZHjWmxln9sx30tCoRmhgXGvgmdEfNqwfJxIEMUl/W6ACRk5orxrmHF0bTwd
fFfiSD1k2qbsM4Arn/Zuy7P9VZeCaJqhsE7JnmtpjJuf46UUth6xwZooxu3yqG99
OO3tWADLABjs0pvrrTHpskMY4TzUmWWI3pYENxOf7IXVMqRhd557dvSFXjn7rd/1
YQJz8u85dswWI/sUPA779LUDNZSVwq7idE+hlVjGxYG4Ts8tV2wztF5Pyxs9aMlD
ulgkaehd/KvEi/rTejKjUwaw6Wc89yGL1a6Xd4prsFz4ZmLFAI5rIcEouN7PS3ch
HgdUts86TqOZ1kiWxqvejdQcF3+L2I7aIl33XMSaIkpyF4jAQX8Kq9uoOdJtEIvN
bPcVdp58T7F+6pPGNjhL
=NX4z
-----END PGP SIGNATURE-----

--HxQt9wRz9wbL5Edg--
