Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3JVKuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 06:50:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40576 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372Ab3JVKuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 06:50:12 -0400
Date: Tue, 22 Oct 2013 11:50:01 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arokux X <arokux@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, peter.chen@freescale.com,
        Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg KH <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: When USB PHY framework should be used?
Message-ID: <20131022105001.GQ3041@lukather>
References: <CAPNxggauvgpWR5HK4Z-Osv7-mB-Tf3-vfyXQDMiTx08K2M=nJQ@mail.gmail.com>
 <52579592.1020209@ti.com>
 <CAPNxgga6xSPrGPWnKJuamMURQdrX0_Hkhx_ZDdS2dcUgs72EKw@mail.gmail.com>
 <52591F7A.1020400@ti.com>
 <CAPNxggbJkXK_RhaWSfXZKFc=iy-2UmkEukCsbOUzYSmbcqmoKw@mail.gmail.com>
 <5264EDB7.6030104@ti.com>
 <CAPNxggbs6hJtPA+2kqg34D8kV73BdNft2kZdMhUKtsAD=SsCnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGw25I70SdcL9+dm"
Content-Disposition: inline
In-Reply-To: <CAPNxggbs6hJtPA+2kqg34D8kV73BdNft2kZdMhUKtsAD=SsCnA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGw25I70SdcL9+dm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2013 at 01:19:46PM +0200, Arokux X wrote:
> Dear Kishon,
>=20
> thank you for the answer, no problem it was late! Your understanding
> is almost correct.
>=20
> > From whatever I could understand, you have a USB HOST controller (each =
HOST
> > controller has an EHCI controller and a companion OHCI controller?). Th=
ere are
> > separate clocks for each of EHCI and OHCI controller. EHCI and OHCI has
> > separate PHYs. Both these PHYs are fed by the same common clock. And yo=
u have a
> > separate reset bits for each of the PHYs.
>=20
> EHCI and OHCI have the same PHY. And this PHY has a reset bit. This is
> exactly what bothers me. Because there should be something central to
> both EHCI and OHCI which manages this reset bit, i.e. the bit should
> be cleared if and only if both EHCI and OHCI controllers are unloaded
> (as modules). I have done a nice picture of the hardware here, please
> take a look at it:
>=20
> http://linux-sunxi.org/User:Arokux#USB_Host_Hardware
>=20
> I've just realized that there is another commo thing for EHCI and OHCI
> - a GPIO which turns on the power to the USB_VBUS. The power should be
> supplied if at least one of the EHCI or OHCI is loaded. This again
> needs some central management.
>=20
> So to summarize, I have two things (reset bit and GPIO for the
> USB_VBUS) which are common to EHCI and OHCI and need to be managed
> outside of the EHCI/OHCI bus glue drivers. My exact question is: where
> this management should be done? Are there good examples in the kernel
> already?

It looks to me like all of these are just different registers of the
same controller. So to me, you should have a single driver for it, that
manages both the reset, regulators and clocks, and loads both the ohci
and ehci layers. bcma-hcd seems to be doing exactly that for example.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ZGw25I70SdcL9+dm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSZlhZAAoJEBx+YmzsjxAgW5YQAJH/9t415Hdv4ro2MyuQn7ek
PWpOljJujBOzdEmVjNUGv4wR13fl1kZ5pYvF5eUApoGue86X49nD5kweOdrFoiCY
/PACFlA+K9txq5gT/T1HFsmo8Qfh1gS7IJfIYJ79GCJWiEJ1/ElpnDgvbldSR563
t+mjg3EG6PG7NzjCvw1HfmOX89FiuCx91Hhmal0l/alD/Z3VvFr7hl4vHGa/m8rP
lQdwGfE362WvNUkJxkPqFDzO+ybia3yXd2DMVmdKa8m9d6v91Ye9Q9Wfsgb+DrIF
t6oz26xP1lZopaHSV6rIFDlHUVKeDr1DGp+IpUSdkuC1mCUahZFab/FftK7jd+1G
bRSm+dPrYs/xsYYWhDrROJIVZsjWiQFUJ+JcbgI5NdqNC0rCczT7YSX3ZzTWn0nt
uVkv3XBQACWJZEjpm7Vc6ATTCzyVdFInyKrb0J7GFkyHH78rU3DB4RSz9zYrYxqn
wLq5RFgqRXEjX7SZ1rsQwTe4WOOicEgLuxq2iHbbozNEpvcvLwiryU0Gqd9u9yZj
7TYVkgIujZaZf8guCQcsljLp8zLOQCLgc+DDuo7lSU0AXxe/7meb+84VTvjwoEjv
bHDiOcDaGkRXbbE8bS3OIQ5b3rDWge+Jwp2RaRUfNK8lKmDFS0TQjC1g3hr6RMQO
m/I/5N4w0vn8Xx5MJ+Sd
=HQfe
-----END PGP SIGNATURE-----

--ZGw25I70SdcL9+dm--
