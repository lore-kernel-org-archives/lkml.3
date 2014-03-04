Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbaCDE4k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:56:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55106 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbaCDE4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:56:39 -0500
Date: Tue, 4 Mar 2014 12:56:26 +0800
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140304045626.GK2411@sirena.org.uk>
References: <1393398414-10822-1-git-send-email-peter.ujfalusi@ti.com>
 <20140301003320.GA31852@kroah.com>
 <53143CD3.30209@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bIUMYB+SOIcERsee"
Content-Disposition: inline
In-Reply-To: <53143CD3.30209@ti.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivercore: deferral race condition fix
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bIUMYB+SOIcERsee
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2014 at 10:26:59AM +0200, Peter Ujfalusi wrote:

> I think it is correct to detect this situation without the need to have non
> related drivers to be probed.
> The patch is doing this exactly: detects if we had successful parallel driver
> probe(s) while another driver was probing which ends up requesting to be
> deferred. We only try the deferred list again if this condition has been
> detected, we do not loop on the deferred list, we do not try the list again if
> there were no other drivers loaded since nothing happened which could satisfy
> the driver asking to be deferred.

It's certainly the simplest approach I can think of - anything else
would seem to involve looking to see if we're running deferred probes
and trying to add things to the list while that's going on which seems
like it might be hairy.

--bIUMYB+SOIcERsee
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFVz2AAoJELSic+t+oim9xxQP/RK9qdsZqc+lKT/a0mic79qb
QWkSgT1gxs+c4MFLLcjyETVfTu5pgQc+97kW8xVGm3a/gvr1eJtDfBqIEt0JI7lF
qIXtIJ5xlCSMbUi8qMGTf3WFqdriBkJtZ4RiGSGTZLkO2FVmJsxir5d4/1Eix9zQ
QYNif+CjAaA8dlb2MN+q//ozhdAkhBZEvdqqYAO81iO9r3U2CtAkl6IgnB4JSrg0
aCUswU4gG0fGrNLwFmayEXEywAiwRiLV94R/ebxBgxFyd3HrJ31Hspqn+EhJXFRk
fZDEKGUO09H0a2FeE6yLPE02WT2S6bz0f0pAeEg2nujdp1+DK4iiPhfZg0WlSGZe
izQoGRCqS5wIlqAIl95Vqcv7zTLvr139OsDMyfcIWE6FraBUEK1Cfon04uPFn0fR
f6AMVWqYhaKdHM3f8fs/c0qmPhPARMOpuqZhse+tDd9PGWZs+S87du9yLiWtjs35
9mnL3g00azs5RuvFb1/tBCXyVuH9eNDig6qLWuQ2OINym8LKo8pe9l/PGDm2/bnp
nVO2R8qelsvBkfT1I1uaGcoGbY48c2XlDutqEE95YfGvEh4UH90vViEzZfYbnzaU
u985h/UNmp4jPLj+RXTR6FRlMnf28scdeozbC9/SMUkJmZ8+icBJpFQMzlHANQdP
7h+1yYeUQYPJQEcfhc8W
=xBd7
-----END PGP SIGNATURE-----

--bIUMYB+SOIcERsee--
