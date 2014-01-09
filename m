Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbaAIRhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 12:37:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50291 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAIRhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 12:37:45 -0500
Date: Thu, 9 Jan 2014 17:37:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140109173739.GH12858@sirena.org.uk>
References: <1389259148-20798-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0XhtP95kHFp3KGBe"
Content-Disposition: inline
In-Reply-To: <1389259148-20798-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Gravity brings me down.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: fix a bug where cinfo will be NULL
 before using it
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0XhtP95kHFp3KGBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 09, 2014 at 05:19:08PM +0800, Xiubo Li wrote:

>  	} else {
> -		cinfo->snd_card.dev = &pdev->dev;
>  		cinfo = pdev->dev.platform_data;
> +		cinfo->snd_card.dev = &pdev->dev;
>  	}

I've applied this since not crashing is good but it's a bug to be
writing to the platform data at all, it should be constant.  If it needs
to be written to a copy should be being used.

--0XhtP95kHFp3KGBe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzt5gAAoJELSic+t+oim92CoP+gK3qK0bOZ9YnXacD/krxZnI
RtNEDoaPM/1ijp39iTHIukMcA3Dx1DFkcUZeObdI1VLSBHmM8yeUuQ9lFr8l7y4r
pdE+o1El7Xv0wIy7c+O0Q+PYOM4OHo4NksTAceJvicvKKow4hM5xyZKu92WV3g+Y
ktQqKFOYQQAYcQJpjIgQEeLV8IJ0FI2djCrOzO8I/SLh1ht5KM37a6JWQvfghs+U
qJSh0Y5eWz8YpS7vIZp48i6YgmZbmBiLOkK1GG6g7cvMVr1El/LlLSE/gFNQlTbT
zK7L4Lud/yetu0eMgWKnQOdHPeSGNoUukSLVABLo9ry6Kq6pTf9YTn5kKEop8eko
QLZs870Qt2f6RYGHzGVP7IpjA9dDdHVhFnW4yN98GODs7I4ztwJ3zjXelJE6j9nr
pqBZjzkkdp6BP4gUXaVA18+PharMYEngHOzY4eL6OFj9rdEBoiian2NDEkJckpsV
74HEMvUcSI47EtW8uB5AyqTrTeQaLnYpaLmEmemIqGrnhrr/GPKhMwPBvMjIIWro
+qoQ29oXqzLbdURQiqIsQt5UIfo/PpjmA3IVWy4s3EqGSNwu99+nWeUeFbf3EJ0l
hIoTH/2pv6zHI/y+MOlP6bsRWluxI0ND1uzdkLI5dJk9MnujmWcHBXtYHZDbygm5
Kyqec/2g760zy7zzZ+hz
=N4gZ
-----END PGP SIGNATURE-----

--0XhtP95kHFp3KGBe--
