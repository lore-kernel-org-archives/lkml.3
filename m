Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030534AbaGPHTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 03:19:42 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38811 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030517AbaGPHTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 03:19:37 -0400
Date: Wed, 16 Jul 2014 09:19:33 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>, Joseph Lo <josephl@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] clk: tegra: make tegra_clocks_apply_init_table
 arch_initcall
Message-ID: <20140716071932.GB7978@ulmo>
References: <1405437890-6468-1-git-send-email-pdeschrijver@nvidia.com>
 <1405437890-6468-3-git-send-email-pdeschrijver@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <1405437890-6468-3-git-send-email-pdeschrijver@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 06:24:32PM +0300, Peter De Schrijver wrote:
[...]
> diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
> index d081732..65cde4e 100644
> --- a/drivers/clk/tegra/clk.c
> +++ b/drivers/clk/tegra/clk.c
> @@ -290,10 +290,13 @@ struct clk ** __init tegra_lookup_dt_id(int clk_id,
> =20
>  tegra_clk_apply_init_table_func tegra_clk_apply_init_table;
> =20
> -void __init tegra_clocks_apply_init_table(void)
> +static int __init tegra_clocks_apply_init_table(void)
>  {
>  	if (!tegra_clk_apply_init_table)
> -		return;
> +		return 0;

Shouldn't this be an error? Or perhaps WARN()? To make sure this gets
noticed since it's obviously a mistake. I'm wondering if perhaps we
could simply remove this check and let the kernel crash if it isn't a
valid function pointer. Is there a case where this not being set at
this point is even possible (or valid?). If not, perhaps it would be
better to just call the SoC generation versions of this function from
here directly rather than going through a function pointer?

Thierry

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxieEAAoJEN0jrNd/PrOh+GcQALJtJmOd0i1gIbvE1ycNEefG
zLlK2YmWMEoa9DnMMAQREbx76JuOctfZKJVZILKWcAhpOhW8eU+LK5y5b+HAWbRS
g+IlfF6KmKv32jEKTthe62jqc6i5BSxd2MrIYSOb3rXYdvTTN7CBKWWMS5rL0wNq
DhemWu1+n5sn5BQpDRyy7yWZWsU1XZsxGz5AWVS/nXKPHbwIoWSQaOjg/CTgKcuQ
Yt0G5eMzNild0uwnqZCleHpO6e/I19mQZWqO04zw0mV98CUVpFqsFVLOIWwuiUR7
tgK3ZzSqHOqpYsFplcTZuOWIh4HMlRr7Qkwt3KO3gQXkyfsePZ+uweYrAGt/SRcL
TjIq/VOkNl56JdZYunvYtkCXVk1uMhtkM1ocC6oWBnmq74zkC/mpghFTIsSR/9yu
3oAom7gGrwB+vsxfqDH4e7YnzlUWZKflsM/tf3u8c/j43N8oBHMePlb+As02iw1s
buCH6eORKIHCk1Z52zICEjMhrAnzC9IZCh9a+0tKV2WplA1hk0f6ZJTvBmiMOQSB
Njfn1joB5iNDflXsbpUOk94zRVThBcXbz14bzjL0cBSqtGhT+NjbuQQ7gxsP2tm1
3As4wnZoeUfOEIymntbtDlscGopAGtGf6UNfAlw59LuIWQcnbOylOvES0TtmJwIt
Q3eF1fld11NaKxJer89F
=9UKY
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
