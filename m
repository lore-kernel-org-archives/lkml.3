Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab3CLSMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:12:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55081 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932465Ab3CLSMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:12:50 -0400
Date: Tue, 12 Mar 2013 18:12:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: Expose total memory consumption in the rbtree
 debugfs entry
Message-ID: <20130312181246.GA19942@opensource.wolfsonmicro.com>
References: <1363109209-23170-1-git-send-email-dp@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1363109209-23170-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 12, 2013 at 05:26:49PM +0000, Dimitris Papastamos wrote:

> +	mem_size = sizeof(*rbtree_ctx);
> +
>  	for (node = rb_first(&rbtree_ctx->root); node != NULL;
>  	     node = rb_next(node)) {
>  		n = container_of(node, struct regcache_rbtree_node, node);
> +		mem_size += sizeof(*n);
> +		mem_size += (n->blklen * map->cache_word_size);

This appears to ignore the size of the node structure and only have the
root context and the data.

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP2/+AAoJELSic+t+oim9GA4P/0XVDL43nZ3IhDE6npx0++iG
gkSoLS7gy+FoxwBl0rSg0JCWNq5ItH6j8qXMxG5XVaDol8wQeNchShPgxWVoIZGC
lxjzUGOlFikDasWD8O3iJbZVf1pyk8jIJy+BqhgmLa4PG5oljmC7Q8L4lKHY8rOa
/1IXBXjeK7Fd8jKNVmWFk36GQt21TnUswjm7Ta0RMD+3xO67EXn+QNVAKhPXSb/7
lu5pf7Ie7reKgRkHnW2iQwNUhHCwfwVdEZ2GHRIyHPmcYwGzawU4cJCZp9dylT4n
PEHdOaLYchv98ICMXXlTo+yiCzaMcvg6XE7Tse+YamXXDRF67qfd/DeXQtCTTHQe
sEMa7PbNQaHZonMFXGQ6cBEuzV6YaYYSJzYlPRi/HLkSsR39noQULHhci8OQI5Xy
k7EE5s24JpMluxd8dolVQRJ9RfF/7LOp1coGb6zCRlmSfjlOvw9LEVcAE5Su7I25
0mJIVgRl61ZNUSnzSmyTyRH33ZZK9VpKNpO27llpsgohQXlC10OyOhBZMC0O0P4Z
yn32ZYFFeV+SpN7EmVOkJIAC3T3tO2ZOEVRnm0JoFSm/mAdbbBvvovLw7E6nDMA+
LpZSgTeLu0fzo28VSmQM2TVt82RL7Rv1u0uVjkgSJq7WlS2uDOw9rLOw0J9aeD37
4Y98Kb8Wc7PK6Cx2pVkD
=43qf
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
