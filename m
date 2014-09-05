Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaIEOHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:07:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36722 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbaIEOHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:07:03 -0400
Date: Fri, 5 Sep 2014 09:06:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <Peter.Chen@freescale.com>, <stern@rowland.harvard.edu>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <balbi@ti.com>,
        <linux-tegra@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-sh@vger.kernel.org>, <yoshihiro.shimoda.uh@renesas.com>,
        <linux-kernel@vger.kernel.org>, <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v5 1/2] usb: rename phy to usb_phy in HCD
Message-ID: <20140905140640.GB24449@saruman.home>
Reply-To: <balbi@ti.com>
References: <5072811.p8odmvpxdS@wasted.cogentembedded.com>
 <2282553.NrZjRxyKlv@wasted.cogentembedded.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <2282553.NrZjRxyKlv@wasted.cogentembedded.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2014 at 01:42:09AM +0400, Sergei Shtylyov wrote:
> From: Antoine Tenart <antoine.tenart@free-electrons.com>
>=20
> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> modifications are done in all drivers accessing it.
> This is in preparation to adding the generic PHY support.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> [Sergei: added missing 'drivers/usb/misc/lvstest.c' file, resolved rejects
> caused by patch reordering, updated changelog.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
> Changes in version 5:
> - imported the patch from Antoine Tenart's series;
> - added missing 'drivers/usb/misc/lvstest.c' file;
> - resolved rejects caused by patch reordering;
> - refreshed patch;
> - updated changelog.
>=20
>  drivers/usb/chipidea/host.c   |    2 +-
>  drivers/usb/core/hcd.c        |   20 ++++++++++----------
>  drivers/usb/core/hub.c        |    8 ++++----
>  drivers/usb/host/ehci-fsl.c   |   16 ++++++++--------
>  drivers/usb/host/ehci-hub.c   |    2 +-
>  drivers/usb/host/ehci-msm.c   |    4 ++--
>  drivers/usb/host/ehci-tegra.c |   16 ++++++++--------
>  drivers/usb/host/ohci-omap.c  |   20 ++++++++++----------
>  drivers/usb/misc/lvstest.c    |    8 ++++----
>  include/linux/usb/hcd.h       |    2 +-
>  10 files changed, 49 insertions(+), 49 deletions(-)
>=20
> Index: usb/drivers/usb/chipidea/host.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/chipidea/host.c
> +++ usb/drivers/usb/chipidea/host.c
> @@ -59,7 +59,7 @@ static int host_start(struct ci_hdrc *ci
>  	hcd->has_tt =3D 1;
> =20
>  	hcd->power_budget =3D ci->platdata->power_budget;
> -	hcd->phy =3D ci->transceiver;
> +	hcd->usb_phy =3D ci->transceiver;
> =20
>  	ehci =3D hcd_to_ehci(hcd);
>  	ehci->caps =3D ci->hw_bank.cap;
> Index: usb/drivers/usb/core/hcd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/core/hcd.c
> +++ usb/drivers/usb/core/hcd.c
> @@ -2627,7 +2627,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  	int retval;
>  	struct usb_device *rhdev;
> =20
> -	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->phy) {
> +	if (IS_ENABLED(CONFIG_USB_PHY) && !hcd->usb_phy) {
>  		struct usb_phy *phy =3D usb_get_phy_dev(hcd->self.controller, 0);
> =20
>  		if (IS_ERR(phy)) {
> @@ -2640,7 +2640,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  				usb_put_phy(phy);
>  				return retval;
>  			}
> -			hcd->phy =3D phy;
> +			hcd->usb_phy =3D phy;
>  			hcd->remove_phy =3D 1;
>  		}
>  	}
> @@ -2788,10 +2788,10 @@ err_allocate_root_hub:
>  err_register_bus:
>  	hcd_buffer_destroy(hcd);
>  err_remove_phy:
> -	if (hcd->remove_phy && hcd->phy) {
> -		usb_phy_shutdown(hcd->phy);
> -		usb_put_phy(hcd->phy);
> -		hcd->phy =3D NULL;
> +	if (hcd->remove_phy && hcd->usb_phy) {
> +		usb_phy_shutdown(hcd->usb_phy);
> +		usb_put_phy(hcd->usb_phy);
> +		hcd->usb_phy =3D NULL;
>  	}
>  	return retval;
>  }
> @@ -2864,10 +2864,10 @@ void usb_remove_hcd(struct usb_hcd *hcd)
> =20
>  	usb_deregister_bus(&hcd->self);
>  	hcd_buffer_destroy(hcd);
> -	if (hcd->remove_phy && hcd->phy) {
> -		usb_phy_shutdown(hcd->phy);
> -		usb_put_phy(hcd->phy);
> -		hcd->phy =3D NULL;
> +	if (hcd->remove_phy && hcd->usb_phy) {
> +		usb_phy_shutdown(hcd->usb_phy);
> +		usb_put_phy(hcd->usb_phy);
> +		hcd->usb_phy =3D NULL;
>  	}
> =20
>  	usb_put_invalidate_rhdev(hcd);
> Index: usb/drivers/usb/core/hub.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/core/hub.c
> +++ usb/drivers/usb/core/hub.c
> @@ -4461,8 +4461,8 @@ hub_port_init (struct usb_hub *hub, stru
>  	if (retval)
>  		goto fail;
> =20
> -	if (hcd->phy && !hdev->parent)
> -		usb_phy_notify_connect(hcd->phy, udev->speed);
> +	if (hcd->usb_phy && !hdev->parent)
> +		usb_phy_notify_connect(hcd->usb_phy, udev->speed);
> =20
>  	/*
>  	 * Some superspeed devices have finished the link training process
> @@ -4617,9 +4617,9 @@ static void hub_port_connect(struct usb_
> =20
>  	/* Disconnect any existing devices under this port */
>  	if (udev) {
> -		if (hcd->phy && !hdev->parent &&
> +		if (hcd->usb_phy && !hdev->parent &&
>  				!(portstatus & USB_PORT_STAT_CONNECTION))
> -			usb_phy_notify_disconnect(hcd->phy, udev->speed);
> +			usb_phy_notify_disconnect(hcd->usb_phy, udev->speed);
>  		usb_disconnect(&port_dev->child);
>  	}
> =20
> Index: usb/drivers/usb/host/ehci-fsl.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/host/ehci-fsl.c
> +++ usb/drivers/usb/host/ehci-fsl.c
> @@ -136,15 +136,15 @@ static int usb_hcd_fsl_probe(const struc
>  	if (pdata->operating_mode =3D=3D FSL_USB2_DR_OTG) {
>  		struct ehci_hcd *ehci =3D hcd_to_ehci(hcd);
> =20
> -		hcd->phy =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +		hcd->usb_phy =3D usb_get_phy(USB_PHY_TYPE_USB2);
>  		dev_dbg(&pdev->dev, "hcd=3D0x%p  ehci=3D0x%p, phy=3D0x%p\n",
> -			hcd, ehci, hcd->phy);
> +			hcd, ehci, hcd->usb_phy);
> =20
> -		if (!IS_ERR_OR_NULL(hcd->phy)) {
> -			retval =3D otg_set_host(hcd->phy->otg,
> +		if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
> +			retval =3D otg_set_host(hcd->usb_phy->otg,
>  					      &ehci_to_hcd(ehci)->self);
>  			if (retval) {
> -				usb_put_phy(hcd->phy);
> +				usb_put_phy(hcd->usb_phy);
>  				goto err2;
>  			}
>  		} else {
> @@ -181,9 +181,9 @@ static void usb_hcd_fsl_remove(struct us
>  {
>  	struct fsl_usb2_platform_data *pdata =3D dev_get_platdata(&pdev->dev);
> =20
> -	if (!IS_ERR_OR_NULL(hcd->phy)) {
> -		otg_set_host(hcd->phy->otg, NULL);
> -		usb_put_phy(hcd->phy);
> +	if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
> +		otg_set_host(hcd->usb_phy->otg, NULL);
> +		usb_put_phy(hcd->usb_phy);
>  	}
> =20
>  	usb_remove_hcd(hcd);
> Index: usb/drivers/usb/host/ehci-hub.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/host/ehci-hub.c
> +++ usb/drivers/usb/host/ehci-hub.c
> @@ -922,7 +922,7 @@ int ehci_hub_control(
>  #ifdef CONFIG_USB_OTG
>  			if ((hcd->self.otg_port =3D=3D (wIndex + 1))
>  			    && hcd->self.b_hnp_enable) {
> -				otg_start_hnp(hcd->phy->otg);
> +				otg_start_hnp(hcd->usb_phy->otg);
>  				break;
>  			}
>  #endif
> Index: usb/drivers/usb/host/ehci-msm.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/host/ehci-msm.c
> +++ usb/drivers/usb/host/ehci-msm.c
> @@ -124,7 +124,7 @@ static int ehci_msm_probe(struct platfor
>  		goto put_hcd;
>  	}
> =20
> -	hcd->phy =3D phy;
> +	hcd->usb_phy =3D phy;
>  	device_init_wakeup(&pdev->dev, 1);
>  	/*
>  	 * OTG device parent of HCD takes care of putting
> @@ -151,7 +151,7 @@ static int ehci_msm_remove(struct platfo
>  	pm_runtime_disable(&pdev->dev);
>  	pm_runtime_set_suspended(&pdev->dev);
> =20
> -	otg_set_host(hcd->phy->otg, NULL);
> +	otg_set_host(hcd->usb_phy->otg, NULL);
> =20
>  	/* FIXME: need to call usb_remove_hcd() here? */
> =20
> Index: usb/drivers/usb/host/ehci-tegra.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/host/ehci-tegra.c
> +++ usb/drivers/usb/host/ehci-tegra.c
> @@ -206,7 +206,7 @@ static int tegra_ehci_hub_control(
>  		if (tegra->port_resuming && !(temp & PORT_SUSPEND)) {
>  			/* Resume completed, re-enable disconnect detection */
>  			tegra->port_resuming =3D 0;
> -			tegra_usb_phy_postresume(hcd->phy);
> +			tegra_usb_phy_postresume(hcd->usb_phy);
>  		}
>  	}
> =20
> @@ -259,7 +259,7 @@ static int tegra_ehci_hub_control(
>  			goto done;
> =20
>  		/* Disable disconnect detection during port resume */
> -		tegra_usb_phy_preresume(hcd->phy);
> +		tegra_usb_phy_preresume(hcd->usb_phy);
> =20
>  		ehci->reset_done[wIndex-1] =3D jiffies + msecs_to_jiffies(25);
> =20
> @@ -454,7 +454,7 @@ static int tegra_ehci_probe(struct platf
>  		err =3D PTR_ERR(u_phy);
>  		goto cleanup_clk_en;
>  	}
> -	hcd->phy =3D u_phy;
> +	hcd->usb_phy =3D u_phy;
> =20
>  	tegra->needs_double_reset =3D of_property_read_bool(pdev->dev.of_node,
>  		"nvidia,needs-double-reset");
> @@ -475,7 +475,7 @@ static int tegra_ehci_probe(struct platf
>  	ehci->caps =3D hcd->regs + 0x100;
>  	ehci->has_hostpc =3D soc_config->has_hostpc;
> =20
> -	err =3D usb_phy_init(hcd->phy);
> +	err =3D usb_phy_init(hcd->usb_phy);
>  	if (err) {
>  		dev_err(&pdev->dev, "Failed to initialize phy\n");
>  		goto cleanup_clk_en;
> @@ -490,7 +490,7 @@ static int tegra_ehci_probe(struct platf
>  	}
>  	u_phy->otg->host =3D hcd_to_bus(hcd);
> =20
> -	err =3D usb_phy_set_suspend(hcd->phy, 0);
> +	err =3D usb_phy_set_suspend(hcd->usb_phy, 0);
>  	if (err) {
>  		dev_err(&pdev->dev, "Failed to power on the phy\n");
>  		goto cleanup_phy;
> @@ -517,7 +517,7 @@ static int tegra_ehci_probe(struct platf
>  cleanup_otg_set_host:
>  	otg_set_host(u_phy->otg, NULL);
>  cleanup_phy:
> -	usb_phy_shutdown(hcd->phy);
> +	usb_phy_shutdown(hcd->usb_phy);
>  cleanup_clk_en:
>  	clk_disable_unprepare(tegra->clk);
>  cleanup_hcd_create:
> @@ -531,9 +531,9 @@ static int tegra_ehci_remove(struct plat
>  	struct tegra_ehci_hcd *tegra =3D
>  		(struct tegra_ehci_hcd *)hcd_to_ehci(hcd)->priv;
> =20
> -	otg_set_host(hcd->phy->otg, NULL);
> +	otg_set_host(hcd->usb_phy->otg, NULL);
> =20
> -	usb_phy_shutdown(hcd->phy);
> +	usb_phy_shutdown(hcd->usb_phy);
>  	usb_remove_hcd(hcd);
> =20
>  	clk_disable_unprepare(tegra->clk);
> Index: usb/drivers/usb/host/ohci-omap.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/host/ohci-omap.c
> +++ usb/drivers/usb/host/ohci-omap.c
> @@ -180,10 +180,10 @@ static void start_hnp(struct ohci_hcd *o
>  	unsigned long	flags;
>  	u32 l;
> =20
> -	otg_start_hnp(hcd->phy->otg);
> +	otg_start_hnp(hcd->usb_phy->otg);
> =20
>  	local_irq_save(flags);
> -	hcd->phy->state =3D OTG_STATE_A_SUSPEND;
> +	hcd->usb_phy->state =3D OTG_STATE_A_SUSPEND;
>  	writel (RH_PS_PSS, &ohci->regs->roothub.portstatus [port]);
>  	l =3D omap_readl(OTG_CTRL);
>  	l &=3D ~OTG_A_BUSREQ;
> @@ -220,14 +220,14 @@ static int ohci_omap_reset(struct usb_hc
> =20
>  #ifdef	CONFIG_USB_OTG
>  	if (need_transceiver) {
> -		hcd->phy =3D usb_get_phy(USB_PHY_TYPE_USB2);
> -		if (!IS_ERR_OR_NULL(hcd->phy)) {
> -			int	status =3D otg_set_host(hcd->phy->otg,
> +		hcd->usb_phy =3D usb_get_phy(USB_PHY_TYPE_USB2);
> +		if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
> +			int	status =3D otg_set_host(hcd->usb_phy->otg,
>  						&ohci_to_hcd(ohci)->self);
>  			dev_dbg(hcd->self.controller, "init %s phy, status %d\n",
> -					hcd->phy->label, status);
> +					hcd->usb_phy->label, status);
>  			if (status) {
> -				usb_put_phy(hcd->phy);
> +				usb_put_phy(hcd->usb_phy);
>  				return status;
>  			}
>  		} else {
> @@ -399,9 +399,9 @@ usb_hcd_omap_remove (struct usb_hcd *hcd
>  	dev_dbg(hcd->self.controller, "stopping USB Controller\n");
>  	usb_remove_hcd(hcd);
>  	omap_ohci_clock_power(0);
> -	if (!IS_ERR_OR_NULL(hcd->phy)) {
> -		(void) otg_set_host(hcd->phy->otg, 0);
> -		usb_put_phy(hcd->phy);
> +	if (!IS_ERR_OR_NULL(hcd->usb_phy)) {
> +		(void) otg_set_host(hcd->usb_phy->otg, 0);
> +		usb_put_phy(hcd->usb_phy);
>  	}
>  	if (machine_is_omap_osk())
>  		gpio_free(9);
> Index: usb/drivers/usb/misc/lvstest.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/drivers/usb/misc/lvstest.c
> +++ usb/drivers/usb/misc/lvstest.c
> @@ -333,13 +333,13 @@ static void lvs_rh_work(struct work_stru
>  					USB_PORT_STAT_CONNECTION) {
>  				lvs->present =3D true;
>  				lvs->portnum =3D i;
> -				if (hcd->phy)
> -					usb_phy_notify_connect(hcd->phy,
> +				if (hcd->usb_phy)
> +					usb_phy_notify_connect(hcd->usb_phy,
>  							USB_SPEED_SUPER);
>  			} else {
>  				lvs->present =3D false;
> -				if (hcd->phy)
> -					usb_phy_notify_disconnect(hcd->phy,
> +				if (hcd->usb_phy)
> +					usb_phy_notify_disconnect(hcd->usb_phy,
>  							USB_SPEED_SUPER);
>  			}
>  			break;
> Index: usb/include/linux/usb/hcd.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb.orig/include/linux/usb/hcd.h
> +++ usb/include/linux/usb/hcd.h
> @@ -106,7 +106,7 @@ struct usb_hcd {
>  	 * OTG and some Host controllers need software interaction with phys;
>  	 * other external phys should be software-transparent
>  	 */
> -	struct usb_phy	*phy;
> +	struct usb_phy		*usb_phy;
> =20
>  	/* Flags that need to be manipulated atomically because they can
>  	 * change while the host controller is running.  Always use
>=20

--=20
balbi

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUCcNwAAoJEIaOsuA1yqREIHUP/2WwGoJH+rwx8cXO1iUkHFtY
kgvIE0+9x0Xmlyh6Zgxxweht/g9tbAmFdhd+C/hRjWXVQ/qyy7fpAlLC+PonqiWD
/nawis5v1xEb/6UgY/weuZFXRqT2nM3jdnzewxENRXgBjSSP/i9bWIltuGPafKDf
JlFy921xmnJcLf1t0y/nE9Y5p0hOzkcjgxlYBI3ByphluChPZ0DWfsMjf7xTomXv
9+9uGLiTIJZG5Sdv/poR5vXOpK/txsiHPgoczww7CxFkY3wvs7l1yxGI9XU++/2T
SUduscW9IKkqpBu/+Z/BdWvI1pURBuJO382478iRDfnrQz+RSJ4UTftCEFdF2e6q
RarrYMJ8M87IQRlugEyt15Dy0De+ChqHlXDrsFCJmjRXi3kPtHUb2VTaTg3kUz7w
SPtAUSBFvHajlDIhYMizIKrn9E7+pCfyBTCA30xM15KVAq0p9vOxMSpUO0ZnUS1B
SHzPTsOZgDAGFmZm5wS6oewZYmSV1MEqvIi8PgC7VMwvVSRiDtMHi9NTrFrRVvuN
n8kZRmDzwHSwTzyuWZp5Lttu5xCjKTbDQi2H2751yORrOKRaZH+vkwV4Mfsc4jBL
Fk1sZz/2nxwukdDzU2Rvj29O3edhLgGWs+kU7otC79ibVrKRs94Dx9KsXrOPc0SQ
eROpa5onxnhFEgc36nPw
=v4dJ
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
