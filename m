Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaBZAcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:32:43 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51927 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaBZAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:32:41 -0500
Date: Wed, 26 Feb 2014 09:14:07 +0900
From: Mark Brown <broonie@kernel.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: iivanov@mm-sol.com, gsi@denx.de, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140226001407.GM2927@sirena.org.uk>
References: <1392890528-7417-1-git-send-email-iivanov@mm-sol.com>
 <20140225.225528.453119424.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nj4mAaUCx+wbOcQD"
Content-Disposition: inline
In-Reply-To: <20140225.225528.453119424.anemo@mba.ocn.ne.jp>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] spi: core: Validate length of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nj4mAaUCx+wbOcQD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 10:55:28PM +0900, Atsushi Nemoto wrote:

> Is xfer->len == 0 invalid?
> Long time ago I have fixed atmel spi driver to support zero length
> transfer (commit 06719814 atmel_spi: support zero length transfer).

> According to Documentation/spi/spi-summary, zeto length transfer seems
> valid.

>       + optionally defining short delays after transfers ... using
>         the spi_transfer.delay_usecs setting (this delay can be the
>         only protocol effect, if the buffer length is zero);

*sigh*  I guess it is valid, though frankly I'm concerned that this
isn't a good idea - it's certainly not going to work reliably given the
need for every driver to open code this, most of them get the delay
stuff wrong.

--Nj4mAaUCx+wbOcQD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDTHMAAoJELSic+t+oim9GHMQAJnwLSOEmW6vFzbSdhY/V8rb
SXQJ401PW7C+MshPBQwaeKMrOh/t5UJ6+KE682saFAr11BPkC4bR1Qk5T93MN2eC
sYGq9CNCPo+OvTMxDybA9dZzbp6izMjicSdftwNCDr53OeUyIZed/Tvd+HA+kI2g
/C1Zkmaa4//CDvpdWvKWD7pwsy6jJIGKGRuRzs5btQTXeoX3jcgPhUR44n4Jvw6M
NdUgYLVp5vAztKSPohyy+Bjb+yraHHErCiTiQhMzHjvA3ptHWzzjkiKSQ/zXqcn4
IraZ1HhX4ybL9P8oKoxq1yoNGkdPQBKZxRS5w9XLlZjYEeIiVAnVPo6+ocAcn7pk
ztWa66R0Qtnp+FX4K/34G46gvsZS2GkvEG5+1K4CG3Bk9S4t25d0sIY2oXSMIH1o
ZFmcVmwO85+SkkxRGne34Qa/qR9Td7IBBrDXBPI5/R1F18RfWOmmBln9Jyt+bnEW
dxkOGoQ/MBkisxewm1EfKZe9E2s/toCKwF3JCiNtHErpdZMrGiQKIQS4Qsq+o1et
vILBL3JWHxoa1ec+nuUUf/qqG9XVl+46q/QhMV0RP3uvoCgVjZHHM/HgNVYCwyFT
+5KZ6KW7x4Tp52DjUaPhYUliHQGY01HKmKpDzm/Zl4lrtZXTH1CKZYTcq+rg/iwx
yiNy9WZcdHl0+k546d5i
=Io8G
-----END PGP SIGNATURE-----

--Nj4mAaUCx+wbOcQD--
