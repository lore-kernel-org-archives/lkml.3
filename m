Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaIHN03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:26:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46782 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040AbaIHN01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:26:27 -0400
Date: Mon, 8 Sep 2014 08:25:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Lifshitz <lifshitz@compulab.co.il>
CC: Roger Quadros <rogerq@ti.com>, Felipe Balbi <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: omap5: Add dr_mode for dwc3
Message-ID: <20140908132533.GB22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <1381402195-29257-1-git-send-email-kishon@ti.com>
 <1381402195-29257-2-git-send-email-kishon@ti.com>
 <52580F34.8030809@ti.com>
 <20140416161619.GH28035@saruman.home>
 <540D9449.3090008@compulab.co.il>
 <540D955C.6060602@ti.com>
 <540DA1E5.1060701@compulab.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
Content-Disposition: inline
In-Reply-To: <540DA1E5.1060701@compulab.co.il>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 08, 2014 at 03:32:37PM +0300, Dmitry Lifshitz wrote:
> Hi Roger,
>=20
> Thank you for a quick reply. See, my reply below.
>=20
> On 09/08/2014 02:39 PM, Roger Quadros wrote:
> >On 09/08/2014 02:34 PM, Dmitry Lifshitz wrote:
> >>Hi Felipe, Roger
> >>
> >>On 04/16/2014 07:16 PM, Felipe Balbi wrote:
> >>>On Fri, Oct 11, 2013 at 05:46:12PM +0300, Roger Quadros wrote:
> >>>>Hi,
> >>>>
> >>>>On 10/10/2013 01:49 PM, Kishon Vijay Abraham I wrote:
> >>>>>From: George Cherian <george.cherian@ti.com>
> >>>>>
> >>>>>Added dr_mode property in dwc3 and set its default mode to device.
> >>>>
> >>>>If there is a specific reason why this is not set to "otg", we need
> >>>>to explain it here.
> >>>>
> >>>>AFAIK the port is meant to be used as OTG port.
> >>>
> >>>we still don't have the workaround for dual role ports, I've been
> >>>working on it but still need to retest and make sure it's working fine
> >>>before merging upstream.
> >>>
> >>
> >>
> >>Does the OTG port suppose to work with OMAP5? I mean role switching mec=
hanism?
> >>
> >>I'm testing kernel v3.16 with OMAP5 based board (CM-T54).
> >>
> >>If I set CONFIG_USB_DWC3_DUAL_ROLE, than nothing is going on when I plu=
g some device/host cable into micro USB3.0 port (VBUS/ID detection with ext=
con events works fine).
> >>
> >>CONFIG_USB_DWC3_HOST/CONFIG_USB_DWC3_GADGET bring port to appropriate m=
ode and it works.
> >>
> >>What is the purpose of setting dr_mode =3D "peripheral" in omap5.dtsi, =
since it is overridden by config options in dwc3_probe()?
> >
> >If dual role works it should be "otg" then. I'm not sure why it was set =
to peripheral. Maybe the role switching mechanism
> >was not in place earlier.
>=20
>=20
> This is what I have when setting dr_mode =3D "otg" (and compiling with
> CONFIG_USB_DWC3_DUAL_ROLE):
>=20
> when load gadget driver and plugging host PC cable:
>=20
> root@cm-debian:~# modprobe g_ether
> using random self ethernet address
> using random host ethernet address
> usb0: HOST MAC fa:db:52:7f:95:c5
> usb0: MAC be:75:8d:71:6d:02
> using random self ethernet address
> using random host ethernet address
> g_ether gadget: Ethernet Gadget, version: Memorial Day 2008
> g_ether gadget: g_ether ready
> root@cm-debian:~# ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 65 at /home/lifshitz/workroot/git-repo/OMAP5/omap5-k=
ernel/drivers/bus/omap_l3_noc.c:147
> l3_handle_target.isra.2+0x230/0x27c()
> 44000000.ocp:L3 Standard Error: MASTER UN IDENTIFIED TARGET OCMRAM (Read):
> At Address: 0x00000000 : Data Access in User mode during Functional access
> Modules linked in: usb_f_eem g_ether usb_f_rndis libcomposite u_ether
> configfs rfcomm ecb btmrvl_sdio btmrvl bluetooth mwifiex_sdio mwifiex dwc3
> ahci_platform libahci_platform libahci libata snd_soc_cm_t54 ads7846
> dwc3_omap extcon_palmas rtc_palmas extcon_class at24 snd_soc_wm8731
> snd_soc_omap_mcbsp
> CPU: 0 PID: 65 Comm: irq/39-palmas Tainted: G        W 3.16.0-cm-t54+ #99
> [<c00156d0>] (unwind_backtrace) from [<c00124ac>] (show_stack+0x10/0x14)
> [<c00124ac>] (show_stack) from [<c05e29dc>] (dump_stack+0x74/0x8c)
> [<c05e29dc>] (dump_stack) from [<c0037dbc>] (warn_slowpath_common+0x70/0x=
88)
> [<c0037dbc>] (warn_slowpath_common) from [<c0037e68>]
> (warn_slowpath_fmt+0x30/0x40)
> [<c0037e68>] (warn_slowpath_fmt) from [<c02d88b8>]
> (l3_handle_target.isra.2+0x230/0x27c)
> [<c02d88b8>] (l3_handle_target.isra.2) from [<c02d89b0>]
> (l3_interrupt_handler+0xac/0x13c)
> [<c02d89b0>] (l3_interrupt_handler) from [<c007ea00>]
> (handle_irq_event_percpu+0x7c/0x230)
> [<c007ea00>] (handle_irq_event_percpu) from [<c007ebf8>]
> (handle_irq_event+0x44/0x64)
> [<c007ebf8>] (handle_irq_event) from [<c0081b78>]
> (handle_fasteoi_irq+0xa8/0x134)
> [<c0081b78>] (handle_fasteoi_irq) from [<c007e398>]
> (generic_handle_irq+0x20/0x30)
> [<c007e398>] (generic_handle_irq) from [<c000f4ac>] (handle_IRQ+0x40/0x90)
> [<c000f4ac>] (handle_IRQ) from [<c0008620>] (gic_handle_irq+0x2c/0x60)
> [<c0008620>] (gic_handle_irq) from [<c05eacc0>] (__irq_svc+0x40/0x50)
> Exception stack(0xec939d80 to 0xec939dc8)
> 9d80: ecb729b0 20000013 00000000 00000001 ecb72800 eca1e000 00000000
> ec939e44
> 9da0: ec939ed0 20000013 ecb72818 ed005e14 ec939ec8 ec939dc8 bf015f54
> c05ea548
> 9dc0: 80000013 ffffffff
> [<c05eacc0>] (__irq_svc) from [<c05ea548>]
> (_raw_spin_unlock_irqrestore+0x1c/0x20)
> [<c05ea548>] (_raw_spin_unlock_irqrestore) from [<bf015f54>]
> (extcon_update_state+0x144/0x1c4 [extcon_class])
> [<bf015f54>] (extcon_update_state [extcon_class]) from [<bf023288>]
> (palmas_vbus_irq_handler+0x64/0xa0 [extcon_palmas])
> [<bf023288>] (palmas_vbus_irq_handler [extcon_palmas]) from [<c00815a8>]
> (handle_nested_irq+0xa0/0x10c)
> [<c00815a8>] (handle_nested_irq) from [<c03ab85c>]
> (regmap_irq_thread+0x184/0x300)
> [<c03ab85c>] (regmap_irq_thread) from [<c007f8b8>] (irq_thread_fn+0x1c/0x=
40)
> [<c007f8b8>] (irq_thread_fn) from [<c007f6a4>] (irq_thread+0x120/0x15c)
> [<c007f6a4>] (irq_thread) from [<c0056434>] (kthread+0xdc/0xf0)
> [<c0056434>] (kthread) from [<c000eb98>] (ret_from_fork+0x14/0x3c)
> ---[ end trace 3b365a734f7f3202 ]---
> palmas-usb 48070000.i2c:palmas@48:palmas_usb: USB cable is attached
>=20
>=20
>=20
> when plugging storage device:
>=20
> root@cm-debian:~# dmesg | tail -n20
> ...
> omap-dwc3 4a020000.omap_dwc3: ID GND
> palmas-usb 48070000.i2c:palmas@48:palmas_usb: USB-HOST cable is attached
> palmas-usb 48070000.i2c:palmas@48:palmas_usb: USB cable is attached
>=20
> and nothing is going on.
>=20
> Once again, when compiling with predefined role
> (CONFIG_USB_DWC3_HOST/CONFIG_USB_DWC3_GADGET) the port is functional in b=
oth
> modes.
>=20
> I'm wondering, if dwc3_probe() calls
> dwc3_core_init_mode() -> dwc3_set_mode() than why it is not required in
> dwc3_omap_set_mailbox()?

