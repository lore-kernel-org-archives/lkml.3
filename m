Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbaC1Qoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:44:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60480 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaC1Qog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:44:36 -0400
Date: Fri, 28 Mar 2014 11:42:35 -0500
From: Felipe Balbi <balbi@ti.com>
To: Julius Werner <jwerner@chromium.org>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>, Jim Lin <jilin@nvidia.com>
Subject: Re: [PATCH] usb: xhci: Correct last context entry calculation for
 Configure Endpoint
Message-ID: <20140328164235.GM17820@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395772963-14127-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dzI2QqkSBOAresgT"
Content-Disposition: inline
In-Reply-To: <1395772963-14127-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dzI2QqkSBOAresgT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 25, 2014 at 11:42:43AM -0700, Julius Werner wrote:
> @@ -2723,8 +2697,19 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, stru=
ct usb_device *udev)
>  			ctrl_ctx->drop_flags =3D=3D 0)
>  		return 0;
> =20
> -	xhci_dbg(xhci, "New Input Control Context:\n");
> +	/* Fix up Context Entries field. Minimum value is EP0 =3D=3D BIT(1). */
>  	slot_ctx =3D xhci_get_slot_ctx(xhci, virt_dev->in_ctx);
> +	for (i =3D 31; i >=3D 1; i--) {
> +		u32 le32 =3D cpu_to_le32(BIT(i));

can you use __le32 instead of u32 here, just to make sure we can make
good use of sparse ?

--=20
balbi

--dzI2QqkSBOAresgT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTNaZ7AAoJEIaOsuA1yqREHNEQAKEoULqA48M49p6W8muCf6tA
3+v1G6Rf3H9MZ+F88oOLnwATsZG/caebX/97VgOIzr77OGGuf7n3xbMhz6d9gHWP
lTgVUuDiVU+o71c/B0A0qZu6+9E4WVqh1MVN/v8Hcp+Dyr1gAI8BKXxIoHAChQAB
1gz5ItjdWabGRpP9UIwsrl02MbXeh0skhbSTrjAcGHwc2DPb3rdZUIw4Ln0EFC85
wiWQ9JMmq2hjhjx8+p/OLdNSZeR32GZzzqKYi0Sx7BxBsR+7bVEhzlm+DezAeRqf
xtA6njKrCzIBOfvMMwyK6iTf0kl+sl7sZBBtLOOxS+m1G/SPu4l4yAWzcXpFuQWS
/8QK9myS0zYQfsw003iOjDG7sDrYlUCP97MHIw8rO/zP5+XCNqgnUQYQJPqGSKZU
+8SHxLVXC2EJjXmyxD42eyzzuSSC+jXRJuiAx0OaUdkLb+qzkpX8rX5UyxQNlxOK
P1fn3CAPzTJG6b5O/4JtCBoQOhBrFwZjpoPBYWJT1GLpap9YUdKNkuR2Kxfwph3S
4RWaL+T6YNXS4lsLX7TZeMSPJ2+/U198WKj4GtIiz4TabMVzZOm+W9jxNPFTKmSx
Dz9IQ2A8uW00955PNzOuLCrvMtD10BuOmGIhOtKqF0XnUofYdRE1h8GpAon+1znV
eFgwryJKkPcHqvElU1gJ
=La4o
-----END PGP SIGNATURE-----

--dzI2QqkSBOAresgT--
