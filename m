Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbaHSHKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:10:18 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48740 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbaHSHKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:10:16 -0400
Date: Tue, 19 Aug 2014 09:10:12 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: rockchip: rk3288: Switch to use the proper PWM
 IP
Message-ID: <20140819071011.GC12859@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <1408381749-14156-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Content-Disposition: inline
In-Reply-To: <1408381749-14156-2-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 10:09:06AM -0700, Doug Anderson wrote:
> The rk3288 SoC has an option to switch all of the PWMs in the system
> between the old IP block and the new IP block.  The new IP block is
> working and tested and the suggested PWM to use, so setup the SoC to
> use it and then we can pretend that the other IP block doesn't exist.
>=20
> This code could go lots of other places, but we've put it here.  Why?
> - Pushing it to the bootloader just makes the code harder to update in
>   the field.  If we later find a bug in the new IP block and want to
>   change our mind about what to use we want it to be easy to update.
> - Putting this code in the driver for IP block is a lot of extra work,
>   device tree bindings, etc.  Now that the new IP block is validated
>   it's likely no future SoCs will need this code.  Why pollute the PWM
>   driver with this?  This is an rk3288 thing so it should be in rk3288
>   code.
> - There's a single bit that switches over PWMs, which makes it extra
>   hard to put this under the PWM device tree nodes.
>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/mach-rockchip/rockchip.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>=20
> diff --git a/arch/arm/mach-rockchip/rockchip.c b/arch/arm/mach-rockchip/r=
ockchip.c
> index 8ab9e0e..99133b9 100644
> --- a/arch/arm/mach-rockchip/rockchip.c
> +++ b/arch/arm/mach-rockchip/rockchip.c
> @@ -24,6 +24,24 @@
>  #include <asm/hardware/cache-l2x0.h>
>  #include "core.h"
> =20
> +static void __init rk3288_init_machine(void)
> +{
> +	void *grf =3D ioremap(0xff770000, 0x10000);

This region of memory is part of the "grf" "syscon" device (according to
arch/arm/boot/dts/rk3288.dtsi) so the register should be accessed from
that driver. It looks as if no such driver currently exists, but given
the existence of the device tree node it's fair to assume that one will
eventually be merged.

Thierry

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8vhTAAoJEN0jrNd/PrOhVxMP/1Y8bEB9Ih9ontEKFOmoQWyM
YeAywJL2zbh4qQ+gGomC1OR5eygK6rtR/ODbiztk3ws5ABePTNl5e/QqZoFpM10j
N+SZ9qHCtpqmiLiVU4X3dNmG/P/PGvrx1KPtr5jdjSEuoVobowNh8r9jqylC+Qqp
UwyiESsnydLg4S7fjRTE6Ga3X9QshxNI3LoVgKX8IEOEkpqFj6vqdQTtq+zME9D5
/Q4zR8z/sk5q3OfIdQVzk9eWQFMzgQ9LzjRnKZdlGu7dZ2qNb8XwBv4KgvJq5oSP
AfEHzHoqGBnONNm8dlQ9YaRx/bbDkIgfysMde7FEthdxPfbI6y3yYzngdj6fuPZP
eazNk943mnrA5dczwwL/it0I1sz9ehREmpa+7hKV/rKWvHjHD/6UKAEgrTWPXE5B
YDJBv0dJJjeH95OD3Mp/dNEwAbKiC0ET4m3k+1uMiBi5X8Dbyfi2YNmWQ7f8JzMk
3s3mIrxEiVX8zS/bg/iNGBR126jUvjHZy9CNeRt5f/R3HGIb+wtI4uyCD5x640uc
0QlKiygqjgZNAc/drTXRG5nXTcozSMuh6WI//pnLHvW2VWY/Tj0ZuVPHkrOWamC0
NJBYLBn/8JfAl9cQCBBrmUTB6jTUFWkBl9R25tspsXYr4fNYyrO3vEeATx+8N1cd
H2U6TC8p6+5vEJnix7HD
=kbJI
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
