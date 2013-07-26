Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490Ab3GZSqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 14:46:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46941 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3GZSqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 14:46:49 -0400
Date: Fri, 26 Jul 2013 19:46:44 +0100
From: Mark Brown <broonie@kernel.org>
To: "Felipe F. Tonello" <eu@felipetonello.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        David Henningsson <david.henningsson@canonical.com>,
        Wang Xingchao <xingchao.wang@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>
Message-ID: <20130726184644.GV9858@sirena.org.uk>
References: <1374863133-6745-1-git-send-email-eu@felipetonello.com>
 <1374863133-6745-2-git-send-email-eu@felipetonello.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OwzF8Z6mNSRrgR5"
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


--0OwzF8Z6mNSRrgR5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 26, 2013 at 11:25:30AM -0700, Felipe F. Tonello wrote:

> -	snprintf(kctl->id.name, sizeof(kctl->id.name), "%s Jack", name);
> +
> +	strlcpy(kctl->id.name, name, sizeof(kctl->id.name));

This looks like it'd break existing users unless they are updated to
remove the "Jack" from their calls?

>   * @type:  a bitmask of enum snd_jack_type values that can be detected by
>   *         this jack
> + * @idx:   index of this control item
>   * @jjack: Used to provide the allocated jack object to the caller.

"The index of the ALSA control created to represent the jack.

--0OwzF8Z6mNSRrgR5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8sQRAAoJELSic+t+oim9Qj4P/2UWJakMQok4rDbjsSMeZYpV
PdT/qiGagpvBDu7vZ4qgzSs0ryTw+TOby/9oGCw/XmQb867MFyvgxcvZN4ai/Dqk
YeK5GNGPdZRII7Zlt8rKr+Y14mlSAy4bgqjPJ9HaDMZdHICpLBvqGf0sY7US2wuS
VzbItTcZiEjRVfjb4IgTPReriQ67/8tq17WL4qiEK0jyUmPn0gFwbpWTRxOrujYr
FZm3/XEH3l1avkC4iy4pDwVQM+FlkPMU2051qHWYjoLa8mUUiB+NFZDB212ZLgIT
F76EoNB/aAfJDRnQJtPKm2fY1SyYTqHdwG760wEKtGUQIhEtBsgkCZKvfRwIRGBU
1pJNtFyW8QO4QqM93VkXpRusKkwHQRinYkL0cU8z43dsPqhOtknkVRQNvRSTUBn2
q/n8uTqbZmMMFXo7JSz+r0K0prJB07H9KOOgTGWJrxNcql+VGS4X+t32Kx5UGCc6
WhH12fD4mKIBllpqnocwfgeJNwG+KkxhMybInjw3PIf/YE/oUlCG3MbxIfRK9YzN
yGsi0mFXCGLGa1DVYJbG9HAP/cD5O4ngO0WyT1x53lXpXB9C9Hx8bFVUjEWBg0EF
d5EeT+I+cDSHQ+Mz/8o63+hA+UHYx1ul/6meJosPR4LjFg4K/aIy1x75d4q0gWDr
Dg8vi8rgALqiiIdJyX48
=LS6V
-----END PGP SIGNATURE-----

--0OwzF8Z6mNSRrgR5--
