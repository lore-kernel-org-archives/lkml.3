Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbaJaSMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:12:41 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59607 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaJaSMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:12:39 -0400
Date: Fri, 31 Oct 2014 18:11:55 +0000
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20141031181155.GP18557@sirena.org.uk>
References: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
 <1413938456-30468-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pdpX56ILVjuiN9xp"
Content-Disposition: inline
In-Reply-To: <1413938456-30468-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rockchip-i2s: add rockchip-max98090 driver support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pdpX56ILVjuiN9xp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 22, 2014 at 08:40:56AM +0800, Jianqun wrote:

>  config SND_SOC_ROCKCHIP_I2S
>  	tristate
> +	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
> +	help
> +	  Say Y or M if you want to add support for I2S driver for Rockchip
> +	  I2S device.

You need to make this directlyuser selectable by adding some text after
the tristate as well as the rest.

> +config SND_SOC_MAX98090
> +	tristate "ASoC support max98090 device driver"
> +	depends on I2C && GPIOLIB
> +	select SND_SOC_ROCKCHIP_I2S
> +	help
> +	  Say Y or M here if you want to add support for Rockchio board using
> +	  a max98090 codec.

This needs to modify the existing MAX98090 entry, not duplicate it
(probably as a separate patch).

--pdpX56ILVjuiN9xp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUU9DqAAoJECTWi3JdVIfQDaMH/i5bLPe7iX4cIXne6JxkkUCB
ZpT4JH2jh4N2odPUxZo6gK2MxlEr7joctP1MyUgI2Z+Qpsk55hDyHPl8pWpLYMdK
MIHVRyCJKRvTBEd9z8FWQXB/mWeeo6qFkGRZXCSe8ZjdWKa9P39k73YnK6RhgasI
28w3+YiSZoQflFk+6fPI4+2qqLqrrFmFyUr6J5eb1jcTekhpuRnKGETQdHL+1Unf
bkfj8cdWlnlDIj8wJZS2tNTQ+ZBvDxtjXWTHXVvn3hatA5A39m1iD0ZT+sPRxukD
p8ReBmiBKcHBFZkM8WZdJfR83AwR5Zlb6Ww+LHGzAqdzKdic9ZAWx1FiQyI/wyk=
=hH8d
-----END PGP SIGNATURE-----

--pdpX56ILVjuiN9xp--
