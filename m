Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaJPKGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:06:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58296 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaJPKGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:06:31 -0400
Date: Thu, 16 Oct 2014 11:34:10 +0200
From: Mark Brown <broonie@kernel.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, amstan@google.com, sonnyrao@google.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Message-ID: <20141016093410.GB2200@sirena.org.uk>
References: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com>
 <1413372349-4254-1-git-send-email-addy.ke@rock-chips.com>
 <20141015130452.GD27755@sirena.org.uk>
 <543F8CD2.1010302@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline
In-Reply-To: <543F8CD2.1010302@rock-chips.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi/rockchip: fix bug that case spi can't go as fast
 as slave request
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 05:16:02PM +0800, addy ke wrote:
> On 2014/10/15 21:04, Mark Brown wrote:
> > On Wed, Oct 15, 2014 at 07:25:49PM +0800, Addy Ke wrote:

> >> +	if (WARN_ON(rs->speed > MAX_SCLK_OUT))
> >> +		rs->speed = MAX_SCLK_OUT;

> >> +	/* the minimum divsor is 2 */
> >> +	if (rs->max_freq < 2 * rs->speed) {
> >> +		clk_set_rate(rs->spiclk, 2 * rs->speed);
> >> +		rs->max_freq = clk_get_rate(rs->spiclk);
> >> +	}

> > I'll apply this but you should be checking the return code from
> > clk_set_rate() here, please send a followup patch doing that.  It might

> If clk_set_rate return error, do I only put dev_warn here or return error value to spi core?

It'd be better to return an error if we need to set the rate and can't
do it.

> > also be worth consdering just setting the rate unconditionally here, it
> > seems like it should make things simpler.

> I think we need.
> If we set the rate unconditionally here, clk_set_rate() will be executed in each spi transfer.

Is that really such a high cost?

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUP5ERAAoJECTWi3JdVIfQxfgH+QGfQFD/KQ+OmRJyUPfMHGXX
6JdP9nSyawWv7+xoUgLK9rDuTnwOxJedbhsToh1wJDcjg3bOgrnoiWkbADNH1L/e
IHsMq+HJTZmv9xq4oaFx/vVHeFFPSsh2AtldEOMgmM50bGlg3M2sTo0Pg5mVdmIg
tEMCXUtXU1Ehs9OsZh0HT0sZK7H+sPD9VfFVwRE03EZRjIy6LtfEwCihCAB9/tMM
bGpomAJq7Az1BP5y5SWLru4X1H4uad4kaywaAUB6jqF35MlR1qXdAkjzFGZoBm91
vMd6ouDuDCfmg2NzKwIJ+mqXOWC7QijzlMmvkmUujef9aDyZAho5fXIwS66PKL8=
=lzOL
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--
