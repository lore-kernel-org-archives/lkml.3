Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbaJJSI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:08:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56183 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754760AbaJJSIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:08:25 -0400
Date: Fri, 10 Oct 2014 13:07:27 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/12] rtc: omap: add support for pmic_power_en
Message-ID: <20141010180721.GV31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-10-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UhXv5VeBZ/Y8lRnC"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-10-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UhXv5VeBZ/Y8lRnC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 09, 2014 at 09:06:31PM +0200, Johan Hovold wrote:
> @@ -124,11 +138,18 @@
>   */
>  #define OMAP_RTC_HAS_POWER_UP_RESET	BIT(3)
> =20
> +/*
> + * Some RTC IP revisions can control an external PMIC via the pmic_power=
_en
> + * pin.
> + */
> +#define OMAP_RTC_HAS_PMIC_MODE		BIT(4)
> +
>  static void __iomem	*rtc_base;
> =20
>  #define rtc_read(addr)		readb(rtc_base + (addr))
>  #define rtc_write(val, addr)	writeb(val, rtc_base + (addr))
> =20
> +#define rtc_readl(addr)		readl(rtc_base + (addr))

looks like this should be part of another patch. Or, at a minimum (since
it's so minor), it deserves a mention on commit log.

>  #define rtc_writel(val, addr)	writel(val, rtc_base + (addr))
> =20
> =20
> @@ -338,6 +359,61 @@ static int omap_rtc_set_alarm(struct device *dev, st=
ruct rtc_wkalrm *alm)
>  	return 0;
>  }
> =20
> +static struct platform_device *omap_rtc_power_off_dev;
> +
> +/*
> + * omap_rtc_poweroff: RTC-controlled power off
> + *
> + * The RTC can be used to control an external PMIC via the pmic_power_en=
 pin,
> + * which can be configured to transition to OFF on ALARM2 events.
> + *
> + * Notes:
> + * The two-second alarm offset is the shortest offset possible as the al=
arm
> + * registers must be set before the next timer update and the offset
> + * calculation is to heavy for everything to be done within a single acc=
ess

s/to/too

> @@ -425,10 +505,12 @@ static int __init omap_rtc_probe(struct platform_de=
vice *pdev)
>  		rtc_writel(KICK1_VALUE, OMAP_RTC_KICK1_REG);
>  	}
> =20
> -	/* clear pending irqs, and set 1/second periodic,
> -	 * which we'll use instead of update irqs
> +	/*
> +	 * disable interrupts
> +	 *
> +	 * NOTE: ALARM2 is not cleared on AM3352 if rtc_write (writeb) is used
>  	 */
> -	rtc_write(0, OMAP_RTC_INTERRUPTS_REG);
> +	rtc_writel(0, OMAP_RTC_INTERRUPTS_REG);

bug fix, should be part of a separate patch and Cc stable :-)

--=20
balbi

--UhXv5VeBZ/Y8lRnC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCBfAAoJEIaOsuA1yqRE4w8P/A7gxViyJC0NGSToczXOZsGJ
JqckNDKhqMQ0pIaWFvfdxCC888R/5Ibwv24W4jugw2dC5nrggKUmwb7wTPibIIv/
+wgdeuC2cTCsKy81n2xS6ecJkUOKTVqnnHSVYbGmpp1zlPLlGTBeR6J3SnM44JQ5
Zdqh8rE7/fyLYo7oDJxV50f6WT7yREpygBrxIiLAKqtUMbH7LRkcFTI5ofWg5wB2
lucMhCQjd8XsjfsOPri3GUZKHEQtYpqSFwbovqhcChoPNFWAxruyMA0eCsBMQmXw
rYny+Zm02rqat8jw0b70jH+h/aYpd5BXzSs7WlTRvLd7WHwTm1dl+cXVdHIIItDy
6DTo/Gefuz7BsjX4Xl+rlq5mvIJJ5G7VrUuPAgp1jzim+egsRCCHckISUJHW11TO
2l6lwDgmehpccMcVGw89e4p0ld8EZ54ZctDg+xN6IJKBAieJa1ucJ80y2uRLn6kB
dmD+zO1mNlMMH6lObl5pweWLlV/biVaVmGJEB+bWdU9xnT7FjnAoCN+lvJ0hCOis
n1ffwHuZVJp28LsRnhvf5OtTC6jbvQ9xmK+g5Pu9JnbUIdfv3HKvfYEvSR54aJM4
imDmlz1hHHDKMwwk+zOMAQkJlgaFK2KPBpHRBBKdqATfeK5RnDXpLyolBUK4CAJQ
hw1EFpQbUnsb++i0D6tf
=MO7H
-----END PGP SIGNATURE-----

--UhXv5VeBZ/Y8lRnC--
