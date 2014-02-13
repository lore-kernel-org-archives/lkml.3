Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaBMItR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:49:17 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:37992 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaBMItO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:49:14 -0500
Date: Thu, 13 Feb 2014 09:49:08 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Stefan Agner <stefan@agner.ch>,
        josephl@nvidia.com, dev@lynxeye.de, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: don't timeout if CPU is powergated
Message-ID: <20140213084907.GA11795@ulmo.nvidia.com>
References: <1d5ea6b7df4573d866779857922ac650fe59af60.1392078805.git.stefan@agner.ch>
 <52FBC97D.8040809@wwwdotorg.org>
 <4050206.sG2EzXyfMN@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <4050206.sG2EzXyfMN@fb07-iapwap2>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2014 at 09:28:52AM +0100, Marc Dietrich wrote:
> Am Mittwoch, 12. Februar 2014, 12:20:29 schrieb Stephen Warren:
> > On 02/10/2014 05:44 PM, Stefan Agner wrote:
> > > When booting secondary CPU(s) which are not yet powergated, a wrong
> > > check lead to a timeout after 100 jiffies. With this patch, we only
> > > delay powergating if CPUs are still not powered yet.
> >=20
> > I've applied this to Tegra's for-3.15/soc branch.
>=20
> also for 3.14 and maybe lower versioned kernels? Since this seems to fix =
a bug=20
> where some core doesn't come up.

Yeah, this bug has been there for pretty much forever it seems. Commit
86e51a2ee471 "ARM: tegra: support for secondary cores on Tegra30" added
tegra30_boot_secondary() (named tegra30_power_up_cpu() back then, which
was renamed to tegra30_boot_secondary() in commit 0d1f79b033bb "ARM:
tegra: refactor tegra{20,30}_boot_secondary". The latter was introduced
in v3.10, so I guess backporting it to stable releases all the way back
to v3.10 would be good.

Backporting to earlier versions (86e51a2ee471 went into v3.4) will be a
lot more difficult since some of the APIs were renamed since then.

Thierry

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/IcDAAoJEN0jrNd/PrOhNGcP/jEshynHOlWfqieeS4M1Xp1C
qPDBKBn41A+gXjT4utzqQQ5OrYraVk5d9K2A+B7FP3iqHFxZ4gkI2c68g9kbEJWp
SQFXAhJJxNejIaT3/Y5MK6maH/JzdNL0fRKnomrLQYYNOv19zUyZXhbyiy7t48Qg
pbRlUrM2wyLhX1mVHH7VI6I0me0awVZOOPxukEZPY0v+YhiI3V3wjSBZMzdUlwKP
v12vpJc9Zo0sA+HrcgkgvkqoA1GN4fmu5bhcXV8moQyD8RZf6nJl7CO5U/bP+iX8
G8PO9VfdQs9ZxjNg1pR0hJehz7lRX1Dzw13z09cAMxEfTKUHcakWJ/fxxpcd7Yuy
eAJyA46P5DRJ+Xau7QhIdTTAWVDu+Bb7MesJqmGlkR5BYpgniS9n4sA9DnAogYuE
rAYZ/MSs5QF1HDveCPS89JL1tM+mRxDprfailcLTQFvcRJFMzVw2G7gFCnr7HFFm
lodVEgtbKh9FJpjuvzzW87uiylfo+b6CHNPxYoWz2RjQ+Bd6wHkeDMpisVjOzzxk
JtQYPayJh+Z9NVXDmlkoMi5OEknHcWugFrOLE2lexGDl6Lezagm8ylCoFKAoiCwU
0SyEWdkQo9Bx6YHVffOqmfFdX1ZJMeOQ21YrRwHCzok4dkzLi+l1NWYDP3XFKfol
4U9vGyRyj9hj3eYwfT5h
=1/7F
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
