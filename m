Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3IQN3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 09:29:52 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:34882 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab3IQN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:29:48 -0400
Date: Tue, 17 Sep 2013 15:28:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/9] of/irq: Introduce of_irq_get()
Message-ID: <20130917132834.GC6757@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-5-git-send-email-treding@nvidia.com>
 <5237771F.1060908@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Content-Disposition: inline
In-Reply-To: <5237771F.1060908@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2013 at 04:24:47PM -0500, Rob Herring wrote:
> On 09/16/2013 03:32 AM, Thierry Reding wrote:
> > This is a version of irq_of_parse_and_map() that propagates the precise
> > error code instead of returning 0 for all errors. It will be used in
> > subsequent patches to allow further propagation of error codes.
> >=20
> > To avoid code duplication, implement irq_of_parse_and_map() as a wrapper
> > around the new of_irq_get().
>=20
> *_get typically also implies some reference counting which I don't
> believe this does. I don't think having 2 functions with completely
> different names doing the same thing with only a different calling
> convention is good either. So I would keep the old name and the names
> aligned.

Okay, I'll make the new function __irq_of_parse_and_map().

> >  unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
> >  {
> > -	struct of_irq oirq;
> > +	unsigned int virq;
> > =20
> > -	if (of_irq_map_one(dev, index, &oirq))
> > +	if (of_irq_get(dev, index, &virq))
> >  		return 0;
> > =20
> > -	return irq_create_of_mapping(oirq.controller, oirq.specifier,
> > -				     oirq.size);
> > +	return virq;
>=20
> This can be an inline and written more concisely:
>=20
> {
> 	unsigned int virq;
> 	return (of_irq_get(dev, index, &virq) < 0) ? 0 : virq;
> }

I find code such as the above very hard to read. But if you insist I can
move the function into include/of/of_irq.h and make it static inline
with the implementation above.

Thierry

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOFkCAAoJEN0jrNd/PrOhkIAP/Anrr5d0VlOE+xZmwhAET+e8
Ctfb3Tm0NJPbKxjX9MvSVNZ3WlhBbbwXVdK7FDaOleDIszL+tefUw2jBb5NVGE7y
ZpeMaq2HWZuTgAd6Tdfz9PEmTosGqZMKecg1+MxGsAnvLHapWLOajUNcBbQOAAtS
qgsllbHzmQ0zS8/wH+c9NbGTC4z7AKruWo49CEuyd95t1l2qzPp4CgQ8ZKnWzROo
I+qP7P3xVSM4nj33IOml+kF60R8vZZYFBQvRGeCbgiLmS3CKqA9e0njuP4dzs2XJ
D2Ii0tjZSDtozeAdavZTF4VnwzjedAsSimuAW3FHrJVGuKPLYFTRcLHV7X9uz+ob
YJSicMfgS0+49tAq/lLhnYP58jX5XlEhzqkGIcPihooVd5NAsREOl9Go6RxYStSP
s4S2IQwcPducd09msXQczPMru0DC+0QczFZ9G79fc+N5FdFEwq9rQkZD/o9J3Xwk
ufo1izoEofAHU5bq8BkSk94r7js01rrAG7KIQQ+QKlm8sDuvWAs+sdK42z7grrHf
up1wp+qUnR31dIiuVhnBj6UVpJth9uQaRFXvdC+VGK2Uutf7qMRyiLu+HzK4FZgJ
23Q5GRiuqLJ9BT13pu6bWANAJmkxXRRv3hAqTmf/HC6KYUsRY+7We0CdzUYCO2F7
AsHkDeGTJa5EvD7zNrFH
=qJ1y
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
