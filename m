Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaIORCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:02:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43175 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbaIORCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:02:36 -0400
Date: Mon, 15 Sep 2014 09:54:36 -0700
From: Mark Brown <broonie@kernel.org>
To: Jianqun <xjq@rock-chips.com>
Cc: Jianqun <jay.xu@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20140915165436.GW7960@sirena.org.uk>
References: <1410568723-21559-1-git-send-email-jay.xu@rock-chips.com>
 <1410568993-21874-1-git-send-email-jay.xu@rock-chips.com>
 <20140913163749.GK7960@sirena.org.uk>
 <5414FD1F.6020603@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UY7nlVifw84slYwb"
Content-Disposition: inline
In-Reply-To: <5414FD1F.6020603@rock-chips.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/5] ASoC: rockchip-i2s: enable "hclk" for rockchip I2S
 controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UY7nlVifw84slYwb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 14, 2014 at 10:27:43AM +0800, Jianqun wrote:
> =E5=9C=A8 09/14/2014 12:37 AM, Mark Brown =E5=86=99=E9=81=93:

> >> +	ret =3D clk_prepare_enable(i2s->hclk);
> >> +	if (ret) {
> >> +		dev_err(i2s->dev, "hclock enable failed %d\n", ret);
> >> +		return ret;
> >> +	}

> > BTW: you're also missing a clk_disable_unprepare() in the remove path
> > here, please send a followup fixing that.
> remove function has done the clk_disable_unprepare for "hclk".

> One more thing, since "i2s_clk" is enabled at runtime_resume, and is disa=
bled in runtime_suspend,
> hasn't enable in probe, so do the "i2s_clk" to be disabled in remove ?
> The current driver has disable in remove.

Again, please try to write clear changelogs which describe what the goal
of the patch is and cover obvious questions like this which a reviewer
might ask.

This is all extremely unclear - you're adding an enable here with no
matching disable.  It seems that what you saying that there was
previously a bug where the clock was disabled without being enabled?
I had to look at the code to work that out...

--UY7nlVifw84slYwb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFxnLAAoJECTWi3JdVIfQ2goH/iV5NaXpjtKs+PwEz4xS+1K1
7HHS0xID6tyQp+jIHakSg633s88uH7YN8slrwvdpSwOcqDXC73eiHP1UzQ3sgZai
hAu0NulcrC8t2RyJ/l2PXbpFZ19Z+MlREJxVBL/F0QthvcfVtpY0Ah9IqFxq3Up1
8v63pzxQof3Qfj1USUf+6u62Q/i0SmUFe1HAfkC0N3nSPlf9vZPtMip021/MhfFv
xQc/ngaL7YgHlUMh8vsQGdU+bWfz7f9eHROjDxPbipl0YRe4cbzsRMHmk8ZlVYFM
kmcklgCly+juio5dMJtVhon4yrcmjulnRLFHh9Wf1Ogm56EMKnwcylxCAKlX+JE=
=OH8N
-----END PGP SIGNATURE-----

--UY7nlVifw84slYwb--
