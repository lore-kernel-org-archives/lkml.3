Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaL2QPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:15:46 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:40364 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaL2QPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:15:42 -0500
Date: Mon, 29 Dec 2014 10:14:33 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 2/3] usb: dwc3: add Fujitsu Specific Glue layer
Message-ID: <20141229161433.GE29379@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1418695828-605-3-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20141222155936.GB12815@saruman>
 <CAJ1gpc0uniw3F3O9nxTLHp9M2boxrOACYDB=fgruhLOLdqg9yA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Content-Disposition: inline
In-Reply-To: <CAJ1gpc0uniw3F3O9nxTLHp9M2boxrOACYDB=fgruhLOLdqg9yA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 29, 2014 at 01:52:04AM +0800, Sneeker Yeh wrote:
> Hi,
>=20
> 2014-12-22 23:59 GMT+08:00 Felipe Balbi <balbi@ti.com>:
>=20
> > Hi,
> >
> > On Tue, Dec 16, 2014 at 10:10:27AM +0800, Sneeker Yeh wrote:
> > > This patch adds support for Synopsis DesignWare USB3 IP Core found
> > > on Fujitsu Socs.
> > >
> > > Signed-off-by: Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
> > > ---
> > >  .../devicetree/bindings/usb/fujitsu-dwc3.txt       |   25 +++
> > >  drivers/usb/dwc3/Kconfig                           |   11 ++
> > >  drivers/usb/dwc3/Makefile                          |    1 +
> > >  drivers/usb/dwc3/dwc3-mb86s70.c                    |  194
> > ++++++++++++++++++++
> > >  4 files changed, 231 insertions(+)
> > >  create mode 100644
> > Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
> > >  create mode 100644 drivers/usb/dwc3/dwc3-mb86s70.c
> > >
> > > diff --git a/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
> > b/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
> > > new file mode 100644
> > > index 0000000..df77f91
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/usb/fujitsu-dwc3.txt
> > > @@ -0,0 +1,25 @@
> > > +FUJITSU GLUE COMPONENTS
> > > +
> > > +MB86S7x DWC3 GLUE
> > > + - compatible : Should be "fujitsu,mb86s70-dwc3"
> > > + - clocks: from common clock binding, handle to usb clock.
> > > + - clock-names: from common clock binding.
> > > + - #address-cells, #size-cells : Must be present if the device has
> > sub-nodes
> > > + - ranges: the child address space are mapped 1:1 onto the parent
> > address space
> > > + - #stream-id-cells : handle to use "arm,mmu-400" ARM IOMMU driver
> > > +
> > > +Sub-nodes:
> > > +The dwc3 core should be added as subnode to MB86S7x dwc3 glue.
> > > +- dwc3 :
> > > +   The binding details of dwc3 can be found in:
> > > +   Documentation/devicetree/bindings/usb/dwc3.txt
> > > +
> > > +usb3host: mb86s70_usb3host {
> > > +     compatible =3D "fujitsu,mb86s70-dwc3";
> > > +     clocks =3D <&clk_alw_1_1>;
> > > +     clock-names =3D "bus_clk";
> > > +     #address-cells =3D <2>;
> > > +     #size-cells =3D <1>;
> > > +     ranges;
> > > +     #stream-id-cells =3D <0>;
> > > +};
> > > diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> > > index 58b5b2c..3390d42 100644
> > > --- a/drivers/usb/dwc3/Kconfig
> > > +++ b/drivers/usb/dwc3/Kconfig
> > > @@ -61,6 +61,17 @@ config USB_DWC3_EXYNOS
> > >         Recent Exynos5 SoCs ship with one DesignWare Core USB3 IP ins=
ide,
> > >         say 'Y' or 'M' if you have one such device.
> > >
> > > +config USB_DWC3_MB86S70
> > > +     tristate "MB86S70 Designware USB3 Platform code"
> > > +     default USB_DWC3
> > > +     help
> > > +       MB86S7X SOC ship with DesignWare Core USB3 IP inside,
> > > +       this implementation also integrated Fujitsu USB PHY inside
> > > +       this Core USB3 IP.
> > > +
> > > +       say 'Y' or 'M' if you have one such device.
> > > +
> > > +
> > >  config USB_DWC3_PCI
> > >       tristate "PCIe-based Platforms"
> > >       depends on PCI
> > > diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> > > index bb34fbc..05d1de2 100644
> > > --- a/drivers/usb/dwc3/Makefile
> > > +++ b/drivers/usb/dwc3/Makefile
> > > @@ -38,3 +38,4 @@ obj-$(CONFIG_USB_DWC3_PCI)          +=3D dwc3-pci.o
> > >  obj-$(CONFIG_USB_DWC3_KEYSTONE)              +=3D dwc3-keystone.o
> > >  obj-$(CONFIG_USB_DWC3_QCOM)          +=3D dwc3-qcom.o
> > >  obj-$(CONFIG_USB_DWC3_ST)            +=3D dwc3-st.o
> > > +obj-$(CONFIG_USB_DWC3_MB86S70)               +=3D dwc3-mb86s70.o
> > > diff --git a/drivers/usb/dwc3/dwc3-mb86s70.c
> > b/drivers/usb/dwc3/dwc3-mb86s70.c
> > > new file mode 100644
> > > index 0000000..241c5bd
> > > --- /dev/null
> > > +++ b/drivers/usb/dwc3/dwc3-mb86s70.c
> > > @@ -0,0 +1,194 @@
> > > +/**
> > > + * dwc3-mb86s70.c - Fujitsu mb86s70 DWC3 Specific Glue layer
> > > + *
> > > + * Copyright (c) 2013 - 2014 FUJITSU SEMICONDUCTOR LIMITED
> > > + *           http://jp.fujitsu.com/group/fsl
> > > + *
> > > + * Author: Alice Chan <Alice.Chan@tw.fujitsu.com>
> > > + * based on dwc3-exynos.c
> > > + *
> > > + * This program is free software; you can redistribute it and/or mod=
ify
> > > + * it under the terms of the GNU General Public License as published=
 by
> > > + * the Free Software Foundation; either version 2 of the License, or
> > > + * (at your option) any later version.
> > > + */
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/platform_device.h>
> > > +#include <linux/dma-mapping.h>
> > > +#include <linux/interrupt.h>
> > > +#include <linux/of.h>
> > > +#include <linux/of_platform.h>
> > > +#include <linux/pm_runtime.h>
> > > +#include <linux/clk.h>
> > > +
> > > +struct dwc3_mb86s70 {
> > > +     struct device   *dev;
> > > +     struct clk              **clk_table;
> >
> > please align these.
>=20
>=20
> okay.
>=20
>=20
> >
>=20
>=20
> > > +};
> > > +
> > > +/* return 0 means successful */
> >
> > this comment is unnecessary :-)
> >
>=20
> okay
>=20
>=20
> >
> > > +static int dwc3_mb86s70_clk_control(struct device *dev, bool on)
> > > +{
> > > +     int ret, i;
> > > +     struct clk *clk;
> > > +
> > > +     if (!on)
> > > +             goto clock_off;
> > > +
> > > +     for (i =3D 0;; i++) {
> > > +             clk =3D of_clk_get(dev->of_node, i);
> >
> > you could count the number of properties first, then allocate clk_table
> > to the exact size.
> >
>=20
> okay, thanks.
>=20
>=20
> >
> > > +             if (IS_ERR(clk))
> > > +                     break;
> > > +
> > > +             ret =3D clk_prepare_enable(clk);
> > > +             if (ret) {
> > > +                     dev_err(dev, "failed to enable clock[%d]\n", i);
> > > +                     goto clock_off;
> > > +             }
> > > +     }
> > > +
> > > +     return 0;
> > > +
> > > +clock_off:
> > > +     for (i =3D 0;; i++) {
> > > +             clk =3D of_clk_get(dev->of_node, i);
> > > +             if (IS_ERR(clk))
> > > +                     break;
> > > +
> > > +             clk_disable_unprepare(clk);
> > > +     }
> > > +
> > > +     return on;
> > > +}
> > > +
> > > +static int dwc3_mb86s70_remove_child(struct device *dev, void *unuse=
d)
> > > +{
> > > +     struct platform_device *pdev =3D to_platform_device(dev);
> > > +
> > > +     of_device_unregister(pdev);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static u64 dwc3_mb86s70_dma_mask =3D DMA_BIT_MASK(32);
> >
> > why ? Use dma_coerce_mask_and_coherent().
> >
>=20
> okay.
>=20
>=20
> >
> > > +
> > > +static int dwc3_mb86s70_probe(struct platform_device *pdev)
> > > +{
> > > +     struct dwc3_mb86s70     *mb86s70;
> > > +     struct device           *dev =3D &pdev->dev;
> > > +     struct device_node      *node =3D dev->of_node;
> > > +     int                     ret;
> > > +
> > > +     mb86s70 =3D devm_kzalloc(dev, sizeof(*mb86s70), GFP_KERNEL);
> > > +     if (!mb86s70) {
> > > +             ret =3D -ENOMEM;
> > > +             goto err;
> > > +     }
> > > +
> > > +     dev->dma_mask =3D &dwc3_mb86s70_dma_mask;
> > > +
> > > +     platform_set_drvdata(pdev, mb86s70);
> > > +
> > > +     mb86s70->dev =3D dev;
> > > +
> > > +     /* resume driver for clock, power */
> > > +     pm_runtime_enable(&pdev->dev);
> > > +     ret =3D pm_runtime_get_sync(&pdev->dev);
> >
> > here's a slightly better way (add error checking where necessary):
> >
> >         dwc3_mb86s70_clk_control(dev, true);
> >         pm_runtime_set_active(dev);
> >         pm_runtime_enable(dev);
> >         pm_runtime_get(dev);
> >
> >
> okay, thanks,
> these seems much better and more correct.
>=20
>=20
>=20
> >
> > > +     if (ret < 0) {
> > > +             dev_err(&pdev->dev, "get_sync failed with err %d\n", re=
t);
> > > +             goto err;
> >
> > if get_sync() fails, you still need to call pm_runtime_put_sync(); In
> > this case, you also need to call pm_runtime_disable();
> >
>=20
> okay, thanks.
>=20
>=20
> >
> > > +     }
> > > +
> > > +     if (node) {
> > > +             ret =3D of_platform_populate(node, NULL, NULL, dev);
> > > +             if (!ret)
> > > +                     return 0;
> > > +             dev_err(dev, "failed to add dwc3 core\n");
> > > +     }
> > > +     dev_err(dev, "no device node, failed to add dwc3 core\n");
> > > +     ret =3D -ENODEV;
> > > +
> > > +err:
> > > +     return ret;
> > > +}
> > > +
> > > +static int dwc3_mb86s70_remove(struct platform_device *pdev)
> > > +{
> > > +     device_for_each_child(&pdev->dev, NULL, dwc3_mb86s70_remove_chi=
ld);
> > > +
> > > +     pm_runtime_put_sync(&pdev->dev);
> > > +     pm_runtime_disable(&pdev->dev);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static const struct of_device_id mb86s70_dwc3_match[] =3D {
> > > +     { .compatible =3D "fujitsu,mb86s70-dwc3" },
> > > +     {},
> > > +};
> > > +MODULE_DEVICE_TABLE(of, mb86s70_dwc3_match);
> > > +
> > > +#ifdef CONFIG_PM
> > > +#ifdef CONFIG_PM_RUNTIME
> > > +static int dwc3_mb86s70_runtime_suspend(struct device *dev)
> > > +{
> > > +     dwc3_mb86s70_clk_control(dev, false);
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +static int  dwc3_mb86s70_runtime_resume(struct device *dev)
> > > +{
> > > +     dwc3_mb86s70_clk_control(dev, true);
> > > +
> > > +     return 0;
> > > +}
> > > +#endif /* CONFIG_PM_RUNTIME */
> > > +static int dwc3_mb86s70_suspend(struct device *dev)
> > > +{
> > > +     if (pm_runtime_status_suspended(dev))
> > > +             return 0;
> > > +
> > > +     return dwc3_mb86s70_runtime_suspend(dev);
> >
> > ok, this is a bit confusing and, in fact, wrong. You're not dealing with
> > wakeups (which are mandatory on runtime_pm and option on system sleep).
> >
> > It's okay to have a common function called by both runtime_pm and
> > system_sleep methods, but calling your runtime_pm handler is a bit odd.
> >
>=20
> hm, sorry I might confuse people here.
> I'll change this to what you suggested.
>=20
>=20
> >
> > last but not least, I need to see results of this running on top of
> > v3.19-rc1. Are you using both host and peripheral modes or only one mode
> > for now ?
> >
>=20
> The dwc3 IP we adapted is host-only, and we run this platform glue driver
> in v3.19-rc1 for now.
> bellow log is about suspend and resume successfully, and dwc3 still works.
>=20
> root@linaro-nano:~# echo mem > /sys/power/state
> [   56.713281] mb86s70-dwc3 mb86s70_usb3host1.5: dwc3_mb86s70_suspend() is
> started.
> [   56.720721] mb86s70-dwc3 mb86s70_usb3host1.5:
> dwc3_mb86s70_runtime_suspend() is started.
> [   56.729419] mb86s70-dwc3 mb86s70_usb3host1.5:
> dwc3_mb86s70_runtime_suspend() is ended.
> [   56.737363] mb86s70-dwc3 mb86s70_usb3host1.5: dwc3_mb86s70_suspend() is
> ended.
> [   56.744604] mb86s70-dwc3 mb86s70_usb3host0.4: dwc3_mb86s70_suspend() is
> started.
> [   56.752022] mb86s70-dwc3 mb86s70_usb3host0.4:
> dwc3_mb86s70_runtime_suspend() is started.
> [   56.760700] mb86s70-dwc3 mb86s70_usb3host0.4:
> dwc3_mb86s70_runtime_suspend() is ended.
> [   56.768639] mb86s70-dwc3 mb86s70_usb3host0.4: dwc3_mb86s70_suspend() is
> ended.
> [   57.107139] SUSPEND
>=20
> [   74.564963] mmc0: execute_tuning --
> [   74.877776] mb86s70-dwc3 mb86s70_usb3host0.4: dwc3_mb86s70_resume() is
> started.
> [   74.885126] mb86s70-dwc3 mb86s70_usb3host0.4:
> dwc3_mb86s70_runtime_resume() is started.
> [   74.893749] mb86s70-dwc3 mb86s70_usb3host0.4:
> dwc3_mb86s70_runtime_resume() is ended.
> [   74.901606] mb86s70-dwc3 mb86s70_usb3host0.4: dwc3_mb86s70_resume() is
> ended.
> [   74.908766] mb86s70-dwc3 mb86s70_usb3host1.5: dwc3_mb86s70_resume() is
> started.
> [   74.916086] mb86s70-dwc3 mb86s70_usb3host1.5:
> dwc3_mb86s70_runtime_resume() is started.
> [   74.924660] mb86s70-dwc3 mb86s70_usb3host1.5:
> dwc3_mb86s70_runtime_resume() is ended.
> [   74.932513] mb86s70-dwc3 mb86s70_usb3host1.5: dwc3_mb86s70_resume() is
> ended.
> root@linaro-nano:~#
>=20
> But I realize something might confuse people, and even is wrong, through
> your comment.
> So I guess I should align these to a more clear form like dwc3-exynos.c :
>=20
> static int dwc3_exynos_suspend(struct device *dev)
> {
> struct dwc3_exynos *exynos =3D dev_get_drvdata(dev);
>=20
> clk_disable(exynos->clk);
>=20
> return 0;
> }
>=20
> static int dwc3_exynos_resume(struct device *dev)
> {
> struct dwc3_exynos *exynos =3D dev_get_drvdata(dev);
>=20
> clk_enable(exynos->clk);
>=20
> /* runtime set active to reflect active state. */
> pm_runtime_disable(dev);
> pm_runtime_set_active(dev);
> pm_runtime_enable(dev);
>=20
> return 0;
> }
>=20
> Would it been better than how I do suspend/resume here?

sure, that would be better :-)

> however recently I got some thought inspired by Arnd and the commit
> 5f872175c867a839e2feeecfa59e3db38c88b561

where is that commit ?

$ git show 5f872175c867a839e2feeecfa59e3db38c88b561
fatal: bad object 5f872175c867a839e2feeecfa59e3db38c88b561

I have here linus and linux-next just fetched before trying to git show.

> For imitating that in my experiment recently, i only need to add clock
> on/off in dwc3 core.

Let's wait a little bit more before doing that. We have a ton of users
which don't have controllable clocks and, frankly speaking, if we hide
all clock control on glue layer (which is a parent device of core) it
will still work just fine because of the ordering of children vs parent
that device core gives you for free :-)

> Then dwc3 core won't be always created via sub node in platform glue node,
> and vendors like us can just drop platform glue which don't have any
> specific platform code to wrap dwc3 core, and just directly use dwc3 core
> via device tree.

If your core is really just xhci, why don't just use xhci-plat.c
directly ? You don't need dwc3 at all. In any case, I refrain from
allowing people to use dwc3.ko directly because that has bitten me in
the past with MUSB, so sorry but I'll always force people to use the
glue layer as that helps me keep dwc3 clean of platform-specific
details.

> Of course here dwc3 core won't process clock if he got null one, so this
> won't affect other vendor's platform which only pass clock phandle to the=
ir
> dwc3 platform glue driver.

right

> Just wondering if it's better to write a platform glue only did clock
> on/off, or to do the same improvement people ever did for
> ehci-platform driver and just drop this platform glue driver?

I'll always the sour taste in my mouth due to MUSB. The thing is a
complete mess of platform-specific hacks all over the place.

> Hope I didn't reply too late, or make any impolite move here,

merge window just closed, we've got time.

> Super thanks for every comment you made here.

hey, no problem.

--=20
balbi

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUoX3pAAoJEIaOsuA1yqREQ1sP/1wT9FL2TlW+qjz3mL9P+blB
BRy01DqOqBRGL2ivJ1HN4ppWe9lUH/y4vAfMuwWddHCkv0Z8X8B1n9vylkMXyVkN
m/GbosYkXbX69bfsZVXx9dmqNNyLt5GwCRXSJuE50YOeq3y5Ozeyd3FVxrrm7/Vl
c4i+EuplQNfelJKMGPYJxrfhrvyONRjZIv3vfPOLe1AQ6toaSM41LLi+NlltgWEY
7HT/FX+jauHK9FuvJc/FyzaH1MakTOp3kTPGhRgUnO54PaetC9CEWRANerl55xxv
Ht/voY6hyEO3aH4G8EW476pQRt+cVG/YL8Q2Z5Y4Rmi4OggG8qLqoz9uhCujbZMF
A/VhQgzh1mazfcLatKDGfdyDZlcHl1rhO9EnDm/cJOEkw3Ylss3ZFTb5uLkWMwlc
RX/0dV8q4f+QyNXYR/GRdO02AtlUbc2G1qKtEItGWk0NH/2fXLcAfjYVVMb8ltkr
w1Upt+zUT990vYpv+K93B7keymgRVbm27HBnKfrBNSvTAYi4MW6ISUfub7HdVo9J
ZcOUrDZvfBnOiIrI952+RytFZBiv5oHZPKKgYMC/vW6tMiyNa3efJTIskev1pq+W
f0FuetB2l86WbA8+xhhqzem0eJifmqXXsrD4yoj5+i032Xt6iD3uWOvm2MPfNlVg
5P+bIorYb4EMxLcWi4Hn
=9JIP
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
