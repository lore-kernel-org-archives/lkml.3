Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaJORJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:09:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53389 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaJORJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:09:36 -0400
Date: Wed, 15 Oct 2014 12:08:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/12] rtc: omap: fixes and power-off feature
Message-ID: <20141015170832.GD15770@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <20141015165452.GB15770@saruman>
 <20141015170628.GA13824@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oiv9uiLrevHtW1RS"
Content-Disposition: inline
In-Reply-To: <20141015170628.GA13824@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Oiv9uiLrevHtW1RS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2014 at 07:06:28PM +0200, Johan Hovold wrote:
> On Wed, Oct 15, 2014 at 11:55:02AM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Oct 09, 2014 at 09:06:22PM +0200, Johan Hovold wrote:
> > > This series fixes a few issues with the omap rtc-driver, cleans up a =
bit
> > > and finally adds support for the PMIC control feature found in some
> > > revisions of this RTC IP block.
> > >=20
> > > Ultimately, this allows for powering off the Beaglebone and waking it=
 up
> > > again on RTC alarms.
> > >=20
> > > I noticed yesterday that Lokesh Vutla recently posted some patches to
> > > add regulator support to this driver. [1] While that series has some
> > > issues that needs to be addressed, I still think it could be a good i=
dea
> > > to rebase my pmic_power_en patch on top of it as it adds some long
> > > overdue device abstraction. That would be needed anyway in order to
> > > support the new power-off infrastructure that's in the pipe in a clean
> > > way. [2]
> > >=20
> > > So my suggestion is to merge the first seven patches, rebase Lokesh
> > > series on top of that, and then I rebase my final five patches on top
> > > of that in turn. Hopefully, the new power-off handler call chain will
> > > have stabilised by then.
> >=20
> > BTW, how do you test this series ?
>=20
> Set a 30 second wakealarm using the sysfs attribute of the rtc class
> device and power off the BBB:
>=20
> 	echo +30 >wakealarm; poweroff

sweet!!!! It worked just fine :-)

Too bad there's yet another DRM bug:

[  271.150158] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000000
[  271.150158]=20
[  271.159725] CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 3.17.0-08392=
-g7fe2269-dirty #326
[  271.168567] [<c00175a4>] (unwind_backtrace) from [<c00132f0>] (show_stac=
k+0x20/0x24)
[  271.176668] [<c00132f0>] (show_stack) from [<c06573a4>] (dump_stack+0x8c=
/0xa4)
[  271.184215] [<c06573a4>] (dump_stack) from [<c0654f10>] (panic+0xa0/0x22=
0)
[  271.191405] [<c0654f10>] (panic) from [<c0049e54>] (do_exit+0x974/0x9d0)
[  271.198410] [<c0049e54>] (do_exit) from [<c0067694>] (SyS_reboot+0x14c/0=
x1e8)
[  271.205870] [<c0067694>] (SyS_reboot) from [<c000f080>] (ret_fast_syscal=
l+0x0/0x48)
[  271.214023] drm_kms_helper: panic occurred, switching back to text conso=
le
[  271.221312] ---[ end Kernel panic - not syncing: Attempted to kill init!=
 exitcode=3D0x00000000

In any case, board still powered up after 30 seconds(-ish). So this gets
a:

Tested-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--Oiv9uiLrevHtW1RS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPqoQAAoJEIaOsuA1yqREMD0P/03vjisF9WL1IfFIpeehMHRg
NCOVn17TYM2WTzdbIUmQ1H4uZFC7eu2mBc2yeKViNMid/x2KeDhWtoSbPPJU1xWc
Pxqgl6cPMtsu30+veMTYKVqixm5dUlIyLo7o1aSZA1zzFMZmUd04DN+fyzZQ4OVr
bDHa4us7IGQQHu313+77sRCGWlyvC9IYXbR0l/nFSuAi7DZfszq0i170fGrZcWmW
99893KGsnZWGnMdqH4R5SceEpZjIBxV7rIhSLa+2BB1TehvTSJEJOJYPrzZGlA94
5czhtsxdErmVsRJb2pjogE2YA+TfovVj8Bqi5F85wkoZFOFFcGTsVBaHCpYjek3m
Dq3JXcVJwVIrTniaa35liIQdyPnLjfCP8x3URwk8iYXhEs7WzDrvI9qi+n/8CrRh
Q0oxReRrtbZH3/vmtejm9e35z+28AfVwzvtEl/upG1ozl042Vv9JoOvtPiGTIoq0
9oUIzYreH4tk4aQK8xnCFAVNe8tVogJMYoGpIqQ6+3khlZHcINvg32X6Nv16l+ed
ATFfhBkp5dM5bX1E9SvgdAtHGICkf20hRUW4cKX9Ta9tH6vBebbvZEUVTjgQZm8g
G6RXKrSmypcpixZuEz+OLEOqEeoLrBNRK9PEu+pf4A9/S3Qcl0R5FKC3BddglXSb
a8ayWskm6tjGe8Uxqrom
=O9U4
-----END PGP SIGNATURE-----

--Oiv9uiLrevHtW1RS--
