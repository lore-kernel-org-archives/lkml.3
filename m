Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaIERid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:38:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38523 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaIERib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:38:31 -0400
Date: Fri, 5 Sep 2014 12:38:11 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        <k.opasiak@samsung.com>
Subject: Re: [PATCH v7 2/2] usb: gadget: f_fs: virtual endpoint address
 mapping
Message-ID: <20140905173811.GJ24449@saruman.home>
Reply-To: <balbi@ti.com>
References: <1409812338-16012-1-git-send-email-r.baldyga@samsung.com>
 <1409812338-16012-3-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fKov5AqTsvseSZ0Z"
Content-Disposition: inline
In-Reply-To: <1409812338-16012-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fKov5AqTsvseSZ0Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 04, 2014 at 08:32:18AM +0200, Robert Baldyga wrote:
> This patch introduces virtual endpoint address mapping. It separates
> function logic form physical endpoint addresses making it more hardware
> independent.
>=20
> Following modifications changes user space API, so to enable them user
> have to switch on the FUNCTIONFS_VIRTUAL_ADDR flag in descriptors.
>=20
> Endpoints are now refered using virtual endpoint addresses chosen by
> user in endpoint descpriptors. This applies to each context when endpoint
> address can be used:
> - when accessing endpoint files in FunctionFS filesystemi (in file name),
> - in setup requests directed to specific endpoint (in wIndex field),
> - in descriptors returned by FUNCTIONFS_ENDPOINT_DESC ioctl.
>=20
> In endpoint file names the endpoint address number is formatted as
> double-digit hexadecimal value ("ep%02x") which has few advantages -
> it is easy to parse, allows to easly recognize endpoint direction basing
> on its name (IN endpoint number starts with digit 8, and OUT with 0)
> which can be useful for debugging purpose, and it makes easier to introdu=
ce
> further features allowing to use each endpoint number in both directions
> to have more endpoints available for function if hardware supports this
> (for example we could have ep01 which is endpoint 1 with OUT direction,
> and ep81 which is endpoint 1 with IN direction).
>=20
> Physical endpoint address can be still obtained using ioctl named
> FUNCTIONFS_ENDPOINT_REVMAP, but now it's not neccesary to handle
> USB transactions properly.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

this one does't apply to my testing/next. Can you please rebase ?

--=20
balbi

--fKov5AqTsvseSZ0Z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCfUDAAoJEIaOsuA1yqRErHcP/j4jvCGiKnY0tS/SGyEYiIce
Wq6Lt2619PGXq8pxP4qh2P+WCqKPJB1GKU2QVsI3GYpPBgUvwgF+0ONHIiDv1pDm
X4jKwZ5TfsHq74mifkTWfkHLjsXl6rNhsGbwLuhXassItZh4Lhkgci+U044Kyi7T
Cjnj/6/hQ4AOfy1ZYNpFZUy3TDNIIZxcoIRu+/pC9hF9Lij+azFpEnYv7cyeClc0
KapQLu6kubVlpcZ4KiXDBBd99lFEfexnFpM+hac9avwcfmpfiWi2ktNuTj2bdbY5
IFX0k91Zj/wlzRka14VobXy72Xwrs8LSS0j2BvHU8YymrA6Rc47DoEn2qfPNB7Up
Y4r74t/y0v30urQiijw06dK2Vum/qMw7Qlhu/L96Ov0OAzm9iwFlhfZZoC3hPFSR
cE8VEEMqbs2zBBRglY8FrSFaY6Y4jryWZR+mHrzAXB6dUfEOsR6RMz/UIH9/jBlT
jeN2bS/15WFR4oD10mnkq4O6NFfF3lSqv8flqbMfQCZWujMD1gu7yt6hJHyPUg1s
/2Q3M+1aDb5LpXokTCtLhw1E1zGP057xNN2gN2OLz7OKR3WX89v/Q6VBK6d6cAw7
J3DDfD75C3ph2BPwAATt/+6Wl/dpGy4FDWQASys/1MgbZogiG0lL+B5xBvASMtmS
qyuN5xVmiYhzgX9j5bQg
=xhei
-----END PGP SIGNATURE-----

--fKov5AqTsvseSZ0Z--
