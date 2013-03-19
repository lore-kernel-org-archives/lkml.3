Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3CSOrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:47:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34285 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab3CSOrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:47:12 -0400
Date: Tue, 19 Mar 2013 16:46:49 +0200
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <manjunath.goudar@linaro.org>
Subject: Re: USB: simplify clock lookup for mv ehci/otg/udc
Message-ID: <20130319144649.GA21922@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <2174936.bGhG5fu0iO@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
In-Reply-To: <2174936.bGhG5fu0iO@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 19, 2013 at 02:44:46PM +0100, Arnd Bergmann wrote:
> While going over the suggested changes for the ehci-mv separation patch,
> we noticed that the driver uses a variable number of clock names it gets
> passed from the platform code, which is highly unusual behavior and adds
> a lot of extra complexity.
>=20
> Even though there is a comment in the mv_udc driver stating that some SoCs
> require multiple clocks, none of the code in the upstream kernel provides
> more than one, and even if an out of tree SoC port needs multiple clocks,
> it is still wrong to pass them them through platform data, since they are
> a property of the device, not a property of the platform.
>=20
> This patch attempts to clean up the situation by turning the one clock
> that is passed into the ehci/udc/otg devices into an anomymous one and
> removing the clkname array from the platform data. Another simplification
> is to always call clk_prepare_enable/clk_disable_unprepare directly,
> since that is a valid operation on a NULL clk pointer if the platform
> has not attacked a clk to the device.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

needs to be rebased on my -next branch. Also, it would be really good if
dependencies between drivers and arch code would be cut to a minimum.

--=20
balbi

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRSHpYAAoJEIaOsuA1yqREVjIQAIxk8piafrXnuS2zb2EWeKUi
61vNePsKMP0RvhGp8hvNgIc4cjA0keJwC9EfHT7asxYcUGVJsrmtEVF1+bW5AUu5
ytmPqFTGRKDJelhFcC7iwWqQBEg9PESeuU1esnItxZvTbtqsgkg4cALvo94sC8ti
FaIL39FP1pbSh3bG8Wp028SXmHl1Wjcwsxl2lk2aHXMUv4VdW7G989idH15JqRCe
d9iq3FmtUVe2Jmdv5tSyJvbhgcRGsMCdFQ11vhg5wSYH7sbiInONUY9K9aPQgm38
C87C3ibhuF44lBEDKzo4lDrKsuHhlHjpNckjBr7Jef40Zz0bAJQJwEJqiiu8JESv
Nx9YruNO3tHZYVQp2SMY6bdvcklFAZcJnbck1lgkAVQGnSSscD294eR0WmndeWw5
Xe94cTAquQoL6Cx66BbYHA4KKYeUN4mAZ50+OoHAGMovM0+ZBghMvu4088AzPyN5
Xml9rn5IjzwBlAQGYgXhnR6+z/K36BWPv/s++e6YmOG9CfwUBgiSnEIAg8InWPry
8ELRHE5X5Wt/2/mZNEOldeLbIAl3HqOpZb3Xie0RuwhhYP917MpBEbGz6dEBZE6m
Vidxw4Wwwz1ZXnW6uTPArxE66IMe2JJdbmEFjBjEnymfbAZZ94LrTokiBcy3s4xi
PQa4BLKrZCJn0DKHnq/D
=VGoB
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
