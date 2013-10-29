Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3J2Ndb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:33:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36499 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3J2Nd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:33:29 -0400
Date: Tue, 29 Oct 2013 08:34:00 -0500
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/2] usb: gadget: re-introduce gadget_is_dwc3()
Message-ID: <20131029133400.GG2776@gimli>
Reply-To: <balbi@ti.com>
References: <1383009180-23236-1-git-send-email-david.a.cohen@linux.intel.com>
 <1383009180-23236-2-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ik0NlRzMGhMnxrMX"
Content-Disposition: inline
In-Reply-To: <1383009180-23236-2-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ik0NlRzMGhMnxrMX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 28, 2013 at 06:12:59PM -0700, David Cohen wrote:
> gadget_is_dwc3() is necessary to check whether we are running on
> Desineware USB3 DRD controller.
>=20
> This macro was previously removed by commit
> ed9cbda63d45638b69ce62412e3a3c7b00644835 due to it wasn't needed
> anymore. We're adding it again as things have changed.
>=20
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  drivers/usb/gadget/gadget_chips.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/usb/gadget/gadget_chips.h b/drivers/usb/gadget/gadge=
t_chips.h
> index bcd04bc..3186a5e 100644
> --- a/drivers/usb/gadget/gadget_chips.h
> +++ b/drivers/usb/gadget/gadget_chips.h
> @@ -28,6 +28,7 @@
>   * do that for you.
>   */
>  #define gadget_is_at91(g)		(!strcmp("at91_udc", (g)->name))
> +#define gadget_is_dwc3(g)		(!strcmp("dwc3-gadget", (g)->name))

NAK, we want to get rid of all of them, in fact. gadget drivers
shouldn't have to know which controller they're running on, they need to
know about quirks and features the controller supports.

--=20
balbi

--ik0NlRzMGhMnxrMX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSb7lIAAoJEIaOsuA1yqREn+wP/1Fm1lotvqu0VzsHi3sev984
CFfQFUn3CPzvsxFJHxwtWFXzX/Hg1cd6Kg2EDFACTzmUfL1q2eh7UVJGCIX4g5MT
yfjCCQkBXWbQ9IZWs0gOg84sFsybBnHoIP/W+w/bamFngBLlFa53ObitY+9PyPlV
OnPL/Zk86XN+N75r45Oo4fNZ+5UaGNc61TLny98pRnsGDATQCFJ2FQDX7xY7ewXu
8TfvdTkH9ci5Uh3PDmcXXG1HsUGRvYvZCh23axpO7soCZhKnGV1U5LYzIyJaK4JT
xrF5P+/6ajVC4I8sxT4DnSLfaw9xqom79wbpx/zDC6votmqGrG8EPVF2q7fhT/QS
D0G8zswahMLlIfpCFYrGaLGnKYrfLx1hhSJHXdM275h0aftxO0p/SBGxNoZcZypP
jW0e1bw9Dxl2/rzOazhTsnJQ8Zkta6I7HGeTcQ8UPU1GlG3P2OR/P8DThr3I8Fp6
v7oEcldETlukszlHvxf4Y/8+unPezcLCsSWCIy7orVxcesQdbR8fB8I5BvBp/lKJ
8yHb7NFIBAHuz234oM+AFIocsHS5LcyvG5G/pTGH/45U02lAQ2yssNffQ6jR8ga9
V12PVmrNRQ9UqnUHm6ydHO+Ne4oRfB4CkpT01Gb+ZCx3ypfrkgOdYxpA4ZnHU401
nbDEgXnG6/UWSKUA1OHj
=9gh1
-----END PGP SIGNATURE-----

--ik0NlRzMGhMnxrMX--
