Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbaCSAAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:00:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55550 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbaCRX76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 19:59:58 -0400
Date: Tue, 18 Mar 2014 23:59:41 +0000
From: Mark Brown <broonie@kernel.org>
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
Cc: <lgirdwood@gmail.com>, <perex@perex.cz>, <tiwai@suse.de>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Songhee Baek <sbaek@nvidia.com>
Message-ID: <20140318235941.GT11706@sirena.org.uk>
References: <1395186692-11735-1-git-send-email-aruns@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jF5TAc7w0HgrN+Xd"
Content-Disposition: inline
In-Reply-To: <1395186692-11735-1-git-send-email-aruns@nvidia.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jF5TAc7w0HgrN+Xd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 04:51:32PM -0700, Arun Shamanna Lakshmi wrote:

> Currently soc_enum structure supports only 2 registers (reg, reg2)
> for kcontrol. However, it is possible to have multiple registers
> per mux. This change allows us to control these multiple registers.

I'd want to see a user along with this and...

> @@ -1093,6 +1093,9 @@ struct soc_enum {
>  	unsigned int mask;
>  	const char * const *texts;
>  	const unsigned int *values;
> +	unsigned int *regs;
> +	unsigned int *masks;
> +	unsigned int num_regs;

...it duplicates and generally isn't joined up with the existing members
of the structure, and has no support in the helpers (for example,
converting the existing stereo controls to be two element arrays which
I'd expect to see).  Helpers would count as users here.

Note that we don't support double register enums or muxes - only
numerical controls are supported.  It's not clear what a multi-register
enum would mean.

--jF5TAc7w0HgrN+Xd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKN3pAAoJELSic+t+oim9X90P/juLHAIf9XoQvk30A3LBxtCu
cIU14vx3hoogOSinsRae+wah8Srhjgr/LYGw8CV1pEOL1r6tFyqt4chIrBB6gzxc
1sVAOpsjWqvhzGON9bAvzaoa6ZLeWWtrlpMpFxX2b8v1/pAqHspp+zfJIVLX/tS9
5z/9PWX49rWlgNXqwDFNGGQ2/rS8QSduj0qqzAAHGpOQvf4t/MY071HW/lPiqh0d
Cw0r+/bI500Y2yhpURqZTmUAAp8pmVup2jJ48Pg0F/fauNot7bQwjzeHlcqFEnS3
pRUUZILdSKBbUA5aALRhxbs+KHQcpZaJjZsDAiAZQ7Po8W92fu7WvRsr1cAa300+
86/LcNfXF1EAHXBlpEqVFwe4oBtiXKmsGdG4eGjTNwZhIjHWh1FVM4nCOqe6yJB7
2xRnHVaHHrn0Uj3lbyt1zXK+ta2BMEDFv2kTMSr2pt9CqQkVyN/NGmOowQcJw0VF
iV/eHxeHtWfAl1WkTCTE6IJI4A+S0vHcx/puPfkOjyxBV2SUCPi7Rd/C/m+DQhjt
hv4yk9lvHVzlIpqWFR/HVJtx8KGsTHkfcMQRFxGcauYZGeYfiyU3m3JShVMZQyRR
SNhSgGs9vlf0aQN734YjxEGvJ2hJFsJoSI+Vyzi91YTn4uj5oDV3AP5O2uYY7op+
URLCfkLzVEWISLt6nNDe
=rwRq
-----END PGP SIGNATURE-----

--jF5TAc7w0HgrN+Xd--
