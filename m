Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaJ1Wcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:32:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54012 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaJ1Wcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:32:45 -0400
Date: Tue, 28 Oct 2014 22:31:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Message-ID: <20141028223121.GH18557@sirena.org.uk>
References: <1414411911-5539-1-git-send-email-k.kozlowski@samsung.com>
 <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="waAWgznbqtWOzvJZ"
Content-Disposition: inline
In-Reply-To: <1414411911-5539-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 3/4] regulator: max77686: Add suspend disable for some
 LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--waAWgznbqtWOzvJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 27, 2014 at 01:11:49PM +0100, Krzysztof Kozlowski wrote:

> @@ -247,6 +250,8 @@ static struct regulator_ops max77686_ldo_ops = {
>  	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
>  	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
>  	.set_suspend_mode	= max77686_ldo_set_suspend_mode,
> +	.set_suspend_disable	= max77686_set_suspend_disable,
> +	.set_suspend_enable	= max77686_enable,

This looks wrong, you're using the regular enable operation as suspend
enable.  How does that work without disrupting the current runtime
state?

--waAWgznbqtWOzvJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUBk4AAoJECTWi3JdVIfQSJYH/RTYhHzyf/43tuvH9ge6Zqhr
8D17nEvNtEt6aaRrQ27Xn4eWcghsnCGIHVfm7T5zQRxQZTaK2p6eiHYnO51N86cg
orx2lmaIhvQvnW2aTFJFMlcc17buBmyT7sNBOUuZA6kHN1eu/IzJL2f62+aspp79
6gnfejrhgvDNkdCRYpLSJDuBWQCJTVTs/IzBHAfDw+yNvk5PsbKwrU9sXSx2/1+p
y6q7IWnqDTH6OW/5FSx8pIKQMiY6jLbaZZCl8X/aGk+5UFwo9Qr27q15DkhtGKwI
FMcatv+CZTtkCn+bG/V9pRbqu2KaY+osBsLP4TTfdXVkTlaTuoW7aGyLYoQj/vk=
=zgZa
-----END PGP SIGNATURE-----

--waAWgznbqtWOzvJZ--
