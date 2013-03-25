Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175Ab3CYMGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:06:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32954 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756522Ab3CYMGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:06:05 -0400
Date: Mon, 25 Mar 2013 12:06:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] sound/soc/codec : fix build failure in next-201303225
Message-ID: <20130325120601.GN18316@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.02.1303251950440.20514@M2420>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xTKfHyrFnSV9DG3y"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303251950440.20514@M2420>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xTKfHyrFnSV9DG3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 25, 2013 at 07:59:43PM +0800, Xiong Zhou wrote:

> -const char *arizona_rate_text[ARIZONA_RATE_ENUM_SIZE] = {
> -	"SYNCCLK rate", "8kHz", "16kHz", "ASYNCCLK rate",
> -};
> +extern const char *arizona_rate_text[ARIZONA_RATE_ENUM_SIZE];
>  EXPORT_SYMBOL_GPL(arizona_rate_text);

No, this isn't a good fix at all - we're moving the array to the header
but still exporting it from this file which is not clever at all.  The
user should be conditional.

--xTKfHyrFnSV9DG3y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUD2hAAoJELSic+t+oim9zbUP/3UPOSn2TBvfkYAx2l3dR55a
tS+Z9cHoyv3Y5h+l5sM+uBRjXTE63p0EcNEE/TvcjJpEfLVmiWlmTZbcxgZY7RnF
OEcwkxcDJvoGvofmOKIqX4lOKy1dfpOwFuCSo7cXEFOAoQ8gvTesfG3BPSWgEZex
DRgI9vB1sx9MtlH29f7XTHjUKAMSxfy60nfjFkYPehRtV40HjjChaqv+HIDbAOi6
N+rmKRR/DLvlhbzmjtDNYdL7KAMaZguPkcse9TYO1jLVtetC8z2sL7+6AZTqIxUw
bP1Y1+GCpyDpEPYuu+BOM8yTfuooDGyOpdz7fyFZtk3YJYUCSq0oFeMh5btqq/b1
xxT0byKvBYobizXj6EmV9xzmY2bHWuKOWeGxk9jxdZMeFKj8abBdbCyusOifupdz
RrZ+UjbKuFYwhC7Oagz/jm4aK8mbOqL5djTqKLV8FNz4bRKyon6NUt+C0QUbiOEK
5q/0BEPCh0XvKho2J0vM52lczHTcRAdrX6cM0EgwvgxntYwfqtWMXHCiKM8myklC
rlJk5nIYznLG6SojU3TxdRqqrGURJQirNJbFfJWuXk5adH0wByTGqHqKYA5EjdRB
/Th16OaLqUn0M8Z99Z2aD3CGgWfPQ4kLq7eC+PgRmoQPYiet3Twfd42KiZaqRkBk
lSGL4j+Nj5MPqOFcjySh
=ajYk
-----END PGP SIGNATURE-----

--xTKfHyrFnSV9DG3y--
