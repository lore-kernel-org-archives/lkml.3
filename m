Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbbAMQdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:33:24 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53209 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbAMQdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:33:22 -0500
Date: Tue, 13 Jan 2015 10:32:16 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <m.szyprowski@samsung.com>, <k.opasiak@samsung.com>,
        <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5] usb: gadget: f_fs: add "no_disconnect" mode
Message-ID: <20150113163216.GH16533@saruman>
Reply-To: <balbi@ti.com>
References: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzX0AQGjRQPusK/O"
Content-Disposition: inline
In-Reply-To: <1418892910-23890-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NzX0AQGjRQPusK/O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 18, 2014 at 09:55:10AM +0100, Robert Baldyga wrote:
> Since we can compose gadgets from many functions, there is the problem
> related to gadget breakage while FunctionFS daemon being closed. FFS
> function is userspace code so there is no way to know when it will close
> files (it doesn't matter what is the reason of this situation, it can
> be daemon logic, program breakage, process kill or any other). So when
> we have another function in gadget which, for example, sends some amount
> of data, does some software update or implements some real-time functiona=
lity,
> we may want to keep the gadget connected despite FFS function is no longer
> functional.
>=20
> We can't just remove one of functions from gadget since it has been
> enumerated, so the only way to keep entire gadget working is to make
> broken FFS function deactivated but still visible to host. For this
> purpose this patch introduces "no_disconnect" mode. It can be enabled
> by setting mount option "no_disconnect=3D1", and results with defering
> function disconnect to the moment of reopen ep0 file or filesystem
> unmount. After closing all endpoint files, FunctionFS is set to state
> FFS_DEACTIVATED.
>=20
> When ffs->state =3D=3D FFS_DEACTIVATED:
> - function is still bound and visible to host,
> - setup requests are automatically stalled,
> - transfers on other endpoints are refused,
> - epfiles, except ep0, are deleted from the filesystem,
> - opening ep0 causes the function to be closed, and then FunctionFS
>   is ready for descriptors and string write,
> - altsetting change causes the function to be closed - we want to keep
>   function alive until another functions are potentialy used, altsetting
>   change means that another configuration is being selected or USB cable
>   was unplugged, which indicates that we don't need to stay longer in
>   FFS_DEACTIVATED state
> - unmounting of the FunctionFS instance causes the function to be closed.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
>=20
> Changelog:
>=20
> v5:
> - close function on altsetting change
>=20
> v4: https://lkml.org/lkml/2014/10/9/224
> - use ffs_data_reset() instead of ffs_data_clear() to reset ffs data
>   properly after ffs->ref refcount reach 0 (or under in no_disconnect
>   mode) in ffs_data_put() function
>=20
> v3: https://lkml.org/lkml/2014/10/9/170
> - change option name to more descriptive and less scary,
> - fix cleaning up on unmount (call ffs_data_closed() in ffs_fs_kill_sb(),
>   and ffs_data_clear() in ffs_data_closed() if ffs->opened is negative).
>=20
> v2: https://lkml.org/lkml/2014/10/7/109
> - delete epfiles, excepting ep0, when FFS is in "zombie" mode,
> - add description of FFS_ZOMBIE state,
> - minor cleanups.
>=20
> v1: https://lkml.org/lkml/2014/10/6/128

This changelog should be after the tearline, I've manually editted it
and also applied the small modification sugested by Michal. It should
show up on my testing/next soonish.

--=20
balbi

--NzX0AQGjRQPusK/O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtUiQAAoJEIaOsuA1yqREqzgP/1/jTRFPvjn5CHYxNEF/Tp9Z
SsKR0DS31lROQvB5vz5UE1J2HAI6l7Dfz4jbN/WbTJMMK116FQsiNAFDtOxnCa0A
BCRyyPJMux62VczN8NRNsIh+d8RI2CQAsNX1KdatEwABUYUq6QDWMldFkWLaJzED
gEQZrdFXF8osXMNusKLHYsWjqpTKzOUTkGRk3cixrq1sRhIg0ZPl81MljMrerzir
3iTBVyzS+vHzDUMHTsZszuKQ62+o0O3D/+UpsC/qPPlr+qKhsXVS51L7x3CUgeDu
mFls27Dh6+xADhCm7fOTbahfdm4LjlKQFc2Shhe6aEhho0sww0FCYazPltitjZT8
eVVqxRRdDaLlYj6umALVgX18Vi8iSxHTd+eKf7tzOGwv2/mRTeT/PM8f6hWjvqDs
NdZP1OtcL4kICZfnPnpxM/ciBjb1Dty6h7zcMLroAqQCpaiwdQ+OrrOxdYSCmsa/
xYUQ/rWqE6Hwc5iR4P6NktFKYpHQM96gRCpwM68IAREl7eps+ARNlqv9b3w8PWDr
faB/EwSav+iEYzqUNUxXS55M4Tx85QdV4ny7U9sBOpSCBKhq4CKvu5Q+/LQAvtUX
1VxjtMw3uAqBqBGt/cp9pXaVRtAP1+lRsDdKx40aHVHph0hAgWezRh2bB/GP51P/
T8y4mEGV3jmm/Fiwoezd
=e6gC
-----END PGP SIGNATURE-----

--NzX0AQGjRQPusK/O--
