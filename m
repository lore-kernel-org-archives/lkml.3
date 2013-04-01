Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab3DANqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:46:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49501 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757106Ab3DANqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:46:16 -0400
Date: Mon, 1 Apr 2013 14:46:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 06/14] spi/spi-atmel: add flag to controller data for
 lock operations
Message-ID: <20130401134613.GY18636@opensource.wolfsonmicro.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679163-3897-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z8pjODCYYz+3zRe3"
Content-Disposition: inline
In-Reply-To: <1363679163-3897-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z8pjODCYYz+3zRe3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 19, 2013 at 03:46:03PM +0800, Wenyou Yang wrote:

> +static void atmel_spi_lock(struct atmel_spi *as)
> +{
> +		spin_lock_irqsave(&as->lock, as->flags);
> +}

Coding style.

> -	spin_unlock(&as->lock);
> +	atmel_spi_unlock(as);
>  	msg->complete(msg->context);
> -	spin_lock(&as->lock);
> +	atmel_spi_lock(as);

This replaces non-irqsave versions with irqsave versions of the lock.
Is this safe/correct?  If it is I'd have expected some sort of mention
of it in the commit log.

--Z8pjODCYYz+3zRe3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWY+fAAoJELSic+t+oim9RncP/0xjOvN+as2WaphlQBQHm+WI
ztDo6ZQXCheZ2Xxm7pWMRQp7xlWl9osMsy4AyXUViUcjnJnVJ41yaJFRc1vsFKqC
Dp17ncfaBag3YpX8yhicXHXMbckjy8GFcPVLJ262Es58BR+ZCClw4GFd30IjoGt/
hmovNlz2h5+wrn51uuF1lRcELxvDx1mbecsj5ExwDNCWOp6JBdyoAn4PzhQ3RCWs
JHgy0FFBJ8agqZMH9StxeRJJAhnnAMFTIts010LyYosJyPQCAe3I/arMyse6WY2y
RkeP/X6NaNjqaSq/k+EWIuzvHbh6cWZf1THlKk6oKoJhHkhiRmH3foRAWBBOKJSJ
BMewxiPl50fERxt6jU2u33rTDqSvybAX/zGKPF00ksqgeRQ6zAZl+1ZQ3NO3Yopq
JD2yx0MOKa+7a2s38/aqbJhEW6ycshcmEVN8Z9SRFAcRIH0CO7uL7cG/gKKMcZnJ
tUt6v1l+i3ZRohwT/ULZAmJDiyqB9bm9Mtam+7fQGr4EeqUCa6JH+D2urp0gVmLy
DFpBmI5Kt3BS0ie+2wAEle/UmzPr3x4xH9yKTGJub2meRfgXEqqOx6JGLODtgi/E
IWcwqvAqQdZSWnKbo+8AOhB84x4oEHzVneA9Ctg2OeoSNz7v2KtkPRFQ1NyUzb5b
ckX4Rbw2RGBqx2M3g8DL
=NYp+
-----END PGP SIGNATURE-----

--Z8pjODCYYz+3zRe3--
