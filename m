Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3AVJcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:32:45 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59597 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3AVJcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:32:42 -0500
Date: Tue, 22 Jan 2013 11:32:14 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Vivek Gautam <gautamvivek1987@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <p.paneri@samsung.com>,
        <cpgs@samsung.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250
Message-ID: <20130122093214.GK16143@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
 <053c01cdf860$9e98df20$dbca9d60$@samsung.com>
 <20130122085004.GD16143@arwen.pp.htv.fi>
 <CAFp+6iEoCF91HiDbixqsKX5XS_UQrN=+2O7puPqN1MvjY_eHBg@mail.gmail.com>
 <20130122092947.GJ16143@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IJAclU0AInkryoed"
Content-Disposition: inline
In-Reply-To: <20130122092947.GJ16143@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IJAclU0AInkryoed
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Tue, Jan 22, 2013 at 11:29:47AM +0200, Felipe Balbi wrote:
> On Tue, Jan 22, 2013 at 02:45:26PM +0530, Vivek Gautam wrote:
> > Hi Felipe,
> >=20
> >=20
> > On Tue, Jan 22, 2013 at 2:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> > > HI,
> > >
> > > On Mon, Jan 21, 2013 at 09:23:28PM -0800, Kukjin Kim wrote:
> > >> Vivek Gautam wrote:
> > >> >
> > >> > Changes from v5:
> > >> >  - Rebased on top of latest patches:
> > >> >         usb: phy: samsung: Introducing usb phy driver for hsotg (v=
9)
> > >> >         usb: phy: samsung: Add support to set pmu isolation (v6)
> > >> >    As a result adding hostphy enable mask and hostphy register off=
sets
> > >> >    to driver data in order to access the HOSTPHY CONTROL register.
> > >> >
> > >> >  - Adding member 'otg' to struct samsung-usbphy so that its consum=
ers
> > >> >    can call otg->set_host so as to make 'phy' aware of the consume=
r type:
> > >> >     HOST/DEVICE
> > >> >
> > >> >  - Adding 'otg' to 'struct s5p_ehci_hcd' and 'struct exynos_ohci_h=
cd'
> > >> >    which keeps track of 'otg' of the controllers' phy. This then s=
ets
> > >> >    the host.
> > >> >
> > >> >  - Moved samsung_usbphy_set_type() calls from ehci-s5p and ohci-ex=
ynos
> > >> >    to phy driver itself where based on phy_type it is called.
> > >> >
> > >> >  - Added separate macro definition for USB20PHY_CFG register to se=
lect
> > >> >    between host/device type usb link.
> > >> >
> > >> >  - Removing unnecessary argument 'phy_type' from
> > >> > samsung_usbphy_set_type()
> > >> >    and samsung_usbphy_cfg_sel().
> > >> >
> > >> >  - Addressed few nits:
> > >> >     -- added macro for 'KHZ'
> > >> >     -- removing useless 'if' from samsung_usbphy_cfg_sel()
> > >> >     -- keeping the place of clk_get intact and requesting driver
> > >> >        data before that.
> > >> >
> > >> > Vivek Gautam (4):
> > >> >   ARM: EXYNOS: Update & move usb-phy types to generic include layer
> > >> >   usb: phy: samsung: Add host phy support to samsung-phy driver
> > >> >   USB: ehci-s5p: Add phy driver support
> > >> >   USB: ohci-exynos: Add phy driver support
> > >> >
> > >> >  .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
> > >> >  drivers/usb/host/ehci-s5p.c                        |   81 +++-
> > >> >  drivers/usb/host/ohci-exynos.c                     |   85 +++-
> > >> >  drivers/usb/phy/Kconfig                            |    2 +-
> > >> >  drivers/usb/phy/samsung-usbphy.c                   |  512
> > >> ++++++++++++++++++--
> > >> >  include/linux/usb/samsung_usb_phy.h                |   16 +
> > >> >  6 files changed, 635 insertions(+), 73 deletions(-)
> > >> >  create mode 100644 include/linux/usb/samsung_usb_phy.h
> > >> >
> > >> > --
> > >> > 1.7.6.5
> > >>
> > >> Looks good to me,
> > >>
> > >> Felipe and Greg, I don't know who should take this series anyway, fe=
el free
> > >> to add  my ack:
> > >>
> > >> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> > >
> > > I will take care of it. But I need Alan's Acked-by for EHCI and OHCI
> > > parts.
> > >
> >=20
> > We got Alan's ACK for:
> > USB: ehci-s5p: Add phy driver support
> > USB: ohci-exynos: Add phy driver support
>=20
> Ok, then as soon as I get back to the office (in a few hours), I'll
> start queueing those.

Actually, if you want to make my life a little easier today, you could
resend the series with all Acks in place ;-)

ps: hehe, I'm about to go a little nuts today, too many things happening
at once ;-)

--=20
balbi

--IJAclU0AInkryoed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/lyeAAoJEIaOsuA1yqRE3DIQAIgAvYJxfw9ANyirGoqQyz0l
xNCqfSxxEYtT9GSQ+xIYUlIaTt8EZ0Kw1u0CX001jOb71o64EvkOadP5oPBoWCDq
QOQ6K06CwkedU1xx3Yc+3PgTH/sbQYDfufWpitDFPIdpR1uzxyQvQhpRg7FesVNr
TW4oWM4MWAChaJnIQG1I/Pagwmlh+hk1GFD5EnJOfGgjxI6BBUddvCTJzew5HNiU
rlz0vx1ORaikCxW9zOHlAdxjc3CkA60+zZDoOQd0sqmMT/S3kJfW7dELRswB7L41
34QbKoFWalKHIoP/3f2m36dKG/5SKyVKRz8wWUqFqaFnrF/+lLkbfx2Yuj62vGRD
lZvYkV/ZM28zfCTsM2qPfEIa9fsoWv+lKIJYJsUuVQbIAZDXFOhkZgxKo3qoQM96
zm3UaitF0ur4uGpmBzCwfIhUrEyWUUixy1WMj++0G3yz8KcRbant2nL2Vcbg12ba
Pnaj3kBpJsYUulftUPaovXtP9LM4QdK1JQyXMJfTY7bpgmI3IrRN5/q2msE8ns9L
y+S/vGO5J/j4tzp7E8uxST6qkOMi2iwI6XARWqrrkuAaxUZ4+b7HQt5aKMOIkzd9
84Pm7NYHx3n4azJCEDpz9IbfEtN8JmnduZDFJPx8JK85lU9v+Hu9niMYQ4rzNizk
Q1MCmo7w5i+g2TrV4sfg
=2R1c
-----END PGP SIGNATURE-----

--IJAclU0AInkryoed--
