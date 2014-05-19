Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaESPSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:18:03 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48492 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaESPSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:18:00 -0400
Date: Mon, 19 May 2014 17:15:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] gpio: make of_get_named_gpiod_flags() private
Message-ID: <20140519151543.GA30194@ulmo>
References: <1400306090-4092-1-git-send-email-acourbot@nvidia.com>
 <20140519132822.GA9728@ulmo>
 <CAAVeFu+c1t=QJzL9-pZVaTzvTD2Ydrv__yKHnn+-SA11zsxu_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <CAAVeFu+c1t=QJzL9-pZVaTzvTD2Ydrv__yKHnn+-SA11zsxu_A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2014 at 12:07:40AM +0900, Alexandre Courbot wrote:
> On Mon, May 19, 2014 at 10:28 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Sat, May 17, 2014 at 02:54:50PM +0900, Alexandre Courbot wrote:
> >> of_get_named_gpiod_flags() is visible and directly usable by GPIO
> >> consumers, but it really should not as the gpiod interface relies
> >> on the simpler gpiod_get() to provide properly-configured GPIOs.
> >>
> >> of_get_named_gpiod_flags() is just used internally by gpiolib to
> >> implement gpiod_get(), and by the old of_get_named_gpio_flags()
> >> function, therefore it makes sense to make it gpiolib-private.
> >>
> >> As a side-effect, the unused (and unneeded) of_get_gpiod_flags()
> >> inline function is also removed, and of_get_named_gpio_flags() is moved
> >> from a static inline function to a regular one in gpiolib-of.c
> >>
> >> This results in all references to gpiod_* functions in of_gpio.h being
> >> gone, which is the way it should be since this file is part of the old
> >> integer GPIO interface.
> >>
> >> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> >> ---
> >> Changes since v1:
> >> - Fixed compilation error when CONFIG_OF_GPIO is not defined
> >> - Fixed warning due to of_gpio_flags enum not being declared
> >>   in private gpiolib.h header
> >>
> >>  drivers/gpio/gpiolib-of.c | 14 ++++++++++++++
> >>  drivers/gpio/gpiolib.h    |  5 +++++
> >>  include/linux/of_gpio.h   | 35 +++--------------------------------
> >>  3 files changed, 22 insertions(+), 32 deletions(-)
> >
> > There are cases where GPIOs need to be obtained from device tree nodes
> > without a corresponding struct device. Do you have any ideas on how to
> > support such use-cases?
> >
> > There's currently no API to do that except of_get_named_gpio_flags().
> > But that doesn't handled flags automatically in a way that gpiod_get()
> > does.
>=20
> Yeah, there is probably some legacy stuff that will need a few more
> functions to be handled using gpiod.
>=20
> As much as possible I'd like to avoid provider-specific functions, but
> in the worst case we can imagine making another function available for
> that:
>=20
> struct gpio_desc *of_gpiod_get_index(struct device_node *np, const
> char *con_id, unsigned int idx);
>=20
> that will handle flags properly and everything. Would that do the trick?

Yes, I think it would. Perhaps with a of_gpiod_get() wrapper that sets
idx =3D 0. I'm aware of patches in the works that will require this, but
until they're posted I don't think we'll need this. We can revisit at
that time. Just wanted to mention this as a heads-up.

Thierry

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTeiAfAAoJEN0jrNd/PrOh0F4QAINiAnZFFGcDwYtJN2akUgPJ
6eCsyZiEICk1n9a4ZDLuNRKTBa6oPhYXaTM4ZiJ1pvR+kp3YR4Xg/13UnM6hZnme
MoIjSuq6r7LpAf672CaVI+mSJuZtfCec9onWrSBLy7fh/NnxeJg+E32KKvU/a1cz
o3cxxFZwKBwHoaz+iTEIOmQOOrWoxruodEQTP8J27Uaz1CLMSUlKwV1/oMrZaIzF
IXLKWw9vPNURST00Z5Y3FmCI+NQwS+3WoPu1R5eiqSfLlkRoPsjB4ZaqnYU4woaY
59qTF0ZHcpCG3zRqwF3p/t/6KknV2NPYBV3Sa6k8npX0z5j94SpkxeR0wuYWNn+q
w0KxsqrtKvDzJhpYQE9oZM25s2hjoget62hBMb6KmRHLa6EPOvkALsGWRkStIxIa
0uYL9BYKO6YdcTxbsMJDHnievQb5fJ0dqiBb5lnydzRCPnVAt4w0R9S2khxY3krz
uNr8ED4k2me18RWufRfRm6ckirMrDmpDCWBWEz3Uq3nK6b7xgteX7rI0Zj9DUU0q
xObhLyeUXMdI1fqddLXFi7P7FMd5W0hL6UL+G7dGCpgoYcxm9N+LdNjOCNV7ZY43
B4/vK0qK3jYlR7WT2twhojE54/7jxV1Qwbvfj8n6XBlsgzQTZ17zsf09cnjzYREK
UhZURKcIET3a9GSCEXAh
=wcZK
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
