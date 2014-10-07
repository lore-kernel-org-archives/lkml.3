Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaJGC3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 22:29:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36995 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaJGC3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 22:29:03 -0400
Date: Mon, 6 Oct 2014 21:28:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>, <k.opasiak@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
Message-ID: <20141007022851.GA13956@saruman>
Reply-To: <balbi@ti.com>
References: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <1412594714-535-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 06, 2014 at 01:25:14PM +0200, Robert Baldyga wrote:
> Since we can compose gadgets from many functions, there is the problem
> related to gadget breakage while FunctionFS daemon being closed. In some
> cases it's strongly desired to keep gadget alive for a while, despite
> FunctionFS files are closed, to allow another functions to complete
> some presumably critical operations.
>=20
> For this purpose this patch introduces "zombie" mode. It can be enabled
> by setting mount option "zombie=3D1", and results with defering function
> closure to the moment of reopening ep0 file or filesystem umount.
>=20
> When ffs->state =3D=3D FFS_ZOMBIE:
> - function is still binded and visible to host,
> - setup requests are automatically stalled,
> - all another transfers are refused,
> - opening ep0 causes function close, and then FunctionFS is ready for
>   descriptors and string write,
> - umount of functionfs cause function close.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

Can you further explain how do you trigger this ? Do I understand
correctly that you composed a gadget using configfs and that gadget has
functionfs + another gadget ?

Then what do you need to do the trigger the issue, and what really _is_
the issue ? Is gadget disconnecting from host too early ? Do you see a
crash ? Memory leak ? Any logs available ? Any steps to reproduce ?

Quite frankly, I don't really like this "zombie" mode. <joke> I know
there's a "The Walking Dead" hype right now, but this is too much.
</joke>

Anyway, please giver me further details of how to get this done.

--=20
balbi

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUM0/jAAoJEIaOsuA1yqREg/UP/R+WGJvEAtSrLQjwvGxgkdFH
5GO10i18X2TxRNByX3Dm9Z9ROsQDMgjeyyouTI/Syi4A3pPg5wCmmYZ228JaitVD
7DwzMtErx6REPumFV85bnhvLrLtMTzbSNf9EVvxK4xl96i/F+PQxfCMr4+i+Ou0K
Eqkmb1j2xx6Gx404naVg1uBmAnYQaQ9RKvLIk+baPTsDK8R4vB2242NFFLgiduWZ
hrT+IjQM0d7icAvQw1SvJjyoPivzWa+NYjUW8HgpTif+lk04DEYejPw0pBssbN8r
7NsK0bvf4DzwzH6KoIw/MkW8BdA+IIut6cXgBJVFpOcYnb+3H7cOc7zPRmjg9j02
Kgejc2vVhpnu7j2j23aSBY2IS9wPEr3Lm31ahN9w78FTn/OFDOsR5ad5UWA465Jz
PTwF+IJrRgLo9V2bfEwXM9oZIlpoPc49Cizav1CilhQ9IrDn0cUrkjoFPeOqcFoO
1y+5zh01aAhS2zr0QtpqfuSJx2U/1+wKo0uLUfZ3gZlcjJYm6PrcdFgknwikAvPI
wwiokivGxb7SEH+nACADo6h9SdIyXdRyI9q0yuaMC3GfpgLNU+4+ShJglxGDFiod
EhpVyUNu3KJ4bT8F0KyGwR1wigHMVy5SFu4SWdodg+lxwLH+DfndfZg3O4HCiG5r
VaNoninC04df4/DrCk2G
=W4CH
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
