Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaJONFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:05:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56003 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJONFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:05:48 -0400
Date: Wed, 15 Oct 2014 15:04:52 +0200
From: Mark Brown <broonie@kernel.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, amstan@google.com, sonnyrao@google.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Message-ID: <20141015130452.GD27755@sirena.org.uk>
References: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com>
 <1413372349-4254-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lgDpGT5NbMPMciux"
Content-Disposition: inline
In-Reply-To: <1413372349-4254-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: You are magnetic in your bearing.
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


--lgDpGT5NbMPMciux
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 15, 2014 at 07:25:49PM +0800, Addy Ke wrote:

> +	if (WARN_ON(rs->speed > MAX_SCLK_OUT))
> +		rs->speed = MAX_SCLK_OUT;
> +
> +	/* the minimum divsor is 2 */
> +	if (rs->max_freq < 2 * rs->speed) {
> +		clk_set_rate(rs->spiclk, 2 * rs->speed);
> +		rs->max_freq = clk_get_rate(rs->spiclk);
> +	}

I'll apply this but you should be checking the return code from
clk_set_rate() here, please send a followup patch doing that.  It might
also be worth consdering just setting the rate unconditionally here, it
seems like it should make things simpler.

--lgDpGT5NbMPMciux
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUPnDrAAoJECTWi3JdVIfQ0pgH/iXhsAmzVdGxVgj3YgqbUkfm
iDL0qZLGWZ0NNl0bPPCb7i7Vb4hTQrj+o+SuK8q6DAmG/Tq7r1o54fPK6IpCyZNS
OmeewytnwFqp5k3+wBbePL7QLuL7RSAXJ1gmwlg8K3F6b+hwN/iceaoUqpX7+ljv
rG8Ma13ht7ukQ0HZQLy6s9T+Je+irhurajqn6a8cnPF/INSKMVkMayCsqoOnPCyw
LQcyESiwBPdYcTSsnlGCpaWQXU9KLphYVEmMiJK1vz3K6Co7UTgEf15wRfITQH36
bTSNQlbCPihGokjspDR0UMfSHAE+BKqr9qx35yL3g8S/iKPpguXVHJbWlPoDC/Q=
=46Wt
-----END PGP SIGNATURE-----

--lgDpGT5NbMPMciux--
