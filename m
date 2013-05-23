Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab3EWQB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:01:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34151 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3EWQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:01:54 -0400
Date: Thu, 23 May 2013 11:01:28 -0500
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, linux-kernel@vger.kernel.org
Message-ID: <20130523160128.GA7660@sirena.org.uk>
References: <1369314377-22873-1-git-send-email-lars@metafoo.de>
 <1369314377-22873-2-git-send-email-lars@metafoo.de>
 <519E38ED.7090202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <519E38ED.7090202@wwwdotorg.org>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regmap: Make regmap-mmio usable from different
 contexts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 09:42:37AM -0600, Stephen Warren wrote:

> I guess the core of the issue is that you want to replace spin_lock()
> with spin_lock_irqsave(). I'd like to see that explicitly described in
> the commit description, if that is the core aspect of this change.

Yes, I was just going to rewrite the commit log to make this a lot
clearer - the entire first paragraph could pretty much just be replaced
by just saying that we need spin_lock_irqsave() to allow interaction
with interrupt context.

> ... and obviously add a spinlock_flags field to struct regmap (perhaps
> start unioning the mutex and spinlock data fields there if you want to
> save space).

This should work, yes - care to respin Lars-Peter?

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnj1VAAoJELSic+t+oim9OZoP+wcXoWD89VNbim+/57WPgTbA
Eazz7me5vKHDPdchwPvJMvBOYBY1cHOUh9D3kf1qxW9HkX49soXkObm1RcN2elBT
gfeEP0rmJ4CkMJC8KLXUav65Mn/0rlvz3bqgiNpkE+crGl9dp2A6jMCfRlcRm4NG
3FCxKxEExAsTwvxoy//BqtI4S+Hi7IepuJY2S/e6OQPB3aDLC97dKEfZN1xGhV6B
3xszmBrJF1VZ70mAnvP+wooG2k5VaTdLUKH8QzKhGqRJ2H4As5AIIY/VJCN+l2VQ
zwVMgs3Uy/3iYZzjEtajASJrcw3s3LYOuy/7uosNkb2vmmAbbpEYePrh7aUn9K00
9Otiq3gKxjzVes91dYFMHAdnPTQNXZDTsLMQoqM6J+25ACT2xQcJC1IF75R84LwD
2Xhl2W6Kn7GFqo6lCVzXfAlDq0uaFGq3e7ABTvqWDSqM2Az8OScqI7PW3lFoXMoa
ahEdGEwN7VCbxqmuROv4ZPv3uwWmZyaQnnloxkiheyUbIIxMs+L9ozulYtBEuFs3
mGEKy9RM5re4JKZ16DnNvnIHztrQ+kbtljvurwc7/5yYvYPv8pZr8VxE0KhyQwTG
y9nrP4/FQUQE2NgFqnX8f3dgvUwaFpMBtMi9V878AFyTaUEicxH2hLgpBJjQTqYG
uUGIyRV/j2lPRd9/8FLZ
=ZTkD
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
