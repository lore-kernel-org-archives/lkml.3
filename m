Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbaLWXvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:51:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49056 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaLWXvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:51:48 -0500
Date: Tue, 23 Dec 2014 17:51:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, Robert Baldyga <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <m.szyprowski@samsung.com>, <k.opasiak@samsung.com>,
        <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20141223235120.GD32702@saruman>
Reply-To: <balbi@ti.com>
References: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
 <20141223184858.GM9147@saruman>
 <20141223204755.GC19996@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <20141223204755.GC19996@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 23, 2014 at 12:47:55PM -0800, David Cohen wrote:
> On Tue, Dec 23, 2014 at 12:48:58PM -0600, Felipe Balbi wrote:
> > On Thu, Dec 18, 2014 at 09:55:10AM +0100, Robert Baldyga wrote:
> > > Since we can compose gadgets from many functions, there is the problem
> > > related to gadget breakage while FunctionFS daemon being closed. FFS
> > > function is userspace code so there is no way to know when it will cl=
ose
> > > files (it doesn't matter what is the reason of this situation, it can
> > > be daemon logic, program breakage, process kill or any other). So when
> > > we have another function in gadget which, for example, sends some amo=
unt
> > > of data, does some software update or implements some real-time funct=
ionality,
> > > we may want to keep the gadget connected despite FFS function is no l=
onger
> > > functional.
> > >=20
> > > We can't just remove one of functions from gadget since it has been
> > > enumerated, so the only way to keep entire gadget working is to make
> > > broken FFS function deactivated but still visible to host. For this
> > > purpose this patch introduces "no_disconnect" mode. It can be enabled
> > > by setting mount option "no_disconnect=3D1", and results with defering
> > > function disconnect to the moment of reopen ep0 file or filesystem
> > > unmount. After closing all endpoint files, FunctionFS is set to state
> > > FFS_DEACTIVATED.
> > >=20
> > > When ffs->state =3D=3D FFS_DEACTIVATED:
> > > - function is still bound and visible to host,
> > > - setup requests are automatically stalled,
> > > - transfers on other endpoints are refused,
> > > - epfiles, except ep0, are deleted from the filesystem,
> > > - opening ep0 causes the function to be closed, and then FunctionFS
> > >   is ready for descriptors and string write,
> > > - altsetting change causes the function to be closed - we want to keep
> > >   function alive until another functions are potentialy used, altsett=
ing
> > >   change means that another configuration is being selected or USB ca=
ble
> > >   was unplugged, which indicates that we don't need to stay longer in
> > >   FFS_DEACTIVATED state
> > > - unmounting of the FunctionFS instance causes the function to be clo=
sed.
> > >=20
> > > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >=20
> > David, can you test it with your setup ?
>=20
> Works fine on my side.
> Tested-by: David Cohen <david.a.cohen@linux.intel.com>

just to make sure, did you try with and without the new parameter ? I
remember someone complaining about regressions when the new parameter
was used.

cheers

--=20
balbi

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmf/4AAoJEIaOsuA1yqREFGoP/2quQYmCNdBc9FDjQyxTY4S1
XpnrHA8/E64+WgZsilvUEbGBWcryQmlxuARObxvG0fIe199BIk50ddoqg8QBytQX
OdUdfUKtgCZuzb74mA/HMC338p1WdA3aJ4RI5e4QXqmPyRvUA7PDCNP6Kcvb9mg/
T9rFHkn14+p9O0Yq3U/hG+APUZmd1AeVUjOYJk5oR9ZSTj/m7DicTQIKkarm0lTn
06kyZ+CwBlivaIc1rX78SFrPAPMrJxLyienyTkK1O+ycs0pnHg86Du9pkik1ldA9
sLKtUN8X6HtVjmWi59Qf9Gt7BqePSpw471015leYl7cBlRSLY5SiV1Oo3oGRbU7d
oD01RLYbaEbwpB1bdj58VE5K934z7piZfyGbCnfaEknYxXnSsEFUgNhORzofN5tb
iyjkLB8YFyPH0joLLZZhVHQkJ3nSFxCef8OgfQkbjB5H4apNJeqmRb6VM02fu5Rq
tn7swGoZA5sc7rMSVZFIP+4xeDTzNE0q6PfIgAdM9nXB1uhyZQkXxUWlI7S8mWn4
D8epHUcut7dV4w1aBt6vZg+B2hoc9/cmq9IsjD4M8J0cRgk4B1Ot3QliJk0BdKYT
mhKDSJilEIzwHcdzjj2S6WdHwKOoiQZWB959daCLtntPDoB5DG0VKeeMaLY8xCXl
8RouNvW+rtOutASVZKgg
=6gjW
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
