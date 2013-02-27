Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3B0IGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:06:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49163 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab3B0IG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:06:28 -0500
Date: Wed, 27 Feb 2013 10:06:18 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>,
        <sylvester.nawrocki@gmail.com>, <tomasz.figa@gmail.com>
Subject: Re: [PATCH 2/4] USB: dwc3: Adjust runtime pm the dwc3 driver to
 allow runtime suspend
Message-ID: <20130227080617.GD8016@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-3-git-send-email-gautam.vivek@samsung.com>
 <20130128114554.GE28698@arwen.pp.htv.fi>
 <CAFp+6iFcZwu3=2u5ig_F14UKxTXwb2Czrv3JjCqR6QGLPHzFqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OROCMA9jn6tkzFBc"
Content-Disposition: inline
In-Reply-To: <CAFp+6iFcZwu3=2u5ig_F14UKxTXwb2Czrv3JjCqR6QGLPHzFqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OROCMA9jn6tkzFBc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

sorry for the delay

On Mon, Jan 28, 2013 at 07:06:56PM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Mon, Jan 28, 2013 at 5:15 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Mon, Jan 28, 2013 at 05:12:26PM +0530, Vivek Gautam wrote:
> >> The current code in the dwc3 probe effectively disables runtime pm
> >> from ever working because it calls a get() that was never put() until
> >> device removal.  Change the runtime pm code to match the standard
> >> formula and allow runtime pm to function.
> >>
> >> Note that this doesn't enable full runtime pm on the DWC3 device in
> >> that the port isn't put into a lower power mode when not used.
> >> However it does allow users of dwc3 (like dwc3-exynos) to do some
> >> amount of runtime power management.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >>  drivers/usb/dwc3/core.c |    4 +++-
> >>  1 files changed, 3 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> >> index 3a4004a..59c2494 100644
> >> --- a/drivers/usb/dwc3/core.c
> >> +++ b/drivers/usb/dwc3/core.c
> >> @@ -453,6 +453,7 @@ static int dwc3_probe(struct platform_device *pdev)
> >>       if (of_get_property(node, "tx-fifo-resize", NULL))
> >>               dwc->needs_fifo_resize =3D true;
> >>
> >> +     pm_runtime_set_active(dev);
> >
> > this usage of pm_runtime_set_active() actually makes me a bit scared. At
> > least OMAP starts with the device switched off, so this will probably
> > break OMAP at least.
>=20
> I am fine with dropping pm_runtime_set_active(), actually thought
> to put device in active state so that as and when system finds it idle,
> force into suspend state.
>=20
> I fact should i drop  pm_runtime_set_active() calls from other places too
> (xhci-plat, dwc3-exynos, and samsung-usb3 phy) and call get_sync() alongw=
ith
> enable() ?

that's correct, make sure it works fine for you ;-)

--=20
balbi

--OROCMA9jn6tkzFBc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRLb55AAoJEIaOsuA1yqREepoP/jCPKn/Xg63Ne1Rk7nfdEUUz
7Z+t2PCdxCdqSQIL/mo0yydkSO4aBozmxoXqPKOpALa8xa008GnIFW0+Hbl5Wn6G
G1o/E23GWFZEOuhhNzLmo5eNf8hIzCkWKjdvdcjPBLvtJ8vUN7LAYc8anF+HoF6k
PPIn6NSnEUj1/j2jmC3RXYXwnGo0iNgjp8S32H3eu4QU4GFg7jakZyR5VxFkTQ7F
u0XC8YAGleiPjqiEAkSXA57MJUj9XD0/bE5KYvXkTMdiGh9NTxc3uF5ke00FJ1qR
mxYWyAz/pBy4K9xJGq8YMkZKK3p/5K8YjSgk0ETHbKx4fjQw5B/2eGpUATK9EmMx
hn5fTruT7Z9sIsbZy0cqP2MY89wZwYf898u7Ibw8ZRwkCUw6Pwbx8rGMEiEPF18x
51r34jLQ89aViG5kLAik49g2HkHx/HRxr6sxMSv8vTg4rQMQaX9vzjkgu3m3hRO8
H+MkLNUcr0e/TVkvAPd9tWmMw1+5Jmt89kg4bfhwjy4EoZ84htT+EjHvE3RPIfWj
yga/J4WtzFqL1m4InX4HepQGLS/IeVcycwbH96JUJj4PRZT2xGNNEdRCEYI75Gkj
mtly4g1EWflqs5GwVcysA7/JYRYn1Pcb3qACxCUFN1SHDgPA2o+sNzNlRG05t56E
/l+AwSiCyP883Mj592pc
=EVen
-----END PGP SIGNATURE-----

--OROCMA9jn6tkzFBc--
