Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaBYSfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:35:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44390 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbaBYSfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:35:02 -0500
Date: Tue, 25 Feb 2014 12:33:36 -0600
From: Felipe Balbi <balbi@ti.com>
To: Josh Cartwright <joshc@codeaurora.org>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-pm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usb: phy: msm: use ASSIGN_*_PM_OPS variants
Message-ID: <20140225183336.GH23275@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393261707-30565-1-git-send-email-joshc@codeaurora.org>
 <1393261707-30565-4-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/pVXlBMPtxfSuJG"
Content-Disposition: inline
In-Reply-To: <1393261707-30565-4-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8/pVXlBMPtxfSuJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 24, 2014 at 11:08:27AM -0600, Josh Cartwright wrote:
> Use ASSIGN_SYSTEM_SLEEP_PM_OPS and ASSIGN_RUNTIME_PM_OPS in the
> initializer for msm_otg_dev_pm_ops.  Doing so allows us to eliminate
> preprocessor conditionals around the specified callbacks.
>=20
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/usb/phy/phy-msm-usb.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> index 5b37b81..c04f2e3 100644
> --- a/drivers/usb/phy/phy-msm-usb.c
> +++ b/drivers/usb/phy/phy-msm-usb.c
> @@ -414,8 +414,6 @@ static int msm_otg_reset(struct usb_phy *phy)
>  #define PHY_SUSPEND_TIMEOUT_USEC	(500 * 1000)
>  #define PHY_RESUME_TIMEOUT_USEC	(100 * 1000)
> =20
> -#ifdef CONFIG_PM
> -
>  #define USB_PHY_SUSP_DIG_VOL  500000
>  static int msm_hsusb_config_vddcx(int high)
>  {
> @@ -609,7 +607,6 @@ skip_phy_resume:
> =20
>  	return 0;
>  }
> -#endif
> =20
>  static void msm_otg_notify_charger(struct msm_otg *motg, unsigned mA)
>  {
> @@ -1664,7 +1661,6 @@ static int msm_otg_remove(struct platform_device *p=
dev)
>  	return 0;
>  }
> =20
> -#ifdef CONFIG_PM_RUNTIME
>  static int msm_otg_runtime_idle(struct device *dev)
>  {
>  	struct msm_otg *motg =3D dev_get_drvdata(dev);
> @@ -1699,9 +1695,7 @@ static int msm_otg_runtime_resume(struct device *de=
v)
>  	dev_dbg(dev, "OTG runtime resume\n");
>  	return msm_otg_resume(motg);
>  }
> -#endif
> =20
> -#ifdef CONFIG_PM_SLEEP
>  static int msm_otg_pm_suspend(struct device *dev)
>  {
>  	struct msm_otg *motg =3D dev_get_drvdata(dev);
> @@ -1731,12 +1725,11 @@ static int msm_otg_pm_resume(struct device *dev)
> =20
>  	return 0;
>  }
> -#endif
> =20
>  static const struct dev_pm_ops msm_otg_dev_pm_ops =3D {
> -	SET_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
> -	SET_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
> -				msm_otg_runtime_idle)
> +	ASSIGN_SYSTEM_SLEEP_PM_OPS(msm_otg_pm_suspend, msm_otg_pm_resume)
> +	ASSIGN_RUNTIME_PM_OPS(msm_otg_runtime_suspend, msm_otg_runtime_resume,
> +			      msm_otg_runtime_idle)

if the patch introducing assign_if() gets accepted, I'm ok with this
patch.

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--8/pVXlBMPtxfSuJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTDOIAAAoJEIaOsuA1yqREnlUP/0DTKmQpYxLI71myYXP0bmYs
bBuFeq5+NA7mmgvJn4daLZyPF5KlyGBE1eK5vctYkPmpUPyLiWfp9Xm9warnUrFv
4yMFn70MJW1Yc5W/t/Jed0HDVUd89+8qj4BzuoKBUKnnN22k+x5oD1lehEWocwE4
8Y+LAIYHn+/5bG+JL+fj0ZirCXr574oC8+vhe8gyjDUI123euil92jkb8jxTXPBY
zGUYEjRdgtLXnMKxN2f1n/te4e45Eqql+LKvaLovs6v4jTdJmXe5BvFsLXMo+Xw3
0EPYY6ABDBmP2G8C0wQwRjWi3xwTFkT+/BtOusk06O51qYS8gwAFbQCoLBWnnJHG
+szCak1JAEFWzbtUwdSKSpV90236ni7d6k2Fcv/7PA3teP7vn0rblZDckB6lOz5i
pyXlZ8eVaIIElXPoNgIdomdIlknD1iBWO4ira4Qmn0bDmZbGD3ZdlOQj6pQ1e8uw
W//qtrqevGDc0JnN6NYVoY/4+DY/SAZdK6KJ3iZUE4OFgBfLkkpIhvUR03ikVvFM
IguIAl+Zr2y4UHLiix+aSdH6clgEEmx/OYScYyiHLM1uxLMzD1jfwb27Geb7R34P
mGkZSq8uDR9T+vtJpguM2KBhAi8DRCrtY3V4TpVH2rtGG9DX9zk0fS8/h0i3H2RN
5IGXkrK2QdN21wiaTh1v
=gQGh
-----END PGP SIGNATURE-----

--8/pVXlBMPtxfSuJG--
