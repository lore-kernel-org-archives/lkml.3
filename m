Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3JNLJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:09:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33206 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3JNLJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:09:57 -0400
Date: Mon, 14 Oct 2013 12:09:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Yi Zhang <yizhang@marvell.com>
Cc: qiaozhou@marvell.com, zhangwm@marvell.com, yizhang.mrvl@gmail.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131014110908.GP2443@sirena.org.uk>
References: <1381724633-29586-1-git-send-email-yizhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3bc47Eih9dS+biPM"
Content-Disposition: inline
In-Reply-To: <1381724633-29586-1-git-send-email-yizhang@marvell.com>
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


--3bc47Eih9dS+biPM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 14, 2013 at 12:23:53PM +0800, Yi Zhang wrote:

> Change-Id: I371201f365c5a8470073a393068cfeb4e3d14a03

Don't include noise like this in upstream submissions.

> +		/* Ack masked but set interrupts */
> +		reg = d->chip->status_base +
> +			(i * map->reg_stride * d->irq_reg_stride);
> +		ret = regmap_read(d->map, reg, &d->status_buf[i]);
> +		if (ret != 0)
> +			dev_err(d->map->dev, "Failed to read IRQ status: %d\n",
> +				ret);

No, this isn't good - it'll read the hardware interrupt status again.
This will break any devices that are clear on read since enabled
interrupts will also be read.  I'd suggest unconditionally acknowledging
all masked interrupts as the simplest approach, obviously it'd be better
to only acknowledge newly masked interrupts but that is more complex to
implement.

--3bc47Eih9dS+biPM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSW9DRAAoJELSic+t+oim9H5QP/RXDgitwVw72o/nQJDz/F+0W
WqcaDSuJB+bzUk1IznCMoTp9nw/hUtcrgrR3dSw+tXP+D4FZjireKsLVFnVZO1dn
24KY6xFOAjrirrwxIlRt0hxmZdjOEITI5YEG64QPlPx7gWOLl/avEEkAO50G+Rll
+iizfoZcZOCTzXsP/pm1Vn8aJ9OAYwGa+YfPdIN2e/qTp3/nz3Jki6j9SSg6nPVW
B1FM2UbuhpQes/SgyEvIjkkztiy6pKy6xMEj4xQRwfR49DpoMaR3aDtUroEM9At6
J1XLL+b8+y03nqKOyn3FNn+iHJDzEm9F8cs4+Kdn3myX0evLjQOVIx4TlRsIIYeI
Mn7XUIvCxKPcmh6a/aDJr59/ZAvaGEiCxy2hBbCgwfVWo55bN0wVZ9y23K5yrhUF
7Ltf7OMfsl0i2qKcUjGTclERaUfeCdSW2VW+gzrVrWU8Maw/rKvXrJvpfW2w29Co
HMCuk89Bcly4qQaaOirrD2eeeQmsOgx4oznbNdBmDYsbUBjKBNXBh4FF8WMQqcax
oXQsOqMnuXc8faisbJX0AjhobyObv1IiYUwJS6Fj3dgQN+s4Ai4Y52tm5RldRxfI
OkJBUGeYgZ0G7KUKH0KjbUouAwhxbvkK6heU/Lq89GILh+UsWdMsyGP9KLwT/Gai
wevVE8Wy23xc+QtdpTWj
=7tb/
-----END PGP SIGNATURE-----

--3bc47Eih9dS+biPM--
