Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3ILF6C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 01:58:02 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:33079 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab3ILF56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 01:57:58 -0400
Message-ID: <523157E2.4090707@monstr.eu>
Date: Thu, 12 Sep 2013 07:57:54 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Ball <cjb@laptop.org>, Alessandro Zummo <a.zummo@towertech.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-mmc@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [RFC PATCH] amba: Ensure drvdata is NULL
References: <346db238d6c8c418bddb1e8a166e9818b5074c06.1378305864.git.michal.simek@xilinx.com>
In-Reply-To: <346db238d6c8c418bddb1e8a166e9818b5074c06.1378305864.git.michal.simek@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="bIniuQhkFibj80X14rlEFb50ECVjD17KV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--bIniuQhkFibj80X14rlEFb50ECVjD17KV
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Russell,

any comment on this one?

Thanks,
Michal


On 09/04/2013 04:44 PM, Michal Simek wrote:
> This patch is inpired by the patch for drvdata
> "device-core: Ensure drvdata =3D NULL when no driver is bound"
> (sha1: 0998d0631001288a5974afc0b2a5f568bcdecb4d)
>=20
> Also it fixes all occurences in drivers.
>=20
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
>  arch/arm/kernel/etm.c           | 6 ------
>  drivers/amba/bus.c              | 2 ++
>  drivers/dma/pl330.c             | 3 ---
>  drivers/input/serio/ambakmi.c   | 2 --
>  drivers/mmc/host/mmci.c         | 2 --
>  drivers/rtc/rtc-pl030.c         | 2 --
>  drivers/rtc/rtc-pl031.c         | 2 --
>  drivers/spi/spi-pl022.c         | 1 -
>  drivers/tty/serial/amba-pl010.c | 3 ---
>  drivers/tty/serial/amba-pl011.c | 3 ---
>  drivers/video/amba-clcd.c       | 2 --
>  drivers/watchdog/sp805_wdt.c    | 1 -
>  12 files changed, 2 insertions(+), 27 deletions(-)
>=20
> diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
> index 8ff0ecd..131a6ab 100644
> --- a/arch/arm/kernel/etm.c
> +++ b/arch/arm/kernel/etm.c
> @@ -385,7 +385,6 @@ out:
>  	return ret;
>=20
>  out_unmap:
> -	amba_set_drvdata(dev, NULL);
>  	iounmap(t->etb_regs);
>=20
>  out_release:
> @@ -398,8 +397,6 @@ static int etb_remove(struct amba_device *dev)
>  {
>  	struct tracectx *t =3D amba_get_drvdata(dev);
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	iounmap(t->etb_regs);
>  	t->etb_regs =3D NULL;
>=20
> @@ -588,7 +585,6 @@ out:
>  	return ret;
>=20
>  out_unmap:
> -	amba_set_drvdata(dev, NULL);
>  	iounmap(t->etm_regs);
>=20
>  out_release:
> @@ -601,8 +597,6 @@ static int etm_remove(struct amba_device *dev)
>  {
>  	struct tracectx *t =3D amba_get_drvdata(dev);
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	iounmap(t->etm_regs);
>  	t->etm_regs =3D NULL;
>=20
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index c670727..9762090 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -373,6 +373,7 @@ static int amba_probe(struct device *dev)
>  		if (ret =3D=3D 0)
>  			break;
>=20
> +		amba_set_drvdata(pcdev, NULL);
>  		pm_runtime_disable(dev);
>  		pm_runtime_set_suspended(dev);
>  		pm_runtime_put_noidle(dev);
> @@ -391,6 +392,7 @@ static int amba_remove(struct device *dev)
>=20
>  	pm_runtime_get_sync(dev);
>  	ret =3D drv->remove(pcdev);
> +	amba_set_drvdata(pcdev, NULL);
>  	pm_runtime_put_noidle(dev);
>=20
>  	/* Undo the runtime PM settings in amba_probe() */
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index fa645d8..626f99e 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -3026,8 +3026,6 @@ pl330_probe(struct amba_device *adev, const struc=
t amba_id *id)
>=20
>  	return 0;
>  probe_err3:
> -	amba_set_drvdata(adev, NULL);
> -
>  	/* Idle the DMAC */
>  	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
>  			chan.device_node) {
> @@ -3061,7 +3059,6 @@ static int pl330_remove(struct amba_device *adev)=

>  		of_dma_controller_free(adev->dev.of_node);
>=20
>  	dma_async_device_unregister(&pdmac->ddma);
> -	amba_set_drvdata(adev, NULL);
>=20
>  	/* Idle the DMAC */
>  	list_for_each_entry_safe(pch, _p, &pdmac->ddma.channels,
> diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakm=
i.c
> index 4e2fd44..b7c206d 100644
> --- a/drivers/input/serio/ambakmi.c
> +++ b/drivers/input/serio/ambakmi.c
> @@ -167,8 +167,6 @@ static int amba_kmi_remove(struct amba_device *dev)=

>  {
>  	struct amba_kmi_port *kmi =3D amba_get_drvdata(dev);
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	serio_unregister_port(kmi->io);
>  	clk_put(kmi->clk);
>  	iounmap(kmi->base);
> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
> index c3785ed..07e17f1 100644
> --- a/drivers/mmc/host/mmci.c
> +++ b/drivers/mmc/host/mmci.c
> @@ -1678,8 +1678,6 @@ static int mmci_remove(struct amba_device *dev)
>  {
>  	struct mmc_host *mmc =3D amba_get_drvdata(dev);
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	if (mmc) {
>  		struct mmci_host *host =3D mmc_priv(mmc);
>=20
> diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
> index 22bacdb..a804f75 100644
> --- a/drivers/rtc/rtc-pl030.c
> +++ b/drivers/rtc/rtc-pl030.c
> @@ -153,8 +153,6 @@ static int pl030_remove(struct amba_device *dev)
>  {
>  	struct pl030_rtc *rtc =3D amba_get_drvdata(dev);
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	writel(0, rtc->base + RTC_CR);
>=20
>  	free_irq(dev->irq[0], rtc);
> diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
> index 0f0609b..c9ca86e 100644
> --- a/drivers/rtc/rtc-pl031.c
> +++ b/drivers/rtc/rtc-pl031.c
> @@ -305,7 +305,6 @@ static int pl031_remove(struct amba_device *adev)
>  {
>  	struct pl031_local *ldata =3D dev_get_drvdata(&adev->dev);
>=20
> -	amba_set_drvdata(adev, NULL);
>  	free_irq(adev->irq[0], ldata);
>  	rtc_device_unregister(ldata->rtc);
>  	iounmap(ldata->base);
> @@ -392,7 +391,6 @@ out_no_irq:
>  	rtc_device_unregister(ldata->rtc);
>  out_no_rtc:
>  	iounmap(ldata->base);
> -	amba_set_drvdata(adev, NULL);
>  out_no_remap:
>  	kfree(ldata);
>  out:
> diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
> index abef061..e12813e 100644
> --- a/drivers/spi/spi-pl022.c
> +++ b/drivers/spi/spi-pl022.c
> @@ -2306,7 +2306,6 @@ pl022_remove(struct amba_device *adev)
>  	amba_release_regions(adev);
>  	tasklet_disable(&pl022->pump_transfers);
>  	spi_unregister_master(pl022->master);
> -	amba_set_drvdata(adev, NULL);
>  	return 0;
>  }
>=20
> diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-=
pl010.c
> index c368405..f630b78 100644
> --- a/drivers/tty/serial/amba-pl010.c
> +++ b/drivers/tty/serial/amba-pl010.c
> @@ -728,7 +728,6 @@ static int pl010_probe(struct amba_device *dev, con=
st struct amba_id *id)
>  	amba_set_drvdata(dev, uap);
>  	ret =3D uart_add_one_port(&amba_reg, &uap->port);
>  	if (ret) {
> -		amba_set_drvdata(dev, NULL);
>  		amba_ports[i] =3D NULL;
>  		clk_put(uap->clk);
>   unmap:
> @@ -745,8 +744,6 @@ static int pl010_remove(struct amba_device *dev)
>  	struct uart_amba_port *uap =3D amba_get_drvdata(dev);
>  	int i;
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	uart_remove_one_port(&amba_reg, &uap->port);
>=20
>  	for (i =3D 0; i < ARRAY_SIZE(amba_ports); i++)
> diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-=
pl011.c
> index 28b35ad..2a1efe0 100644
> --- a/drivers/tty/serial/amba-pl011.c
> +++ b/drivers/tty/serial/amba-pl011.c
> @@ -2143,7 +2143,6 @@ static int pl011_probe(struct amba_device *dev, c=
onst struct amba_id *id)
>  	amba_set_drvdata(dev, uap);
>  	ret =3D uart_add_one_port(&amba_reg, &uap->port);
>  	if (ret) {
> -		amba_set_drvdata(dev, NULL);
>  		amba_ports[i] =3D NULL;
>  		pl011_dma_remove(uap);
>  	}
> @@ -2156,8 +2155,6 @@ static int pl011_remove(struct amba_device *dev)
>  	struct uart_amba_port *uap =3D amba_get_drvdata(dev);
>  	int i;
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	uart_remove_one_port(&amba_reg, &uap->port);
>=20
>  	for (i =3D 0; i < ARRAY_SIZE(amba_ports); i++)
> diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
> index 0a2cce7..0bab6ab 100644
> --- a/drivers/video/amba-clcd.c
> +++ b/drivers/video/amba-clcd.c
> @@ -594,8 +594,6 @@ static int clcdfb_remove(struct amba_device *dev)
>  {
>  	struct clcd_fb *fb =3D amba_get_drvdata(dev);
>=20
> -	amba_set_drvdata(dev, NULL);
> -
>  	clcdfb_disable(fb);
>  	unregister_framebuffer(&fb->fb);
>  	if (fb->fb.cmap.len)
> diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.=
c
> index 58df98a..3f786ce 100644
> --- a/drivers/watchdog/sp805_wdt.c
> +++ b/drivers/watchdog/sp805_wdt.c
> @@ -268,7 +268,6 @@ static int sp805_wdt_remove(struct amba_device *ade=
v)
>  	struct sp805_wdt *wdt =3D amba_get_drvdata(adev);
>=20
>  	watchdog_unregister_device(&wdt->wdd);
> -	amba_set_drvdata(adev, NULL);
>  	watchdog_set_drvdata(&wdt->wdd, NULL);
>=20
>  	return 0;
> --
> 1.8.2.3
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--bIniuQhkFibj80X14rlEFb50ECVjD17KV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlIxV+IACgkQykllyylKDCG+6ACeIhGU2N7vWeSAf38mc0uHP6w4
7AUAn0sVkV4sqjIRdjzGgvleKuI7k+w3
=lw5O
-----END PGP SIGNATURE-----

--bIniuQhkFibj80X14rlEFb50ECVjD17KV--
