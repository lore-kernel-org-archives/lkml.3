Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3K1Whd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 17:37:33 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:37698 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3K1Wh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 17:37:28 -0500
Date: Thu, 28 Nov 2013 23:37:19 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: r65073@freescale.com, s.hauer@pengutronix.de, swarren@wwwdotorg.org,
        t.figa@samsung.com, grant.likely@linaro.org, linux@arm.linux.org.uk,
        rob@landley.net, ian.campbell@citrix.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131128223719.GG14689@mithrandir>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-2-git-send-email-Li.Xiubo@freescale.com>
 <20131128212510.GC14689@mithrandir>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Content-Disposition: inline
In-Reply-To: <20131128212510.GC14689@mithrandir>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2013 at 10:25:11PM +0100, Thierry Reding wrote:
> On Tue, Nov 12, 2013 at 09:36:55AM +0800, Xiubo Li wrote:
[...]
> > +static int fsl_pwm_parse_clk_ps(struct fsl_pwm_chip *fpc)
> > +{
> > +	int ret;
> > +	struct of_phandle_args clkspec;
> > +	struct device_node *np =3D fpc->chip.dev->of_node;
> > +
> > +	fpc->sys_clk =3D devm_clk_get(fpc->chip.dev, "ftm0");
> > +	if (IS_ERR(fpc->sys_clk)) {
> > +		ret =3D PTR_ERR(fpc->sys_clk);
> > +		dev_err(fpc->chip.dev,
> > +				"failed to get \"ftm0\" clock %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	fpc->counter_clk =3D devm_clk_get(fpc->chip.dev, "ftm0_counter");
> > +	if (IS_ERR(fpc->counter_clk)) {
> > +		ret =3D PTR_ERR(fpc->counter_clk);
> > +		dev_err(fpc->chip.dev,
> > +				"failed to get \"ftm0_counter\" clock %d\n",
> > +				ret);
> > +		return ret;
> > +	}
> > +
> > +	ret =3D of_parse_phandle_with_args(np, "clocks", "#clock-cells", 1,
> > +					&clkspec);
> > +	if (ret)
> > +		return ret;
> > +
> > +	fpc->counter_clk_select =3D clkspec.args[0];
>=20
> This isn't at all pretty. But given that once you have access to a
> struct clk there's no way to identify it, I don't know of a better
> alternative.

Hi Mike,

I've seen this crop up a number of times now, to varying degrees of
gravity. In this particular case, the driver needs to know the type of a
clock because it needs to program this hardware differently depending on
which clock feeds the counter. Since there is no way to obtain any kind
of identifying information from a struct clk, drivers need to rely on
hacks like this and manually reach into the device tree to obtain that
information.

I'm aware of similar cases which have been solved by using a mux clock
that takes a set of parents and the .set_parent() operation is then used
to program registers appropriately. However in all those cases, the mux
clock (and the parents) have all been part of a single driver, so I am
not sure if the same would be applicable here.

Do you have any other suggestions on how this could possibly be solved?

Thierry

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl8WeAAoJEN0jrNd/PrOhHccP/1zloUswCIV3ruMzP1o0ZSak
9ZYULNc3caVlbDGFahaJXBIyorqYBP7Ls980pcuLUaf0aPdqV70PyBcv2CtVt6n5
XV8JW9WZ1vHpLqHOU3cVBC72tkIEdIzQBfNNoC36mX6y8yYWjzvEjAmKfmM2eXph
/0aAoeFg6RTfsqxPpgsDKP9woCLog5V189rVWDW9/ZFt+egoKPk7gTGza9KAkNyg
2ThQ1Dh8M2DCcgJ9iWWEz+Yyo0IA3siIbMwiEA7Y6Y0W92qf7LoaAVZ4sz/2z+ce
ZekWeHDV/+KrwHFSTW1r91/rmO210l7dnUGle2Vu7mDB68SzLtyOEmTkS9BdI2hN
QnvPCiqgGxYjdXwVfh/Rppa/RDDSbaITP99XftMCBPJsrutay4dh21X9Q83BYSnF
4S640xNVy2TVo0MgzixJc3uVw07DQRX7QSIL27m67vrrE4hWGknKcsmEt3uX4qD8
E2ksoIgHg3zwSFelyEfZ2Y6w/7KoZ9i6+kb5y7wLQ/d0VV/6gqc68ed8OT6gm/dU
+1gSpE23GTZNNaKsOaxcvc436SnuGRmPN6pcxdhRacS740pbjEM0juvKjioyMScE
Sna51Tr9YHfk/4otjIFiNP/HAOskWsepUrqBPBQNf7CNgvaHMrZ4Yd1w6NRLQxc2
PlztS056LdO2/WeUtAGO
=Xjht
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
