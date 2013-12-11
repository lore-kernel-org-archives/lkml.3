Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3LKAvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:51:16 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34435 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3LKAvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:51:12 -0500
Date: Wed, 11 Dec 2013 00:51:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20131211005106.GL11468@sirena.org.uk>
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org>
 <1386718523-2587-4-git-send-email-sboyd@codeaurora.org>
 <20131210235000.GK11468@sirena.org.uk>
 <52A7AE1B.3040201@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jl+DbTnyraiZ/loT"
Content-Disposition: inline
In-Reply-To: <52A7AE1B.3040201@codeaurora.org>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Jl+DbTnyraiZ/loT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 04:13:15PM -0800, Stephen Boyd wrote:
> On 12/10/13 15:50, Mark Brown wrote:
> > On Tue, Dec 10, 2013 at 03:35:18PM -0800, Stephen Boyd wrote:

> >> +		reg += sizeof(u16);

> > I'd expect this to generate out of bounds accesses and bad interactions
> > on the bus if we go through the loop more than once since it appears to
> > incrementing the address of reg for every register.  I'm also having a

> ssbi_read() just reads the same register x number of times and doesn't
> do any sort of incrementing of address. My understanding was that
> regmap_bulk_read() will read incrementing addresses and then call down
> into this code with the sequential addresses formatted into the reg
> buffer. That was the flaw. Instead we need to take reg and then

That's possibly not the ideal decision for the underlying API, if
nothing else it's confusing naming given what a read function would
normally do.

> increment reg by 1 every time through this loop. Or should we just have
> use_single_rw == true?

No, it doesn't - it increments the address of reg by the size of a
register value each time.  Using use_single_rw might make sense, or if
you can't do bulk I/O at all then hooking in via reg_read() and
reg_write() in the config rather than trying to parse out the buffers
might be even better (you can still make helpers to set that up).

--Jl+DbTnyraiZ/loT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSp7b3AAoJELSic+t+oim9GC8P/RxuI3ZsWVHXYUItu5mCw7Hv
vUFuVxuGwZrTCEZ+jfGZERhrrxIepV6NpCyZnndSvqRF5woY98Pj50lOEl0asOkA
k0pgY35l476I5MDtIGZmNS2nI6xE2cGq55szkBjFrEiXnzlBNZ7Y8zF/OxGIdPaD
sBkNs1pUt4eGcO46x7GSJVIrxLJiX3NBCJekrBZ9wMWXf5lI7yyhsECD3gt4AaBH
weBXkG3IFiXUx01yNRvhg3SjWSOD4s5UtxtM8MaoR/lkjpF/qrvaaBke9MSgPr+k
IQdO/HhX8nxIKdupUAVyykxqbSdHVE24CzTZmrEtcr6Z09h/SzBI8dfYLkTxW16A
g8MkAykXl2FIhhQ5xKb/HcfHVm+8h3D7UhvcQfPpdT+HmvMVwOKrHkTZ7mXJiK5W
bbHmzAL3lFaSH/GnUUh6gycE9iPfE/iiUr/BIU+hLhk5/Sf0T4/tKVJlmlw/skdt
Yax7YZeJkDRwsN1y46BaACrJQofoq9MZchgCybwb44oEj3QpCgc1s98u2CApwD3U
dW8KEcOLupuXOZRxDJyYfvrubO3stGea3edRUIqIrJ85eWT9D7uaoBgi2fjnZmjJ
Lc16POuaZEabnAIUy5G7f3MJhX4ws2AnzjMVLmCy7jNlcJGqHq6E3xNDGqKnkisY
dAd7QQj0acl9t3H4W51s
=w2JS
-----END PGP SIGNATURE-----

--Jl+DbTnyraiZ/loT--
