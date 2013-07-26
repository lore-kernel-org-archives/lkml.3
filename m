Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab3GZSzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:55:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49378 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3GZSzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:55:21 -0400
Date: Fri, 26 Jul 2013 19:54:58 +0100
From: Mark Brown <broonie@kernel.org>
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Message-ID: <20130726185458.GX9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
 <1374863133-6745-2-git-send-email-eu@felipetonello.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svy5HJxpvdo0k1Cs"
Content-Disposition: inline
In-Reply-To: <1374863133-6745-2-git-send-email-eu@felipetonello.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] ALSA: Added jack detection kcontrol support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--svy5HJxpvdo0k1Cs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 11:25:30AM -0700, Felipe F. Tonello wrote:

> +
> +	/* Update ALSA KControl interface */
> +	snd_kctl_jack_report((struct snd_card *)jack->kctl->private_data, jack->kctl, !!status);

This isn't ideal for multi-function jacks like headsets - it will report
a single boolean value for the jack regardless of what's plugged in
meaning userpace can't do things like figure out if a headset or
headphone is present.  It's probably OK for any realistic input button
since you're not going to get an input button without other things being
present.

What I'd expect to happen here is that for multi function jacks we
create a control per function if the controls are valid.

--svy5HJxpvdo0k1Cs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8sX+AAoJELSic+t+oim9KUcP/iNSWmpjKTxpVfCXLzTil5Tg
WYjTUec5Zn8OduXslLr71ZVMzUyQSJxx63EJ8UIY4EUFkDVyFRS6l8zCF4J1zf+6
n96tPamPsEI2IWHZbV6FV/MJI74LukK/kP/00La9fFJ5cp9VYt/yspzEcuoktRkH
6KiCrVPq4f3eK9hIeRtFr8IUt6EwPXTrJpzrTl9USOaFzjG9ntbzOLYn8+9O8Fzd
/950B4Ns5ncEgmWqe+VUx+CmTnu9w0OqVsVoFe67E5/jp/5N5RiakocOXnrS5v9I
d1YFpslogmK3lsyzJh5ZoFMY0/byA6UZPrBj27D/Tdu0Mrs8/M48H57Dw3TtTnEu
Y9j7cgEI3WtNAeiOf6difpJ9h/xzr9fzKdje/60/b5cBDoHg5xjvlu6MqFQ3PLbo
DO8hdpY18jcoh2l4NSlF4R/rHdlCH6fSQ5Ja33VcERV7C2L27VkMFAP/7nUe2vkt
jKp3rujbWhZBvPpPGljJu1wb1hlo7OiW4HwdmH5O7dkGT1TImKKHd/Bkr5DVAoB1
aZk8ob42gXy8yt6XLrxOEOiQiz3/45rJQYu+5bnMfBgi2AMw76+48W5Py+/rUGiO
nOK7yaLQjQ23Jksb1H30gedVunWY4TAXc3McqO+jV0l5mN/GG8I0Kx5UUjQsXaFC
w9sR++ePBhuScSurVSWN
=nuA7
-----END PGP SIGNATURE-----

--svy5HJxpvdo0k1Cs--