no, it's not required there. that mailbox is basically just telling the
IP about VBUS levels and ID state. Nothing more.

--=20
balbi

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDa5NAAoJEIaOsuA1yqREe0QP/0o3jQFWYZfx32FPyDJuB9SD
KawEs8m9H+7DIwr12PXgW9k2PI+rNkA7k5ltz2BoDa9FCxx2x0d35zuj7XzTo2SC
epN6d13hQotbayOxGQ6TGrOJkmY4AdQwAPCWo/2uPyYyZv3LbwQBQ2IodeJqiq6T
7b4NIITi0M3nwfAW/azS6XWu3/8XP+63qaZhyare8aEAsSqmTfFG00SajfNM0W41
plp6IjEYzgupGaR2/Me/y9X6Xt8jAssBypxN6hcaq93g+HFli9cyO1I8hxK8t3oh
98HeB6T70T/wj+XHRFxXO8PpiPU2Ljcy5FcepTBb2RTik1PVoqxRSoOkHtppGQlV
2YOXO/GS4LXNoFV5f2q/rvBu+utFZ2Ahf9RHZ12OUGDeRmQMjrceSQIhuG3IH2fS
iLcc8xjw6eCFgSJ/SITh/j9nvxyTPa7lEIVNRsZzGpUxqYsl00Z/gTHu6ml7GPbH
E4GJ01tG5ch9TX1fpHFn3XS3TMcOor2Bk9fnsz95rYkxOFfcqmFuo9BhGe8W7oPH
L+GZioQAoaaYm8eZi+HLnjTk0noEaJeNYvYgOUweoOx6Lk++iy+4EiAX0cr/Bub1
PPbOwFtaHvK5KjpQay7I1/KDO/4fnnw8bieY9ptDI0LQheYfmEEcb/LfGJKTo25n
VydYqR0RVKrd+2ReDULV
=h+Oq
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
