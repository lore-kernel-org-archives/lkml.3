Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab3LRSpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:45:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59912 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3LRSpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:45:47 -0500
Date: Wed, 18 Dec 2013 18:45:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131218184541.GH31886@sirena.org.uk>
References: <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
 <20131211005106.GL11468@sirena.org.uk>
 <52A7C0C3.2070805@codeaurora.org>
 <20131211132729.GT11468@sirena.org.uk>
 <52AA42FD.4040503@codeaurora.org>
 <20131213104128.GT11044@sirena.org.uk>
 <20131213213707.GO21983@codeaurora.org>
 <20131216210153.GA3185@sirena.org.uk>
 <20131217023047.GC31766@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFBW6CQlri5Qm8JQ"
Content-Disposition: inline
In-Reply-To: <20131217023047.GC31766@codeaurora.org>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Allow regmap_bulk_write() to work for "no-bus"
 regmaps
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFBW6CQlri5Qm8JQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 16, 2013 at 06:30:47PM -0800, Stephen Boyd wrote:

> -	/* No formatting is require if val_byte is 1 */
> -	if (val_bytes == 1) {
> -		wval = (void *)val;
> +			ival = *(unsigned int *)(val + (i * val_bytes));
> +			ret = _regmap_write(map, reg + (i * map->reg_stride),
> +					ival);
> +			if (ret != 0)
> +				goto out;

This doesn't quite work - val is an array of objects of the size of the
size of a register not of unsigned integers so you're parsing extra data
out there.  That possibly wasn't the best choice of API but we have
quite a few users now so ick.

--nFBW6CQlri5Qm8JQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSse1SAAoJELSic+t+oim9iGkP/3igSrkMsIA3wFboIouqSnvt
3I4dIeBsTOyFiWiEzO6ArWte2kG6BwI/XdjsdbbJvbZwe+uq2dRrde9wm6cF1CIz
CfMBtDmVFj02WYo3Kb+dLMViBiirk/y+CeVCYz7l16IKn5Ujpy1lLqV8tgDl17Bx
Bo6o0v4wVObiZU3bbPZVYAcJ2vTKsOBaytJh2IqWD5O4kbOnbCp9yeTN8Y5An8GO
5hL97Fs0MHng9LQg8NgNB9Rd26lcS7In74Mgk5IpswYLuKNKvNGXYgvCWzZjub3N
9wtoaERJ/SUsdisywG9l+WLVnNvDVabBgqnWYmLEC1YH/+TNHqp8OPoiJqTXS79H
NkpC9hhB1RQqPixxDOcjBlJX2jytqjIQToCjmDw1cQb9MpeUbwrwRqJerawQ6LQ/
pY+T8C9u2jFSaYav/CRCCzL5Pi3iSuvgyrVBGdT7ovwVQ3MS0eEMNieDpWUgTAa+
OMNGJrkoRGJdvM8lPR1UeSNCG8/cEDMjk1nE7yH9nmKKgGjKp+FilfRzLWRmQquw
lvMCSASZIQRTRxhI6wEmycFWVK85sS2P5rHPUxe8xw0IVTjhBc7Y7+1CcTEOp26x
O0G3KMEEvmNNSxd54MvOiRbBqvHZolB8P+bXj2L/NnOTffK4eZnzNSA2KcybhYqR
q9ffB4Yq0c4DeTVo6Es9
=8nt5
-----END PGP SIGNATURE-----

--nFBW6CQlri5Qm8JQ--
