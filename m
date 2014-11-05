Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKETm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:42:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58338 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbaKETm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:42:56 -0500
Date: Wed, 5 Nov 2014 13:43:21 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Robert Baldyga <r.baldyga@samsung.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>, <m.szyprowski@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH v4] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20141105194321.GS6548@saruman>
Reply-To: <balbi@ti.com>
References: <1412860911-23985-1-git-send-email-r.baldyga@samsung.com>
 <20141103161102.GM27425@saruman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f0Ums9VvOMUG7syy"
Content-Disposition: inline
In-Reply-To: <20141103161102.GM27425@saruman>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f0Ums9VvOMUG7syy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 10:11:02AM -0600, Felipe Balbi wrote:
> Hi,
>=20
> On Thu, Oct 09, 2014 at 03:21:51PM +0200, Robert Baldyga wrote:
> > Since we can compose gadgets from many functions, there is the problem
> > related to gadget breakage while FunctionFS daemon being closed. FFS
> > function is userspace code so there is no way to know when it will close
> > files (it doesn't matter what is the reason of this situation, it can
> > be daemon logic, program breakage, process kill or any other). So when
> > we have another function in gadget which, for example, sends some amount
> > of data, does some software update or implements some real-time functio=
nality,
> > we may want to keep the gadget connected despite FFS function is no lon=
ger
> > functional.
> >=20
> > We can't just remove one of functions from gadget since it has been
> > enumerated, so the only way to keep entire gadget working is to make
> > broken FFS function deactivated but still visible to host. For this
> > purpose this patch introduces "no_disconnect" mode. It can be enabled
> > by setting mount option "no_disconnect=3D1", and results with defering
> > function disconnect to the moment of reopen ep0 file or filesystem
> > unmount. After closing all endpoint files, FunctionFS is set to state
> > FFS_DEACTIVATED.
> >=20
> > When ffs->state =3D=3D FFS_DEACTIVATED:
> > - function is still bound and visible to host,
> > - setup requests are automatically stalled,
> > - transfers on other endpoints are refused,
> > - epfiles, except ep0, are deleted from the filesystem,
> > - opening ep0 causes the function to be closes, and then FunctionFS
> >   is ready for descriptors and string write,
> > - unmounting of the FunctionFS instance causes the function to be close=
d.
> >=20
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>=20
> David, you have been messing with ffs lately, can I get a Tested-by from
> you on this patch ?

ping. David ? Any chance you can test this one out ?

--=20
balbi

--f0Ums9VvOMUG7syy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWn3ZAAoJEIaOsuA1yqREuM0P/iH++EEFBJJuq+1MyPrGOyw/
5xYRmyWwK6La9C0z3qGaVM4H2MSxvtbWcx/a8zU92tkZH8P/FPIrwUhdgd2gAkaz
j7pAB6cqJM5XBAGsqHzimidlwEy80xJyu2rQW/kmSVlCLkfFN1FGV1YxJl9voFf+
H4pdscGVmMEdOANTYEVDUh90rtpeCoIiKJOHB7zrQl/6v36RGQe4goTaxcmO3AvB
y25nIJEtQdW6a2O+u6gupoOhmCNO00X0/H/sh4x2azDWzwucEjjuCAWCEfmAjfY1
OfR6+1Y5PZe5+tVR/o+w/6ysKO/5XdfSFaCSwfZ+p4LebwCH4OoNNXQFsJ0CnH1Z
ufnKgAtsB+If0OOYAN9BKnzKJbEc976NUkPgqQ3vgfl4z7+o1jPc9JD/TwYgkg6m
TajTrBEqZrd/3KloreyEgIx5GGjy92orAWTDUmnuTubKMfYBvR3WYuyI0LEzsrfu
usJZ5wDE1KWXbvw1V3A+DvS0GQlh3Jb3ECEAI870gcSoxWJ0RZieOZLapBcEK2/q
bWnWblgSHtLEJHXSSYaZkXjKTTPyibM/NTnsNvzCbx3CAN4znIXSZGwLGip+WG32
K68Ne/5zklpr4iSEuqkeeNje39y8okK+O69A9ynnoAAUBqlkyZaiGLA//JaGkQmH
8rHXs4X30zbWUqvLSDpB
=U6wf
-----END PGP SIGNATURE-----

--f0Ums9VvOMUG7syy--
