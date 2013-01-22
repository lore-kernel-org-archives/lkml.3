Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3AVQRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:17:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43272 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3AVQRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:17:33 -0500
Date: Tue, 22 Jan 2013 18:17:21 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Message-ID: <20130122161721.GC10097@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com>
 <201301201117.32096@pali>
 <20130121080506.GA8777@arwen.pp.htv.fi>
 <201301221203.09264@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Content-Disposition: inline
In-Reply-To: <201301221203.09264@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bAmEntskrkuBymla
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 22, 2013 at 12:03:09PM +0100, Pali Roh=E1r wrote:
> On Monday 21 January 2013 09:05:06 Felipe Balbi wrote:
> > Hi,
> >=20
> > On Sun, Jan 20, 2013 at 11:17:31AM +0100, Pali Roh=E1r wrote:
> > > On Sunday 20 January 2013 10:25:37 Felipe Balbi wrote:
> > > > On Sun, Jan 20, 2013 at 03:58:13AM +0100, Pali Roh=E1r wrote:
> > > > > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> > > >=20
> > > > NAK for two reasons:
> > > >=20
> > > > a) the original Nokia kernel used a separate
> > > > g_file_storage gadget to use Mass Storage mode, use that
> > > >=20
> > > > b) there is no commit log
> > >=20
> > > Reason why add mass storage mode to g_nokia is to avoid
> > > switching between g_{file,mass}_storage and g_nokia and to
> > > have one gadget driver for Nokia N900. It is better to have
> > > usb network and mass storage mode in one driver (and not to
> > > unload & load another).
> > >=20
> > > I tested this patch with 3.8-rc3 kernel on Nokia N900 and
> > > usb network with mass storage mode working without
> > > problems.
> >=20
> > Doesn't matter, in this case this is something which nokia
> > wrote to carry on their Maemo/MeeGo devices so unless someone
> > from Nokia says this is how they want to use nokia.c from now
> > on, I can't simply risk breaking all other users for your own
> > convenience.
> >=20
>=20
> Hello,
>=20
> you may know that Nokia not working on any linux Maemo/MeeGo=20
> systems anymore. And also that Nokia devices needs own patched=20
> kernel. Also g_nokia gadget is for Nokia N900 and this device=20
> with original Maemo 5 system which was supported by Nokia is=20
> locked for patched 2.6.28 kernel. More drivers in 2.6.28 was not=20
> upstreamed, so running other kernels will not work without=20
> problems. And waiting what Nokia say is now irrelevant, because=20

nonsense, many guys (including myself) have n900 booting mainline
kernel.

> N900 is at end-of-live cycle and Nokia not doing with linux=20
> devices anymore. So I do not understand why current code cannot=20
> be extended for more functionality. Because patch is not signed=20
> by Nokia?

If I let your change in, you could be breaking the folks who are still
using n900 as their daily device. Remember that Mass Storage access to
the media, prevents phone from using mass storage too and the way Maemo
5 was done is that it will unload mass storage when that's not being
used.

> There are more developers which playing with upstream kernel on=20
> Nokia N900 and trying to use some modern linux distribution on=20
> it. And who using upstream kernels on N900 also want some=20
> additional functionality which was not in 2.6.28. And having mass=20
> storage in g_nokia is usefull.

it makes no difference.

> Also you can see that this patch simply adding new composite=20
> gadget to exisitng driver. Nothing is removed, so original code=20
> is compatible with these changes. If somebody still want (for=20

you could be breaking phone's own access to the memory card.

> some reason) to switching between g_nokia and g_file_storage (ops,=20
> it was renamed to g_mass_storage, so now it is broken on old=20
> Nokia systems...) it is still possible.

no it's not, you can anyways make a symbolic link. Besides, before
removing g_file_storage we waited quite some time.

> And when I looked into nokia 2.6.28 kernel, they also patched=20
> g_file_storage, so I think it is incompatible with upstream too.=20

it's patched only for strings.

> So why to care about current API implementation in upstream=20
> kernel (do not allow to add new functionality) which is=20
> incompatible with Nokia patched kernel?

Because I don't think g_nokia needs mass storage and because I want to
remove all gadget drivers from kernel (keep only function drivers).

--=20
balbi

--bAmEntskrkuBymla
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/ruRAAoJEIaOsuA1yqREN3EP/0LyrO2OlFS65ZcDmqhBT7eu
F/f3K6JrB1G03pP/c0UzCKOKuD0tqXDAUxvY+nCNFE2sormCOrD/06BvKI8K/586
TEZH5pU/7Z7UWFQ6EpYYuDpCfXI2aWX1xTq03XZExMC9v2ah4tT/X2CAL+x5UaQD
XBQ0deELlz2gyIOLbjdDz2PWjdQ6w08KX99qTGaskFYbYmlrfXqA5jO1T1vGAGiu
NcrZ97InbYHulZnF5EcVN0lpIK4Lqva+vtIQs3MeIWsqSnxNaZ0kXd9Njj/vuFJ6
PVns8DdZRU3OzslLX0hm1obu9dyUWUKPmYeCCDq+wLs4feANBql9Rf8dbJ0Lv753
aAbhuUW80eWdPWN3WlJHoTa/53/0zoaFGSVYwIX/zdQ09uryOKhXu5f7nt+ais5+
YCIGhra8TL8Jvzb2LDzBvfgd47mxHpklbHeJUlVYt4pCuq7kw9L5ZmWic6sGrqxL
bVqKWR97OHvL14yPbpjV735EiEDsBJ/rJ7H/Uxbmxb4ARdR9Mnl/0roriKXM+P5t
4zHD7YYV3RZ8hLlA83EA9JedL45AU05LzL3B4zM/WNlq/C+m67RTK3DV5psEo3E1
B19N0cGs6DdMzEwgmso9Wva7THnlDKfEesoxSMXfL6x9ykSgr+ncWZ58Q9trRHYX
NDiuV9kJRYNDP+YmDjWE
=mOQ3
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
