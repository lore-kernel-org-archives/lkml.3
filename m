Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab3JOLs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:48:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52925 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758579Ab3JOLs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:48:27 -0400
Date: Tue, 15 Oct 2013 12:48:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Yi Zhang <yizhang@marvell.com>
Cc: zhouqiao@marvell.com, zhangwm@marvell.com, yizhang.mrvl@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131015114812.GY2443@sirena.org.uk>
References: <1381813438-5386-1-git-send-email-yizhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KXGme5rRM84vf8Ks"
Content-Disposition: inline
In-Reply-To: <1381813438-5386-1-git-send-email-yizhang@marvell.com>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: clear status when disable irq
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KXGme5rRM84vf8Ks
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 15, 2013 at 01:03:58PM +0800, Yi Zhang wrote:

> +			bits_length = d->map->format.val_bytes * BITS_PER_BYTE;
> +			for (j = 0; j < bits_length; j++) {
> +				d->mask_buf[i] &= (0x1 << j);
> +				if (!d->mask_buf[i])
> +					ret = regmap_update_bits(d->map, reg,
> +								 (0x1 << j), 0);
> +				if (ret != 0)
> +					dev_err(d->map->dev, "Failed to ack 0x%x: %d\n",
> +						reg, ret);

I don't entirely understand this code - what's the loop doing?  It
looks like it's trying to acknowledge things bit by bit but it's doing
this by updating mask_buf so it looks like it'll corrupt the set of
masked interrupts.  After the zeroth iteration any bits other than bit 0
should get cleared by the &= (0x1 << j).  I'd have expected to just
write mask_buf back or something similar.

It's possible I'm missing something here but if that is the case perhaps
some comments would be good.

--KXGme5rRM84vf8Ks
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXSt5AAoJELSic+t+oim90C0P/RynA7ZaAHtW576D0GCapDYC
CzDWM6EwGOhKTFlgodPexDTlwNIHMVFZKaxS8CF+WhZaj3LB2Bb7M9/n4c0Ax6bE
eeKKYF1lyTWprc/ZO+yXzgLHPc/aJNvR++0LulattbbibsN+aaCjlr1jOTDiyJzn
RXPzUkYRRz0mDsPTC7gbNXhO9YkgNXUlhb3+ViL2x42at4XDw26kMICA0QVQpGRO
styTAs7u/z4NaOfPsv1UTUwI61lbvR3pjr2OP+k0f0xEHyDqoi/Ee246LckwFoCG
7eoTFCYTJJ0s5LZK4ikrb25cC+hA7i7BIxj/4hvrOYuQjEaMLazPKqZN2XZz6L7Q
PpmP3PYwgD15qq6VOjmK1MSOXS0dEj8GoSsY1VBstPESvt+uzUbjktt71sMmhh/0
pswTZHhMnpi3bWpumqbotKIDIaloct67om2CBJuvYzxIhBRKTS6MmQbymXWLmiwF
qe9Qn3uymeriMksMjo0B1xb+eM/zfJkGvWU6bhjnk+KDgaykmzQv5euN88pmMrnm
uS8+DPEKSQKMQPjwhX4oTWCliB9DEgR3Q25D9ix7SzqdyxyuA8rIuvSiy4Dx6B+H
lvtvaVy5iZWsKmvBaqzdhd/I8EzFLa8xnwVwz7aC3w/a/pMSjJIqS6ynfHTviiqM
6VofmJy8X6Tw3Ys0kMl7
=IJ7h
-----END PGP SIGNATURE-----

--KXGme5rRM84vf8Ks--
