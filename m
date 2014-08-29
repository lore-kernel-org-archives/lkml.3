Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbaH2Ulv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:41:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36337 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaH2Ult (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:41:49 -0400
Date: Fri, 29 Aug 2014 15:41:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Baldyga <r.baldyga@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yang Wei <Wei.Yang@windriver.com>
Subject: Re: [PATCH 5/5] USB:gadget: Fix a warning while loading
 g_mass_storage
Message-ID: <20140829204134.GB16391@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409173129-19603-1-git-send-email-mina86@mina86.com>
 <1409173129-19603-6-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <1409173129-19603-6-git-send-email-mina86@mina86.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 27, 2014 at 10:58:49PM +0200, Michal Nazarewicz wrote:
> From: Yang Wei <Wei.Yang@windriver.com>
>=20
> While loading g_mass_storage module, the following warning
> is triggered.
>=20
> WARNING: at drivers/usb/gadget/composite.c:
> usb_composite_setup_continue: Unexpected call
> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0=
x20/0x24)
> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_comm=
on+0x64/0x74)
> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slo=
wpath_fmt+0x40/0x48)
> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composi=
te_setup_continue+0xb4/0xbc [g_mass_storage])
> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) fr=
om [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048=
080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004b=
c90>] (kthread+0x98/0x9c)
> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x=
0/0x8)
>=20
> The root cause is that the existing code fails to take into
> account the possibility that common->new_fsg can change while
> do_set_interface() is running, so the value of common->new_fsg
> that gets tested after do_set_interface returns needs to be
> the same as the value used by do_set_interface.
>=20
> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

looks like this is the only fix in this thread. Please refrain from
sending new code and bugfixes on the same thread, specially not as the
last message in the thread.

I'll add this one to my testing/fixes

--=20
balbi

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUAOV+AAoJEIaOsuA1yqRE+SAP/2Jl6RWzFtkDBMfOb2+pflQp
Vmxsb0/dBL7WXGCbEjT9/MDsXA1cf6mwHm4T53NUgLaHThK2Jk9AlmLFx75pX2R0
kOkYfgop3ylDmK5uTLNMaWu4EGFSsDQMPkybVAV637Lib8V3t6KU0+v3UQORNw3q
tg62IvcJsfMpHderjdmxgktZ2DnegFCjvYenoc4c9MD+kdx3QMIFE8qhxai2EQcq
I3rTEJHdVbbFe6aLfHHGRbxnMr7J+lZnd9hANJp95D6JPp7ou1dLJp5sSDcm4y8I
U2BRW/dA9hkdrhpTxolIcrIdDDKeE4CRHrOFYEI9Pw1131s9FvsoCJGUrubaGwwg
YRfWudxSY6GrRROL7agYE1CLzpadxeCSFiloP3dm27NJbT44uY7FNijOtGAT4CTG
2dYgI3ErdYJSMX+c0DCDK2bj4zyGflHUgSYO9epkV1u3liR15arD/C5l2R8TnYds
Acj9SytKZxisNA+WE+LUhY0L9/pdeZiEUFJJw6zBT46z6UewunTaXn5sNNy0R9Bf
f0cZwi9EwqMC/ppjefPFeOalNX60nuNtmz5G8kAJfpaWqLh+Y9rEnB3m1Ve/fG1U
byM2uPEakvjbKwVHzmDopp8FWW6KgmpkQdk8kSEU46lK8kZKiOmcfNwvvXVF1Kk3
RG5TDQ203To/oAt+Bhkx
=tAnk
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
