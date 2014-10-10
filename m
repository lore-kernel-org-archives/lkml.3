Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaJJSDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:03:30 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60542 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaJJSD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:03:28 -0400
Date: Fri, 10 Oct 2014 13:02:31 -0500
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
Subject: Re: [PATCH 08/12] rtc: omap: restore irq state after reading TC
 registers
Message-ID: <20141010180225.GT31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-9-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sT0SRK93LqpGW452"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-9-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sT0SRK93LqpGW452
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 09, 2014 at 09:06:30PM +0200, Johan Hovold wrote:
> Make sure to restore local irq state when reading the timer/calendar
> (TC) registers, so that omap_rtc_read_time() can be called with
> interrupts disabled.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/rtc/rtc-omap.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> index 0ef016553a97..62e2e9a9887a 100644
> --- a/drivers/rtc/rtc-omap.c
> +++ b/drivers/rtc/rtc-omap.c
> @@ -239,8 +239,10 @@ static void bcd2tm(struct rtc_time *tm)
> =20
>  static int omap_rtc_read_time(struct device *dev, struct rtc_time *tm)
>  {
> +	unsigned long flags;
> +
>  	/* we don't report wday/yday/isdst ... */
> -	local_irq_disable();
> +	local_irq_save(flags);

you should really convert these to a real spin_lock_irq*(), that's
because local_irq* do not get re-written with RT patchset, so this
pretty much "breaks" RT.

--=20
balbi

--sT0SRK93LqpGW452
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOB83AAoJEIaOsuA1yqRERkUQAKTvqxK7GEXdumizPMqfyH+P
GcuUz0eN86Mg/OkActLci7WDkorwlDvfZm8OiB7Fyk6EP6MKl2scHWguhFuTwFYK
pSR8tTomOQEvnR6gujcEUrUfl16fZ/UaHR2mnSxrdzgk/hmBLj6w56zQwhHtiPFy
taV7I3R+bvTnUTfjYK63w38mLLPVuNFSH+tvAWyvM8xQFsU3SmBwF8ZdFBC4bafk
zKo8RgKsNzw5KiPoBDmUBP9eERa8wSLBQCMd/oerodEiZUwnrxXbHWOB9o3b7/iE
Ms7xSNFHqfXYHOdV6liT0m7FgCyyIUVpgHe0khdDztJnx35sZJUIaU+AKt6/jY0z
T9oEs0nOL8cWkYSCA2taqni0C5P1kffAVVPvQw4Aticw580ubaE0AemKydb4xCM4
ioTq7q0c2veImw0akJOzNfEkkwfAzbhlHc7dn1hdQqXE/TQVZr5sbm941S0jGZZC
TXJ2q4wUHzAfGkFoCldV7roibdz/f/dRcjYXp72D+O6wVZ68bybCMRlpqxXqG9Aa
+5upKxZMKcx0U8RoSPjCDf7ZWjVV3wpmvhZuAcIaiGOvaN+OZEHcopSYitmrrQXL
MB3YtaSNoRijTw6RRNtzEn39pb082ozlF1cf/FNvBEaQ/x/aJM8p7wJdmaS6ipw+
ApZ1Lgn7okH1EPH0/1iN
=b6os
-----END PGP SIGNATURE-----

--sT0SRK93LqpGW452--
