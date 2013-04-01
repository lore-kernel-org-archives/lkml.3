Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3DANig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:38:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40615 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595Ab3DANif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:38:35 -0400
Date: Mon, 1 Apr 2013 14:38:33 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 01/14] spi/spi-atmel: detect the capabilities of SPI
 core by reading the VERSION register.
Message-ID: <20130401133833.GT18636@opensource.wolfsonmicro.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363678935-3665-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mW9eGbZzDIYYWqGs"
Content-Disposition: inline
In-Reply-To: <1363678935-3665-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mW9eGbZzDIYYWqGs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 19, 2013 at 03:42:15PM +0800, Wenyou Yang wrote:

> +{
> +	unsigned int version;
> +
> +	version = atmel_get_version(as);
> +	dev_info(&as->pdev->dev, "version: 0x%x\n", version);
> +
> +	as->caps.is_spi2 = (version > 0x121) ? true : false;
> +	as->caps.has_wdrbt = (version >= 0x210) ? true : false;
> +	as->caps.has_dma_support = (version >= 0x212) ? true : false;
> +}
> +

There's absolutely no need for the ternery operators here - your
comparisons are already boolean, the ternery operators just add noise.

I've applied this with the above edited to remove the ? true : false,
thanks.

--mW9eGbZzDIYYWqGs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWY3TAAoJELSic+t+oim9zckP/0NPmWTAFZkIiUCtpeohlzDL
HsQ5R+toEBYcocYj12/CQsIC+0tT9AlOFx7K82kdlTImM1Y5cOeUhSqoUf9pm3hB
VmF0kSPg/Pk+vRXRM/c3uFM4iKeCWFDiUUbxRwcMUwqd5SmIA1C/Rk2w0+69vk/k
LMaYjHZecBilNG6pxs1fWF8BUi27+t7/W18QVJ+MT7ZRzncHSfmsTOutaYtYVRbM
/UX7tzBrqSRuhgC5mAuF5ty5flb02vI6Wu5AiRS/Q2RUzna1qVncaxCpfQCrJu7Z
GOLXijsrTltVBLGNOTOrVeZhO+tq7YLcyMhkoE/AszWMNATeU1hUFMKkRu4G3wcJ
HB7sWZPB30XLb+Ky9izZJqtaNyVm08fJZKtUyJrJQzzgcvn5ls62CpUsKzh9wGBm
848SFy8Li9pySa0aGuGPhZItaMf64UZh2jtpXSaSCZ3qEPMTqmnakAqJ2aNJf7RQ
Yo8KRqt3/tp1vOlXFRtJX8AQ+n8UDT4x1iuAtzGGbXBxNLQhr4lNNUw0PB6QjZ+N
veLmc9C7lh3xaRX2UTwJ8qphahabWixCeP1UYeC9jvjTGoOCGOnSrDTyKJ6+GECL
mZmKBO020rsh6EGLZ8Z2k1zc53qIYRslwZEbgtsEveTd9Nsz26BK83ksebVsnscz
J7KGYVbmQqYzVZ0zzTOA
=JZxf
-----END PGP SIGNATURE-----

--mW9eGbZzDIYYWqGs--
