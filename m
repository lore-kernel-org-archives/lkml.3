Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaGBKXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:23:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43419 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaGBKXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:23:44 -0400
Date: Wed, 2 Jul 2014 11:23:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Huang Tao <huangtao@rock-chips.com>
Cc: jianqun <xjq@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        zhangqing@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com
Message-ID: <20140702102310.GC410@sirena.org.uk>
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
 <1404204458-30881-1-git-send-email-xjq@rock-chips.com>
 <20140701170747.GA15028@sirena.org.uk>
 <53B359FD.3080809@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <53B359FD.3080809@rock-chips.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: add driver for Rockchip RK3xxx I2S controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 09:01:49AM +0800, Huang Tao wrote:
> =E4=BA=8E 2014=E5=B9=B407=E6=9C=8802=E6=97=A5 01:07, Mark Brown =E5=86=99=
=E9=81=93:
> >> +static inline void i2s_writel(struct rk_i2s_dev *i2s, u32 value,
> >> > +			      unsigned int offset)
> >> > +{
> >> > +	writel_relaxed(value, i2s->regs + offset);
> >> > +}
> >> > +
> >> > +static inline u32 i2s_readl(struct rk_i2s_dev *i2s, unsigned int of=
fset)
> >> > +{
> >> > +	return readl_relaxed(i2s->regs + offset);
> >> > +}
> > Perhaps use regmap?  The main advantage would be the debug
> > infrastructure, though you could also use _update_bits() to reduce the
> > amount of time spent locked.

> Are you sure? This is a I2S driver, we can write the register directly,
> do not through I2C or SPI bus.
> Write a register is only a few instructions on ARM, but write through
> regmap, it may take a long path.
> I think it will just consume CPU power and make the whole thing more
> complex.
> Could you tell me what benefits we can get if use regmap? Or something I
> just missing?

The main thing is the diagnostic infrastructure, plus the cache if you
find you need that for suspend and resume (which you didn't implement
yet) - that's the main reason things use regmap for memory mapped
registers.  There is some overhead but it's not *that* big.

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTs92LAAoJELSic+t+oim9de0QAIpJDfitV4KZmuWJpXf2qW3r
StUJ7OzJ1eiE+SXAoFhbJ099e4g3czFMrpukLktYrCqfrASt6/9r5GV8AAJirKQV
cVZ9StXmo1ZcLw9QPiHHlfaZeU5ZqdKzuFfYufG/d4PNfkz6Vf+hRJ6VVrL4C4ky
iRsjvJ/MCuolmMJKMgRCL1S8og+MxQCe6kMt8RUz6jxt/5//VtL6WVtMNu2ee+Bx
VcF2IizQLS7JgBE5UTDVIL4ENMGZy82eGjfTPvgGzZIimnSUIm2zWmMip8nuXg2O
QO0mvLfwgoE8ZOsPg7wlT3jfOKIFe1C3zsZPNFqaYRnkXTSHXyDZcaCg//7juh6I
9sj65KDp3USfqcVGuJZCOB/jVy2IJORYxYJfVQNLqLfL5Sv+yilCEJ0iP+uq8RLn
b4+HUxjNBPIuKBFwxQcAbqQir2PTQZRggGBnNBONMMuDmpQxY8kmMwaq1zy8GxZb
OQDAipvE1zaxAPhrd3UfEJAnFMVVfaNjGfUNvSAgqgI4h2ax68wVG685vf+6QxLh
hrH9YjT/qaKlK1Dr3i55s3JJ0vY3KS8Ilzl+0KYHglMBds8sSg3uS6OZTO0uPcqR
uNZBiQzd97z1Pv2KaIMWqfEhKDk5t168tUn8wfb5bPqV2JcXVseM1Yv6SZVosFIK
3GQUR0iwthdOuLNuY9Mt
=mzwd
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
