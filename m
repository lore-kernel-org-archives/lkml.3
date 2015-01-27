Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbbA0Pmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:42:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38410 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbbA0Pmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:42:43 -0500
Date: Tue, 27 Jan 2015 09:42:32 -0600
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <paulz@synopsys.com>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] drivers: usb: dwc2: remove 'force' parameter from
 kill_all_requests()
Message-ID: <20150127154232.GE14623@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1420450295-25818-1-git-send-email-r.baldyga@samsung.com>
 <1420450295-25818-3-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+JUInw4efm7IfTNU"
Content-Disposition: inline
In-Reply-To: <1420450295-25818-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+JUInw4efm7IfTNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2015 at 10:31:35AM +0100, Robert Baldyga wrote:
> This patch fixes in simpler way the bug described in [1] and [2]. It
> looks like DWC2 is the only UDC driver that doesn't force usb requests
> to complete in ep_disable() function. This causes described problem,
> because we have no guarantee that all requests will be completed before
> unbind of usb function.
>=20
> To fix this problem we force all requests of disabled endpoint to complet=
e.
> Also currently running request is not handled. This allowed to simplify
> code of kill_all_requests() function, because 'force' parameter is always
> set to true, so we don't need it anymore.
>=20
> In s3c_hsotg_rx_data() we change function used to print message when acti=
ve
> request is NULL from dev_warn() to dev_dbg(), because such situation is
> harmless for driver and now it can take place during normal endpoint
> disabling.
>=20
> [1] https://lkml.org/lkml/2014/12/9/283
> [2] https://lkml.org/lkml/2014/12/12/360
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>

this fails to apply:

checking file drivers/usb/dwc2/gadget.c
Hunk #1 succeeded at 2602 (offset 35 lines).
Hunk #2 FAILED at 2588.
Hunk #3 succeeded at 2645 (offset 36 lines).
Hunk #4 FAILED at 2924.
2 out of 4 hunks FAILED

--=20
balbi

--+JUInw4efm7IfTNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUx7HoAAoJEIaOsuA1yqREIw4P+wV7VfHBP0qXCSInCVdX2tqz
pm3uj4aY4xf8R3cnjyhS6BVVOqcug0PhX84YBPa12j5Ipd2Fu41UKW6dua7bpvPd
/phW7Hl45OylTuB6i24WF8zloI0CLGT0sKiIxxP6LmhdFsXMCVWOtQ8LssxpPAo3
xmfyK8eMCeVSpFNG3ffEwuLXtgqjJvy6RAyhmen5mrK2en0NJv89KkAR0zTbDhWD
/MhTu3WMA11Q8emgPb17fcT+eZ46T0fcyYtF7O81XaB7bo7k0+N9vLFgHVY+0GVf
Hg5XQ1bBzmZjdkolaidT7IBZvPeCPLUAoKEbaAo3ZtB9DnNRqcTo3hg2TM6LzDml
QIegCQih+3vES5xfFzUHxEPgNzSMykGInsAcUpmHPFhSKyEgAiRgi6Cv6EJmbb3q
SpqRmUo0s9gz/2hgEwrMqUrKewz7XDbDPB3vJqAWaJ27heHQodt/Zre4v/RPFmEs
t51GXUJnFqHPjq+thsYU37zdpwkNjn4vNcX0uuEyjCJBbS1haPOyPsECDnyv1d0p
LxJFa8WSzhVxmjtYhzS0he451qJ0SsKV7cB/G0UkTwT4CQMKUtRKRXLFqTGFFUMH
o/GLajKNxZ4HRHH5hhJm+4EodVditLnF2FNY9Ay9DZS37ss7u+r/eqVRD6Ob7MwB
+yYOL01rGVR/tcNcDqbi
=Sckg
-----END PGP SIGNATURE-----

--+JUInw4efm7IfTNU--
