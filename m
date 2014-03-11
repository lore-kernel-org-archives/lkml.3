Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbaCKKrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:47:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60687 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbaCKKrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:47:19 -0400
Date: Tue, 11 Mar 2014 10:47:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140311104713.GN28112@sirena.org.uk>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
 <1394531952-3905-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yz2cksEFSLwGxgnH"
Content-Disposition: inline
In-Reply-To: <1394531952-3905-3-git-send-email-geert@linux-m68k.org>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: rspi: Add runtime PM support, using spi core
 auto_runtime_pm
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yz2cksEFSLwGxgnH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 10:59:12AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Applied, thanks, though...

> -	ret = clk_prepare_enable(rspi->clk);
> -	if (ret < 0) {
> -		dev_err(&pdev->dev, "unable to prepare/enable clock\n");
> -		goto error1;
> -	}
> +	pm_runtime_enable(&pdev->dev);

...due to the runtime PM API being configurable you're supposed to start
off with the device runtime enabled (this applies to some of the other
patches too).  I'm not sure that's terribly realistic for these drivers
though.

--yz2cksEFSLwGxgnH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHumuAAoJELSic+t+oim9blYQAJMQLchaOBTQkKwCXy/KFVw4
TVk28TcfSv3FZVKK6d9VwaW0onVIP13895pToQLgJ7aKYn2/j5RZyNFuAde7sMY0
1n4aIqte6e/MnXZUSw+dLZbw41q2ZnYbY42fHHNeOjjTMzy3dUydwRXe4uXTDicK
U8p3fRoD5mt3DaH15WMn/WZqo1yqnerICFDhXNMsr31pNTY2+cUyT2TXmV/WDOrz
coKBk8BbB6tY51rca2DlQPW5/xezdVRTRuBdkpNkltovXqnQR/L8rXkiT/Q/I2pU
Ql2HZTZReMpjyUUw6vdq17SJsgtlQRfBgAFA1Y3B7HlRQzr9ARxQuz+MXZcnHaXV
b81c7adkmSJ5P49SN9XQ5rtzoi4ai0k0A5ghF5fGe94V1ky5IiWF9jOOFu3Cj9hl
q0mBdfb2r4FiPrWcXeKhw5blpAzz+1IzejYcXx312YVIT3KicfIjl71G7GTwa1P8
mOw42wLauP6LeOv6Ly5weIapa5FkT26awhdoM4rbR/EX9kqbk/m42yPC42aSZfaj
mLPbeo8349bK8X0fmp7eV5rLYQn2GjaYHSa1AQySybn1qFj92H6wbwg2ekEw0uQG
1DTZxgDxBYL9adIV8J1nQcoRxFMlPtWO4VrOyzVUvsyvyzD4avUYRdGwhQxIxRuI
czIWmTdQGjTTosB0UxDa
=AeiQ
-----END PGP SIGNATURE-----

--yz2cksEFSLwGxgnH--
