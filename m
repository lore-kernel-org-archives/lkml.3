Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaFMUk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:40:58 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40435 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaFMUk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:40:56 -0400
Date: Fri, 13 Jun 2014 21:40:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mporter@linaro.org, patches@linaro.org, bjorn@kryo.se,
        ashwin.chaugule@linaro.org, gregkh@linuxfoundation.org, s-anna@ti.com,
        loic.pallardy@st.com, lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, pawel.moll@arm.com, robh+dt@kernel.org,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com
Message-ID: <20140613204027.GC5099@sirena.org.uk>
References: <1402592317-7043-1-git-send-email-jaswinder.singh@linaro.org>
 <1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5T0u2c3sp8KJuygI"
Content-Disposition: inline
In-Reply-To: <1402592479-7244-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv7 2/5] mailbox: Introduce framework for mailbox
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5T0u2c3sp8KJuygI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 12, 2014 at 10:31:19PM +0530, Jassi Brar wrote:

A couple of tiny nits, I'll send followup patches for these.

> +bool mbox_client_peek_data(struct mbox_chan *chan)
> +{
> +	if (chan->mbox->ops->peek_data)
> +		return chan->mbox->ops->peek_data(chan);
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(mbox_client_peek_data);

This isn't declared in the header to allow users to use it.

> +struct mbox_chan *mbox_request_channel(const struct mbox_client *cl)

> +	spin_lock_irqsave(&chan->lock, flags);
> +	chan->msg_free = 0;
> +	chan->msg_count = 0;
> +	chan->active_req = NULL;
> +	chan->cl = cl;

chan->cl is non-const but cl is const so this assignment is invalid.

--5T0u2c3sp8KJuygI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTm2GxAAoJELSic+t+oim9MRMQAIjwPm+6lqwQRhpeQVvnqPIa
xFnyXQEKyd5fx1s0N3mIvVGero3xmdpzSB7rDegKFVdpKxQhSCp3J+FBwDFySyYu
l+iwQx1fiWPGwtHHeTEEI+1HJf4FDXBaqf6Z0p/VyDNkYy4vYGmmzS+2ZaFqY38U
siPUJ7r75ANFgWG+XNyzgcpZIQc5zrMx5DWIWIIuBXJrAlIAgz/fCwUOKAG8vTLH
BrXpbTQRyKfDA+az4JSa7z26veznHscT/9WbUVdlKhepxcP3rSVrrVcnJJcjzvYk
gjlNAz4nHteq4Kv4NITpyKtfpK5vsuT6ZFouq8d2xb1yAIRFEZ9CzjePCfeSkJ11
4e+5XF9yqzFG7bAuCYnkzeCAp8VT9Os0BkeGuhm+sXmqhChtn4pDYKFuSt+4YW8y
LAyxooVy/0z/vSmN0OkT/uwRnQgXbgstGwo9MJ+uS1ziEABjD/HmpZoqwU9V/8t8
JFlK0E/QEltf5aLw4p9mTBbqLaLVtkYO4EVBDDW6lLh4Cqcke9OShtCPpi8al8cf
dmBzlvHp/z0yaAhS1bY72B0+zPVwWk8KHE22gzDhq6M+KQLBQT/aB6s3kSftgIjF
Na29tSV1IlRaAsOr2plIV7/atHS/wAgkVhJZvkwaMWmPXPKsRx5nVLgVP42XuZLR
aANBmh9MBs+bWA7h0F6i
=YKrX
-----END PGP SIGNATURE-----

--5T0u2c3sp8KJuygI--
