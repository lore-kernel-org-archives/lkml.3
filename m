Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaGXLVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:21:11 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:28491
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755853AbaGXLVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:21:06 -0400
Date: Thu, 24 Jul 2014 19:12:56 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 7/8] usb: rename transceiver and phy to usb_phy in
 ChipIdea
Message-ID: <20140724111254.GA26984@shlinux1.ap.freescale.net>
References: <1405435156-27297-1-git-send-email-antoine.tenart@free-electrons.com>
 <1405435156-27297-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405435156-27297-8-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(76176999)(83072002)(81342001)(50986999)(97736001)(46102001)(102836001)(85852003)(83506001)(104016003)(105606002)(4396001)(33656002)(76482001)(81542001)(31966008)(47776003)(80022001)(20776003)(83322001)(110136001)(84676001)(23756003)(74502001)(6806004)(95666004)(86362001)(79102001)(19580395003)(50466002)(44976005)(74662001)(21056001)(81156004)(68736004)(99396002)(54356999)(107046002)(64706001)(85306003)(106466001)(69596002)(26826002)(87936001)(92566001)(92726001)(77982001)(19580405001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB571;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:39:15PM +0200, Antoine Ténart wrote:
> This patch prepares the introduction of the generic PHY support in the
> USB ChipIdea common functions. The USB PHY member of the ChipIdea
> structure ('transceiver') is renamed to 'usb_phy', the 'phy' member of
> the ChipIdea pdata structure is renamed to 'usb_phy' and modifications
> are done in all drivers accessing it. Renaming this pointer will allow
> to keep the compatibility for USB PHY drivers.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/usb/chipidea/ci.h          |  4 ++--
>  drivers/usb/chipidea/ci_hdrc_imx.c |  2 +-
>  drivers/usb/chipidea/ci_hdrc_msm.c |  8 ++++----
>  drivers/usb/chipidea/core.c        | 20 ++++++++++----------
>  drivers/usb/chipidea/debug.c       |  2 +-
>  drivers/usb/chipidea/host.c        |  4 ++--
>  drivers/usb/chipidea/otg_fsm.c     |  4 ++--
>  drivers/usb/chipidea/udc.c         |  4 ++--
>  include/linux/usb/chipidea.h       |  2 +-
>  9 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
> index 9563cb56d564..b2caa1772712 100644
> --- a/drivers/usb/chipidea/ci.h
> +++ b/drivers/usb/chipidea/ci.h
> @@ -161,7 +161,7 @@ struct hw_bank {
>   * @test_mode: the selected test mode
>   * @platdata: platform specific information supplied by parent device
>   * @vbus_active: is VBUS active
> - * @transceiver: pointer to USB PHY, if any
> + * @usb_phy: pointer to USB PHY, if any
>   * @hcd: pointer to usb_hcd for ehci host driver
>   * @debugfs: root dentry for this controller in debugfs
>   * @id_event: indicates there is an id event, and handled at ci_otg_work
> @@ -201,7 +201,7 @@ struct ci_hdrc {
>  
>  	struct ci_hdrc_platform_data	*platdata;
>  	int				vbus_active;
> -	struct usb_phy			*transceiver;
> +	struct usb_phy			*usb_phy;
>  	struct usb_hcd			*hcd;
>  	struct dentry			*debugfs;
>  	bool				id_event;
> diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
> index 2e58f8dfd311..33b982dddac5 100644
> --- a/drivers/usb/chipidea/ci_hdrc_imx.c
> +++ b/drivers/usb/chipidea/ci_hdrc_imx.c
> @@ -136,7 +136,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
>  		goto err_clk;
>  	}
>  
> -	pdata.phy = data->phy;
> +	pdata.usb_phy = data->phy;
>  
>  	if (imx_platform_flag->flags & CI_HDRC_IMX_IMX28_WRITE_FIX)
>  		pdata.flags |= CI_HDRC_IMX28_WRITE_FIX;
> diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> index d72b9d2de2c5..94cd7c3e12a3 100644
> --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> @@ -31,13 +31,13 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
>  	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
>  		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
>  		/*
> -		 * Put the transceiver in non-driving mode. Otherwise host
> +		 * Put the phy in non-driving mode. Otherwise host
>  		 * may not detect soft-disconnection.
>  		 */
> -		val = usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
> +		val = usb_phy_io_read(ci->usb_phy, ULPI_FUNC_CTRL);
>  		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
>  		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
> -		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
> +		usb_phy_io_write(ci->usb_phy, val, ULPI_FUNC_CTRL);
>  		break;
>  	default:
>  		dev_dbg(dev, "unknown ci_hdrc event\n");
> @@ -71,7 +71,7 @@ static int ci_hdrc_msm_probe(struct platform_device *pdev)
>  	if (IS_ERR(phy))
>  		return PTR_ERR(phy);
>  
> -	ci_hdrc_msm_platdata.phy = phy;
> +	ci_hdrc_msm_platdata.usb_phy = phy;
>  
>  	plat_ci = ci_hdrc_add_device(&pdev->dev,
>  				pdev->resource, pdev->num_resources,
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 619d13e29995..a8cd35fd8175 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -306,7 +306,7 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
>  	case USBPHY_INTERFACE_MODE_UTMI:
>  	case USBPHY_INTERFACE_MODE_UTMIW:
>  	case USBPHY_INTERFACE_MODE_HSIC:
> -		ret = usb_phy_init(ci->transceiver);
> +		ret = usb_phy_init(ci->usb_phy);
>  		if (ret)
>  			return ret;
>  		hw_phymode_configure(ci);
> @@ -314,12 +314,12 @@ static int ci_usb_phy_init(struct ci_hdrc *ci)
>  	case USBPHY_INTERFACE_MODE_ULPI:
>  	case USBPHY_INTERFACE_MODE_SERIAL:
>  		hw_phymode_configure(ci);
> -		ret = usb_phy_init(ci->transceiver);
> +		ret = usb_phy_init(ci->usb_phy);
>  		if (ret)
>  			return ret;
>  		break;
>  	default:
> -		ret = usb_phy_init(ci->transceiver);
> +		ret = usb_phy_init(ci->usb_phy);
>  	}
>  
>  	return ret;
> @@ -595,13 +595,13 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
>  
> -	if (ci->platdata->phy)
> -		ci->transceiver = ci->platdata->phy;
> +	if (ci->platdata->usb_phy)
> +		ci->usb_phy = ci->platdata->usb_phy;
>  	else
> -		ci->transceiver = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> +		ci->usb_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
>  
> -	if (IS_ERR(ci->transceiver)) {
> -		ret = PTR_ERR(ci->transceiver);
> +	if (IS_ERR(ci->usb_phy)) {
> +		ret = PTR_ERR(ci->usb_phy);
>  		/*
>  		 * if -ENXIO is returned, it means PHY layer wasn't
>  		 * enabled, so it makes no sense to return -EPROBE_DEFER
> @@ -718,7 +718,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>  stop:
>  	ci_role_destroy(ci);
>  deinit_phy:
> -	usb_phy_shutdown(ci->transceiver);
> +	usb_phy_shutdown(ci->usb_phy);
>  
>  	return ret;
>  }
> @@ -731,7 +731,7 @@ static int ci_hdrc_remove(struct platform_device *pdev)
>  	free_irq(ci->irq, ci);
>  	ci_role_destroy(ci);
>  	ci_hdrc_enter_lpm(ci, true);
> -	usb_phy_shutdown(ci->transceiver);
> +	usb_phy_shutdown(ci->usb_phy);
>  	kfree(ci->hw_bank.regmap);
>  
>  	return 0;
> diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> index 9a9702773e43..d47cddd38e4a 100644
> --- a/drivers/usb/chipidea/debug.c
> +++ b/drivers/usb/chipidea/debug.c
> @@ -219,7 +219,7 @@ int ci_otg_show(struct seq_file *s, void *unused)
>  	fsm = &ci->fsm;
>  
>  	/* ------ State ----- */
> -		usb_otg_state_string(ci->transceiver->otg.state));
> +		usb_otg_state_string(ci->usb_phy->otg.state));
>  
>  	/* ------ State Machine Variables ----- */
>  	seq_printf(s, "a_bus_drop: %d\n", fsm->a_bus_drop);
> diff --git a/drivers/usb/chipidea/host.c b/drivers/usb/chipidea/host.c
> index fc7541c906a2..0b67d78dd953 100644
> --- a/drivers/usb/chipidea/host.c
> +++ b/drivers/usb/chipidea/host.c
> @@ -59,7 +59,7 @@ static int host_start(struct ci_hdrc *ci)
>  	hcd->has_tt = 1;
>  
>  	hcd->power_budget = ci->platdata->power_budget;
> -	hcd->usb_phy = ci->transceiver;
> +	hcd->usb_phy = ci->usb_phy;
>  
>  	ehci = hcd_to_ehci(hcd);
>  	ehci->caps = ci->hw_bank.cap;
> @@ -85,7 +85,7 @@ static int host_start(struct ci_hdrc *ci)
>  	if (ret) {
>  		goto disable_reg;
>  	} else {
> -		struct usb_otg *otg = ci->transceiver->otg;
> +		struct usb_otg *otg = ci->usb_phy->otg;
>  
>  		ci->hcd = hcd;
>  		if (otg) {
> diff --git a/drivers/usb/chipidea/otg_fsm.c b/drivers/usb/chipidea/otg_fsm.c
> index d8490e758a74..8a64ce87364e 100644
> --- a/drivers/usb/chipidea/otg_fsm.c
> +++ b/drivers/usb/chipidea/otg_fsm.c
> @@ -788,10 +788,10 @@ int ci_hdrc_otg_fsm_init(struct ci_hdrc *ci)
>  		return -ENOMEM;
>  	}
>  
> -	otg->usb_phy = ci->transceiver;
> +	otg->usb_phy = ci->usb_phy;
>  	otg->gadget = &ci->gadget;
>  	ci->fsm.otg = otg;
> -	ci->transceiver->otg = ci->fsm.otg;
> +	ci->usb_phy->otg = ci->fsm.otg;
>  	ci->fsm.power_up = 1;
>  	ci->fsm.id = hw_read_otgsc(ci, OTGSC_ID) ? 1 : 0;
>  	ci->fsm.otg->state = OTG_STATE_UNDEFINED;
> diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
> index 9d2b673f90e3..9d3966308942 100644
> --- a/drivers/usb/chipidea/udc.c
> +++ b/drivers/usb/chipidea/udc.c
> @@ -1519,8 +1519,8 @@ static int ci_udc_vbus_draw(struct usb_gadget *_gadget, unsigned ma)
>  {
>  	struct ci_hdrc *ci = container_of(_gadget, struct ci_hdrc, gadget);
>  
> -	if (ci->transceiver)
> -		return usb_phy_set_power(ci->transceiver, ma);
> +	if (ci->usb_phy)
> +		return usb_phy_set_power(ci->usb_phy, ma);
>  	return -ENOTSUPP;
>  }
>  
> diff --git a/include/linux/usb/chipidea.h b/include/linux/usb/chipidea.h
> index bbe779f640be..57d757a1aa83 100644
> --- a/include/linux/usb/chipidea.h
> +++ b/include/linux/usb/chipidea.h
> @@ -13,7 +13,7 @@ struct ci_hdrc_platform_data {
>  	/* offset of the capability registers */
>  	uintptr_t	 capoffset;
>  	unsigned	 power_budget;
> -	struct usb_phy	*phy;
> +	struct usb_phy	*usb_phy;
>  	enum usb_phy_interface phy_mode;
>  	unsigned long	 flags;
>  #define CI_HDRC_REGS_SHARED		BIT(0)
> -- 
> 1.9.1
> 

This patch looks ok.

-- 

Best Regards,
Peter Chen
