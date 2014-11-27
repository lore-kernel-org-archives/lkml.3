Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaK0Qoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:44:34 -0500
Received: from sauhun.de ([89.238.76.85]:52440 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbaK0Qod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:44:33 -0500
Date: Thu, 27 Nov 2014 17:45:36 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Xudong Chen <xudong.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, srv_heupstream@mediatek.com,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 0/2] ARM: mediatek: Add driver for Mediatek I2C
 controller
Message-ID: <20141127164536.GC5667@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
 <20141124121555.GG3733@katana>
 <1417096856.12707.59.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WfZ7S8PLGjBY9Voh"
Content-Disposition: inline
In-Reply-To: <1417096856.12707.59.camel@mtksdaap41>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WfZ7S8PLGjBY9Voh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > I think there are now 3 drivers in my queue which are not fully I2C
> > compatible but more supporting the very minimum to, say, read an eeprom.
> > I am not feeling well to allow them to use I2C_FUNC_I2C. So, I want to
> > think about ways how to communicate deficiencies like "only 255 byte" or
> > "only WRRD messages" to users of that I2C controller. This is most
> > likely not happening before 3.19. But assistance is very welcome.
>=20
> Let's us know what we could help :)

I'll put you on CC once I have a draft. Then review, test, comment. That
would help, thanks!

> > I don't like this idea. If somebody wants to send 1 message with 600
> > bytes and we can't do this, we should simply say so. Sending 3 messages
> > is not the same.
>=20
> Agreed. I think this should only happen when we know the device can
> support that.
> However, from our experience, many i2c devices do support it. Do you
> think it is OK to add a flag in i2c_msg(eg, I2C_M_ALLOW_SPLIT) and only
> do message split when this flag is on?

I think we only should report the error and the calling i2c client
driver should decide what to do. It will have better knowledge on how to
split the message and do this on its own.

> > What about Sascha's idea of using a pinctrl driver?
>=20
> We are working on mt6397 pmic pinctrl driver. It depends on mt8135
> pinctrl driver [1] and pmic pwrap driver [2]. There are some discussion
> about pinctrl bindings, we'll send pmic pinctrl driver when that is
> settled.
>=20
> Just to make it clear, the pinctrl driver only handle pin mux, we still
> need to set mediatek,have-pmic to send i2c data through pmic.

I have to admit that I don't know this level of detail yet. I might see
Sascha tomorrow, maybe we'll have a chance to talk about it.

Thanks,

   Wolfram


--WfZ7S8PLGjBY9Voh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUd1UwAAoJEBQN5MwUoCm2heQP/jrXU87JRtF+uqJHGRGtv89S
0uUIAt3/kBCk4+vcNmNhPozehLHP9bVkrNV5BsrAcAVpBUNh5I8x/+Ti8nhPq6Wk
vXauIMiv9nP0JfNH1uM43/URb0yva6GnqbweWHMqUw4EguBEoiHrjIIbYsuv3NWa
vYLLpYGz6mqSKd8t+z2YYgs9fTScipyadhKvdRETm+gSgDaTrqlxpOLP+s8FZSnW
HoynvPBKb2M/pdu2qvHSi91At6WsS0XCOhneg+CaGMDwXiGCFCBlKBeXvqhsiG42
1HNGEx3HGPvX7AUX6hOytsNXKTaIqZzoPPo+kHvoj/pT0UGR55bZqyfYn5NRSfCe
OOqFi4Ah+1DbxldWmoTIfip2z28vVhbUdfcvVMte+ZshyuFbvrW9W9Aoq8q6TmuC
49p4KMdXvfMC+w+xKgp8d1h7LaSHfewbttwQ1MCjjjmjYackt5PXdw90G/1KwX9q
4cbPoYK5KoY7JMkJtYinuegUQlbwpJVT8dN2ydfRlb28G2Gl54REk4RdhXX7dd6W
uHeGpHNHkv5q28lOuD/zudvjZHxy7c6tX7gSFxQ4vG7mxkK0CLtda+YleKTOyaLA
PHsFwwo/u1ZCa8RxLY/cxbr8nuKyPDkqbNHGvpMuPt35+SynPeEqQ1NTndIRAZp8
1aKbEl+ohe1I6FH7eClq
=PnrJ
-----END PGP SIGNATURE-----

--WfZ7S8PLGjBY9Voh--
