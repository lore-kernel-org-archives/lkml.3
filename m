Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbaJ3OAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:00:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57255 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760179AbaJ3OAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:00:33 -0400
Date: Thu, 30 Oct 2014 08:57:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: <dinguyen@opensource.altera.com>
CC: <paulz@synopsys.com>, <balbi@ti.com>, <dinh.linux@gmail.com>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv6 2/8] usb: dwc2: Move gadget probe function into
 platform code
Message-ID: <20141030135740.GC6482@saruman>
Reply-To: <balbi@ti.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-3-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <1414538749-14735-3-git-send-email-dinguyen@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 06:25:43PM -0500, dinguyen@opensource.altera.com wr=
ote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>=20
> This patch will aggregate the probing of gadget/hcd driver into platform.=
c.
> The gadget probe funtion is converted into gadget_init that is now only
> responsible for gadget only initialization. All the gadget resources is n=
ow

s/resources is/resources are

> handled by platform.c
>=20
> Since the host workqueue will not get initialized if the driver is config=
ured
> for peripheral mode only. Thus we need to check for wq_otg before calling
> queue_work().

this period character in the middle of the sentence doesn't make sense,
perhaps a comma is what you want ? The sentence can be improved too:

"Since the host workqueue will not get initialized if the drier is
configured for peripheral mode only, we add a check for wq_otg before
calling queue_work()."

> Also, we move spin_lock_init to common location for both host and gadget =
that
> is either in platform.c or pci.c.
>=20
> We also ove suspend/resume code to common platform code, and update it to=
 use
> the new PM API (struct dev_pm_ops).

updating to dev_pm_ops should really be a separate patch.

--=20
balbi

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUkPUAAoJEIaOsuA1yqREDggP/AxqV/35QDxjDPBltHctGKH4
iMtQpej6aZrAnrMv+A9INoyXFQ8rY6YEN93/FcCFzuluLo+yHPRsjK6LohTNLb+N
MABpinRaIOPPHaM1ExSwh25dD53Ea9qn7atrz+lNJ7Jw8pfV0jrV7ZAlnO83K3YP
gVjaEC0WCEhBdrHrPzLYhqJLh8nazADHKtBqiaiaKfx+mQ4ugXHHASjop8rMsB++
xXs05AtIatWahnXHZR9APZsfBxCauMzQ7EORoitVRtYb63QDQT354lKTPzee4n8D
ZQL+1emcrSUe3Hd1G5thoUdGWbWyvUfxHUDi7+a9j4p+ZV7A2/2aD0M5MXUoyW2P
b2U2U4MMjowr9LDChOs2dreiwj1rn9BeY4s/Y6m7eim5QnTI9W5IAPCosoJTcauv
YM1tgTfahC8Z14H+zuWx+DEFo+ZkIoXynDCjD57d6q5ldQbzmUbkAQ4krsfENtgx
733ao6qB0qdUCoIdULB4mOyKFgVuZVU0al2O4aDc8kWVZ1aoIE+ud8Pql+teNXr9
5P7iwqyN+QjvYQUo6sLs6xq8QPbAon+nH6F3Agq+t+1KuVRaj6fqlSvzmKK3ioJl
T93l32oljGjmCvtAVMZDKj37DtCI9CSeqahgwk6lwj158cOLlkxKyeWw7ThWN7zN
+e2KorlED5JlHdxy3evv
=GLkx
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
