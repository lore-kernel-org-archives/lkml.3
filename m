Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3HUOpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:45:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47088 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3HUOpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:45:05 -0400
Date: Wed, 21 Aug 2013 15:44:42 +0100
From: Mark Brown <broonie@kernel.org>
To: David Jander <david.jander@protonic.nl>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130821144442.GD26118@sirena.org.uk>
References: <1377090155-3443-1-git-send-email-david@protonic.nl>
 <20130821133200.GB26118@sirena.org.uk>
 <20130821162143.42ca91de@archvile>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Content-Disposition: inline
In-Reply-To: <20130821162143.42ca91de@archvile>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 04:21:43PM +0200, David Jander wrote:

> I hope you can explain to me how regcache_rbtree_node_alloc() is supposed to
> work, because I start to think that something in there is broken...
> Specially the code at line 323 strikes me:

> 	if (!rbnode->blklen) {
> 		rbnode->blklen = sizeof(*rbnode);
> 		rbnode->base_reg = reg;
> 	}

That's intended to avoid creating lots of tiny blocks.  I think this bit
is actually OK but what should be happening here is that the collision
gets noticed when we try to insert the block and we at least constrain
the size of the new block if not merge it with the old one immediately
after (which is obvioulsy better).

As a bug fix setting blklen to be a single register ought to avoid
triggering problems though it will be less efficient - does that work
for you?  Doing the merging is going to be too much for a fix.

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFNJXAAoJELSic+t+oim97HMP/AxP037GmxMF+/uGPKXl/Bgj
IJRjWWGZ+1SCoS3wjjbhvbLrVtEBz6sI8rfWn4RepbXKvDrIVYmI94lXVSaiiLYF
9hm6IixSmky1098OSgxbM0xeGK1tlbvJW4csQOEfmR5QQtrkG0JwsgUN0KZHu5aA
pOez7vevfdohW7jPsObNwf3QQf1CRHqPzh4qHb+XS0nBRAHMRdIs5qmuF7Pu+PYe
+lgNHr6MubBW1zPrNsKbG6PvmU2QjOox9GWkpO/VFSbmHL8aVyN46zgTdpFZ5NoW
otcKyqLfdUU1PW1PPrvAA0VCuSeZZxD/I50JURY/fYtt1Ja6Atigh4hd3fLX79qD
W4JEm7j8Is8UGGfkdJHXx0CPsaBNutOhUQeMn7uH7qTXypzxhZj0kLbRkK15zLUA
DcMBCspA36Y+mGo3kh8SPWoqW8QxFk8zQPQq7P0gu8AIpF4msGWRphq1Gk+inEzP
V/7miEfUtjB3B64Q+MjRq3wboS7mxZ++NUjt6J2+XeMJtIKXkAMub0hRZd+a1Ru7
PGLNq6mNkfVcmNUkaP3chBUSeFrVqV7fbh7awPegkXbM4q/ZMsWN7pYdJUfy/+F4
4fglmyyRwHY1L0Mi6GJ/+5I/6bSV1niReyteRKjALr5lDmW00jBuTU186RJ8i/HR
Erj2jX5juPTD4u8BshjW
=maZP
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
