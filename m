Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaEABeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:34:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53429 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaEABeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:34:17 -0400
Date: Wed, 30 Apr 2014 18:34:02 -0700
From: Mark Brown <broonie@kernel.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140501013402.GL3245@sirena.org.uk>
References: <1398854171-5187-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VBq/nvTu32OVLBUP"
Content-Disposition: inline
In-Reply-To: <1398854171-5187-1-git-send-email-ricardo.ribalda@gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Fix hung task timeout when initialization fails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VBq/nvTu32OVLBUP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 12:36:11PM +0200, Ricardo Ribalda Delgado wrote:

> Since "786235eeba0e1e85e5cbbb9f97d1087ad03dfa21 kthread:
> make kthread_create() killable" kthread_run can be killed by the user,
> ie, by killing modprobe.

> -	flush_kthread_worker(&master->kworker);
> -	kthread_stop(master->kworker_task);
> +	if (!IS_ERR(master->kworker_task)) {
> +		flush_kthread_worker(&master->kworker);
> +		kthread_stop(master->kworker_task);
> +	}

How does this fix avoid racing with the task being killed?  It will
improve things but it doesn't look like a full fix.

Please don't include entire backtraces in commit messages, they're
typically extremely long and don't really add anything - edited
highlights are fine but try to keep it to the point.

--VBq/nvTu32OVLBUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYaSHAAoJELSic+t+oim9cWkP/RvEEcO5MkmGT1xMDytNZYw5
1eL1ge0U0ITDEVXI0cOaWy/NN8B/sjWtnmQO3Hunl8HQ51XNddYZh3hFKSb/CJEG
V1ZNjgi7mGGOSmRBAY68bHGFedqWg1pdrjD42njrvFcIhvqqJP4E0M4B3mdKmPbC
SfabJnUqwNVr4dE7+mv2PDxRMlantvHUZPYazeXvBicy/TiXmGnadV/C5prpivDw
vR2HButVHKfpUuK6dFGLFyAJX78AeEkciU9pD/jP5qTF/OMlJklinkrHl2I8cyQK
X9qV7VnKf2vIBea1pWAwgrJ5OTM6BSnr0+gAg2HGRYHKeayOnmBJmWKpwwxHNU7T
aH7m9kZlox/jzazltn3uMbOCFBTCVAeVi7jHrVReqlkowJra7kRJjSri8IKFXdrI
6C/U+rKGpOwmR8I9oDhuAhyYUbGl2nyLQ8cYJ47ytOHKAn7e4SwQbK4rbMsr4v7l
80u8loF+TfGfL83hCoojteFo/OtZVEGRthg2QHUwDysNS0m6KKSMJZQzGQIUgGrX
swR0N7uE5V0Y+Sg+gljPTOqzQIzDI78v3khO9GafSjma829eJxkxOU6yvr/De9Zg
ycKxNrRNZnvIxTbv52+K7CZaMjvM6ngulyPyYPJcPaGWNt8SG2Z5Eui2nAgl2I/j
t9sdLq65V0NwhtakjR8q
=uwyI
-----END PGP SIGNATURE-----

--VBq/nvTu32OVLBUP--
