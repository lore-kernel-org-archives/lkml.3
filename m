Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaKQSK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:10:58 -0500
Received: from sauhun.de ([89.238.76.85]:37525 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaKQSK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:10:56 -0500
Date: Mon, 17 Nov 2014 19:12:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] i2c: core: Fix probing of i2c slaves without interrupts
Message-ID: <20141117181214.GB12644@katana>
References: <1416224580-4782-1-git-send-email-geert+renesas@glider.be>
 <CAOMZO5BsfCfP+bMfYWZ9C=Sp0sWkEr6WoRRygw18EfW2T_k3oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <CAOMZO5BsfCfP+bMfYWZ9C=Sp0sWkEr6WoRRygw18EfW2T_k3oQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 03:08:25PM -0200, Fabio Estevam wrote:
> On Mon, Nov 17, 2014 at 9:43 AM, Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > Since commit 2fd36c55264926e2 ("i2c: core: Map OF IRQ at probe time"),
> > i2c slaves without interrupts (e.g. da9210 and at24 on r8a7791/koelsch)
> > fail to probe:
> >
> >     at24: probe of 2-0050 failed with error -22
> >
> >     da9210: probe of 6-0068 failed with error -22
> >
> > This happens because the call to of_irq_get() in i2c_device_probe()
> > returns -EINVAL.
> >
> > If a device node does not have an "interrupts" property,
> > of_irq_parse_one() fails. Unlike irq_of_parse_and_map(), of_irq_get()
> > does not ignore errors from of_irq_parse_one(), but forwards them.
> >
> > Make i2c_device_probe() ignore all errors but -EPROBE_DEFER to fix this,
> > just like platform_get_irq() and platform_get_irq_byname() already do.
> >
> > Fixes: 2fd36c55264926e2 ("i2c: core: Map OF IRQ at probe time")
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>=20
> With this patch applied my codec and PMIC can be probed again:
>=20
> Tested-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied to for-next, thanks!


--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUajp+AAoJEBQN5MwUoCm2GuQQAKeOuIgtjnK/BRm4YuKvF1ks
Zim3GnThYz3T3aKYqp7GeOT0kG3FRR/1GkvPTh7nLJsNBZemmCW4pde8FGlWK0RW
GaqGmNNVHdrhfNYbJceI2ikwMTjPmz+ACXZOOgFhfrMdALJ8KRRJI7Xom4n5w4nU
yjhZ2Yg71qmrVFz/Ov/EeHGKEbi7bpgSnZYqUnu6sVfWikxO6JshKIVqQ3jxD/+j
N3G3KlSiHCA2wh980VkKFO06MvxunD00e8GZGMVnCWsoYWF/pSzzCaZnHtlHBDIV
4gdNPmUM6qyK9ZoIj2H5e7/enT6B1EaTKm4AvupzSa7O4XD4rAwo3mFs2TSbpZBY
2YZ6M8uDYYi76K6ArOZOCVueilz4QO8VZIJoxashODwI2rZEtrGrwBIJYwDMwoJ4
qHbqtB4g8jA0lGKnK/F5IZ8n5yH9+1KYEBZxxK942jAN9y2hBx/9SQ5he9W9mkph
fBFxsrW1CHzJi0n6RtjEn/XFmW33R1Jd0yfLt8n4iT0rkpCJEjaaPe2+uBSiKCHY
eHpoj4OeVDJzFmP3sGri/0JLhJboDLcVJB9vkGOfPMw6REDYiRtL4uvtdTsjO8e6
+TJM8vB4T/6Q4LjcCdkEdDo9TryGCHi610TvLPR1xtZOKxb+1q4a4XfIjlvc1ZeZ
ZX5hUXoFIQG4rVdAZcRb
=RFFv
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
