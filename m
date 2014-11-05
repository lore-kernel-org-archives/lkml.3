Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaKEKLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:11:05 -0500
Received: from down.free-electrons.com ([37.187.137.238]:40485 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753440AbaKEKLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:11:01 -0500
Date: Wed, 5 Nov 2014 11:09:12 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Hans de Goede <hdegoede@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 1/6] clk: sunxi: Add support for sun9i a80 usb clocks and
 resets
Message-ID: <20141105100912.GD27686@lukather>
References: <1415074039-16590-1-git-send-email-wens@csie.org>
 <1415074039-16590-2-git-send-email-wens@csie.org>
 <20141104165733.GI26729@lukather>
 <CAGb2v65VojZVEijdjXYGkMud7dMFzMzagfN=_4S3msZygu3YPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <CAGb2v65VojZVEijdjXYGkMud7dMFzMzagfN=_4S3msZygu3YPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 06:02:35PM +0800, Chen-Yu Tsai wrote:
> >> +static void __init sunxi_usb_clk_setup(struct device_node *node,
> >> +                                    const struct usb_clk_data *data,
> >> +                                    spinlock_t *lock)
> >> +{
> >> +     struct clk_onecell_data *clk_data;
> >> +     struct usb_reset_data *reset_data;
> >> +     const char *clk_parent;
> >> +     const char *clk_name;
> >> +     void __iomem *reg;
> >> +     int qty;
> >> +     int i =3D 0;
> >> +     int j =3D 0;
> >> +
> >> +     reg =3D of_iomap(node, 0);
> >
> > of_io_request_and_map?
>=20
> OK. About that, any recommended naming style for the 3rd argument?
> Maybe the driver name "clk_sun9i_usb"? Or just a generic name like
> "usb_clk"?
>=20
> I'm asking now as we'll likely be changing the existing drivers to
> use it as well.

I don't really have a preference. Maybe the DT node name would be both
the easier and better solution.

[...]

> >> +static void __init sun9i_a80_usb_mod_setup(struct device_node *node)
> >> +{
> >> +     /* AHB1 gate must be enabled to access registers */
> >> +     struct clk *ahb =3D of_clk_get(node, 0);
> >> +
> >> +     WARN_ON(IS_ERR(ahb));
> >> +     clk_prepare_enable(ahb);
> >
> > Hmmmm. That look off.
> >
> > Why do you need the clock to be enabled all the time? Isn't the CCF
> > already taking care of enabling the parent clock whenever it needs to
> > access any register?
>=20
> There are also resets in the same block. That and I couldn't get it
> working without enabling the clock beforehand.

Ah, right.

What happens if you just enable and disable the clocks in the
reset_assert and reset_deassert right before and after accessing the
registers?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWfdIAAoJEBx+YmzsjxAgzTIP/RQ7y4IvEdYV6broUWRmAzko
oQl3bA+I3kMLWYo6HOg8tzcH+PEJtGHpDzKLTAlQRjieCjmZPEAlPVjxhGN2uCdq
ai6gf7fP9t0kloyDtw4a7hpkQmQQstClVLMMBxxgeHyzsSnPkhoY3Kjw8PcpeN3m
N/XAA8VIEESphW1Y8y23+vCjFs3kOuqR6d7b1HxJgrCHVCV+4x8Y96HD8NYVK0zC
w+HAyKNclMZXhfXVZbkC0wYNbdgdxWyOUK43JooUmggPsQdGD1wyrwS5e6vQMijk
9tHjO6lYkNjTAEmu0KCO6j+bBWlfBGk6IDyTeZ9/7N1pF6pBekgKMghXoEPiUrXf
Re99KkNdB2y0fXeHjudWVVIIgj2sBrtKs70I6Ew0QjJ4ysjdsMPnyxpk/sU1Ww7u
WwvZzMgzE4FGnpKltqGz7G37RNetCdyhuKlEGeNyDtuyuiYrPzQjx5HOhzxyp6sm
/4wKsKrdkPrgKP9rhOtwVJt+ksTlpHFvHt6761Y5nH6aA+usPnBWA7SZaMfwG3Tz
/jJ8UlqCezlof+CcyRktAyPPxYqvOfRfs3PIA4vt0/d1L7GhkGssXZacAyL9psI7
6tohTfeUk20yCwkusaWKRDfFjpSepQNrD7msPSlHM4Qbhr1u0UrGFDlxqZ8U5N5x
P/r7SsOCqap9CKjGvANT
=vLBd
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
