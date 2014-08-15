Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaHOJ4S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 05:56:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36515 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaHOJ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 05:56:16 -0400
Date: Fri, 15 Aug 2014 10:55:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Tim Kryger <tim.kryger@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Chris Ball <chris@printf.net>, Seungwon Jeon <tgih.jun@samsung.com>,
        Haijun Zhang <Haijun.Zhang@freescale.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140815095528.GH17528@sirena.org.uk>
References: <1408019940-11153-1-git-send-email-javier.martinez@collabora.co.uk>
 <CAD7vxxKvzxvmzgx=S5ZZn54ts99ca2TqBYFvY1SXZQZDkhjq3w@mail.gmail.com>
 <20140814151958.GY17528@sirena.org.uk>
 <CAD7vxxLHtk2ywHGoBtDp6x3-5BtDdaFnCdc_pfgMwq63Cg8Qow@mail.gmail.com>
 <53EDBB5B.4000209@collabora.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q4thQ4L2MN5Si/2d"
Content-Disposition: inline
In-Reply-To: <53EDBB5B.4000209@collabora.co.uk>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] mmc: core: Use regulator_get_voltage() if OCR mask
 is empty.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q4thQ4L2MN5Si/2d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 15, 2014 at 09:48:43AM +0200, Javier Martinez Canillas wrote:

> But now I wonder why regulator_list_voltage() even list the voltage for
> fixed regulators (desc->fixed_uV) since they don't have the ability to
> vary voltage. The regulator_list_voltage() documentation says:

That's because it's very cheap to do and there is a comprehensible thing
we can return - if we have to read the voltage that means potentially
asking the hardware in an I2C transaction which is not cheap.

> > It seems odd to make callers be the ones to handle this subtlety.

> If regulator_list_voltage() didn't list the voltage for fixed regulators,
> then this subtlety should had been handled by callers before but they
> didn't because they rely on regulator_list_voltage() to always return a
> voltage even for fixed regulators.

There's plenty of potentially variable regulators used in these
situations, I expect it's more likely that people were just ignoring the
warning since it has no practical effect.

--Q4thQ4L2MN5Si/2d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7dkNAAoJELSic+t+oim9+HAP/1M2/DpYFr89DkGoXpLukKh6
HhfpOuQypBMLQ77KOKe8KKZuMFHM13pO4DmsMQk5dl0NnxRYUFjxGsONk9o2KtUo
yvETMeZHgXMGmNPt10JBOmHuvtD63qdRdYu4gzVge21Xj5yl1DjoGGh8afSfspRD
ZPN8a/yYS9Iu22UzV2tjjocW5At1NZhsB/KkvWoYAP1L5dGRSS97RgOJE8AKGAdl
fympmzFn43NKXDK63Ui9pc58guBmNv9I2MHI2LgSg0nkmDO28NJvAHC+m3MmEeD5
K1pEcgWXktlifEu6a2OtSMcPGyA0olge0lTkhpb6iOOPqtgKYB8GBjfigRPNfSbk
sTcfae50foPGXoI10PYDAbVI9lEpgmik0FM9xvdfZBbgZoFNCyJMFuiufABqtKic
cSTLS8mwU9YFRENAuPTib8vEfVHvmjC42Eueb2v1/uRrSv91RqlGzmfjo1kFCzzr
VvtQqrnwWBu7W7UhoUeQ6v/inMtvPVGBYWlKzxlQaBU5bJKH6BBte/JPiZH/1FYb
7EwQjAu5lyZTUK2bnjDiCDGBmZliuTkhS6r/Ixabhzjb5Yo8jcXF4EChWJZRpFRJ
gZbUwJ7HXIEKx459/IdUAdhaVM5RV9nx63CZbdwrMs6ZZrE5tgSGJ8ZY9Vo0kjhR
L7E2p7n1whKZMq3WstSA
=1Rvw
-----END PGP SIGNATURE-----

--Q4thQ4L2MN5Si/2d--
