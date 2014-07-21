Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaGUVzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:55:31 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:39588 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaGUVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:55:29 -0400
Date: Mon, 21 Jul 2014 23:55:25 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/6] clk: tegra: make tegra_clocks_apply_init_table
 arch_initcall
Message-ID: <20140721215523.GE12076@mithrandir>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-3-git-send-email-pdeschrijver@nvidia.com>
 <20140716071932.GB7978@ulmo>
 <20140716082740.GK23218@tbergstrom-lnx.Nvidia.com>
 <53CD896C.3030605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5oH/S/bF6lOfqCQb"
Content-Disposition: inline
In-Reply-To: <53CD896C.3030605@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5oH/S/bF6lOfqCQb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2014 at 03:43:08PM -0600, Stephen Warren wrote:
> On 07/16/2014 02:27 AM, Peter De Schrijver wrote:
> > On Wed, Jul 16, 2014 at 09:19:33AM +0200, Thierry Reding wrote:
> >> * PGP Signed by an unknown key
> >>
> >> On Tue, Jul 15, 2014 at 06:24:32PM +0300, Peter De Schrijver wrote:
> >> [...]
> >>> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> >>> index d081732..65cde4e 100644
> >>> --- a/drivers/clk/tegra/clk.c
> >>> +++ b/drivers/clk/tegra/clk.c
> >>> @@ -290,10 +290,13 @@ struct clk ** __init tegra_lookup_dt_id(int clk=
_id,
> >>> =20
> >>>  tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
> >>> =20
> >>> -void __init tegra_clocks_apply_init_table(void)
> >>> +static int __init tegra_clocks_apply_init_table(void)
> >>>  {
> >>>  	if (!tegra_clk_apply_init_table)
> >>> -		return;
> >>> +		return 0;
> >>
> >> Shouldn't this be an error? Or perhaps WARN()? To make sure this gets
> >=20
> > An arch_initcall will be called for every ARM platform I think? In case
> > this gets called on a non-Tegra platform, tegra_clk_apply_init_table wi=
ll not
> > be set and therefore a silent return 0; seems the most appropriate thin=
g to do
> > to me?
>=20
> This is one reason that doing all the initialization from separate
> initcalls sucks. Much better to have a single top-level initialization
> function that calls exactly what is needed, only what is needed, and
> only runs on the correct SoCs.
>=20
> But failing that, I guess you need to say something like
> of_is_compatible(root node, "nvidia Tegra"), but of course the
> definition of "nvidia Tegra" is an ever-growing list of possible values
> that needs to be used from each separate initcall...

FWIW, we have soc_is_tegra() now in include/soc/tegra/common.h which is
meant to be used for exactly this purpose. I agree that it isn't optimal
but it's pretty good. It should be easy to refactor this to make it
callable from a top-level initialization function when a decision
regarding that has been made.

Thierry

--5oH/S/bF6lOfqCQb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTzYxLAAoJEN0jrNd/PrOhERgQAJsRZRUQ+9TQKgFfuvk3nMCR
CASncN/V2m5XRMICNWB/0CauxcV+WsPkD5Vjvgra07bWbarO1hePbKkLidfc7l9B
0io8Nvw+P9yFXmV52JVuCa7pJJnLs3KWN+msf9rYT9tk7XSFMW5Pnl+e192+ILtH
oQi0HvQ3zEmB/tGnoE+5SiGvTu9rQl08dV68qVQnTCrHE598Q+zRSXoyEPTHxd8a
rXIS3TgmICuZccLmTosu3Kv/jdoGpyAWdskvyiUVfVoXiqhGDMYrl4D+kTK2Yq8i
530pdVfZVZ6yA38HLRr5Mch8rNDSh626xIgQlmWoKXeHOexYTh5f1DQKyjbzROkm
O0oYIzk/L1gIUuXtzttCr5Fl7hckN5KI/r6g3Jt2v1WovK8Fbq7eEitVXyxEk4+7
rG0MrA33zc+nM+1VdhDlTFec6GQiXfiKVU+3NV5Gk8+rQHq7NTjTS15E9QzTUF1e
TyyOJGPbD9nRVtvrW7HGq+u8IFx1C1GuD31pul0+srIa5fsV1aYptq6P0r5BrlkL
CLL7uXuA5wdil4T1D34Z/0sHA8AYyOWcMFCvkhekSkW5L2+I72LwDPYlcZ5DYNH7
XHrh821WxGsLqoTRy3VQEAlcgUQ3TZx8veWMl5Zd0g6GQmLL0X4At97anydfFxqN
58cTrS0O1lw1obOeFv7O
=bqXL
-----END PGP SIGNATURE-----

--5oH/S/bF6lOfqCQb--
