Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbaCMTY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:24:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41026 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaCMTYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:24:25 -0400
Date: Thu, 13 Mar 2014 19:24:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140313192417.GK366@sirena.org.uk>
References: <1394697961-4440-1-git-send-email-k.kozlowski@samsung.com>
 <20140313141317.GX366@sirena.org.uk>
 <1394721184.20773.15.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SDQiEKxzCZ35UpgS"
Content-Disposition: inline
In-Reply-To: <1394721184.20773.15.camel@AMDC1943>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Set data pointer only on
 regmap_add_irq_chip success
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SDQiEKxzCZ35UpgS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 13, 2014 at 03:33:04PM +0100, Krzysztof Kozlowski wrote:

> Yes, you're right but still I think that 'data' should be set in a
> atomic way - only if regmap_add_irq_chip() succeeds. Usually a caller
> passing a pointer for allocation expects that one of:
> 1. Allocation succeeds and it is put under passed pointer;
> 2. Allocation fails and no one touches my pointer.

Yeah, I probably will apply it but on the other hand nothing should be
relying on this - the caller is just plain buggy, it's not really even
supposed to be aware of the existence of data in the first place and is
doing the equivalent of a double free.

--SDQiEKxzCZ35UpgS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIgXeAAoJELSic+t+oim9HDIP/3jmR+ZH4oPvXpu8QogrzuGa
pTIXQHZDeAvT0mCpOPIpzhcRlFlg98qg5QkBjOea7EywJTpNh8c2emwbTFc8S0w+
OccmWznSMPZfGi7ytnfWveBnJxzx3IF83o+d0PGdwd8C9qu7W+0eTxZnW0axV13r
yrfGWRV3hx3c1WDObimfG0stc09S4ZGTBleVhx25VfdBuod6PU2aorFLw/g1wjnM
s3njHCS68vdi4LV6jMiR/GboC0Ro3JebSZo28a4tudSkWWb1vvwNiUxDY9fhsIWR
ZBX/baZtikgHNVm3k7c6cxezdtjxvyGXrtVbVvf9qerQdEwAsqqhpZkMN0jhdkZE
jf2dMWCpTdK4nJR4jxMh+Vs3qUxEzcHR0ljKoONDywJMqVVEbd049iVsTH/YvDVE
9Rx61/72+cutEDlnKz6npB9nLYUbxfx3XdkRXU+/U77NYdn69QbCs2Q8pYjYuW79
HqSKOY4d5HWH8X52aOg4kJ/IE5Zq4FrPW8eQfaksnUZ0vCM0RDeKjNhZ0iz/cUbD
5OFbpqQMIGtNEJJ5pmQod80PXw7OBEORGhmnCg/qDg6RXjI+mb+DWhj0kfVjXGSS
Rbg8Em25Ds+xpHjYlNXMNqOcXR3hE1x4UjyiGdNOxfkv+Mn9g+mS2TWVmRBb3DFs
bEyKVlPUB6sn5r6xQ7GP
=pAz3
-----END PGP SIGNATURE-----

--SDQiEKxzCZ35UpgS--
