Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3IKJ4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:56:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51841 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3IKJ4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:56:13 -0400
Date: Wed, 11 Sep 2013 10:55:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org
Message-ID: <20130911095552.GI29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <3397524.g9aUWuArnm@vostro.rjw.lan>
 <20130910213522.GG29403@sirena.org.uk>
 <2029393.u6DaKBPszu@vostro.rjw.lan>
 <522FC0DC.9030708@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A1AeHK3WkQzeMGLU"
Content-Disposition: inline
In-Reply-To: <522FC0DC.9030708@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A1AeHK3WkQzeMGLU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 11, 2013 at 09:01:16AM +0800, Aaron Lu wrote:

> Looks like, it all boils down to how many I2C devices should be allowed
> for runtime PM by default and how many I2C devices should be forbidden.
> , and then we allow/forbid runtime PM for the majority case in I2C core
> while individual driver can still forbid/allow it in their own code.

> So if the majority case is runtime PM should be allowed by default, I'm
> also OK to not forbid runtime PM for I2C client device in I2C core. My
> original intention to forbid runtime PM by default is to make sure no
> adverse effect would occur to some I2C devices that used to work well
> before runtime PM.

The really big problem here is that there are I2C devices currently
using runtime PM quite happily and forbidding it by default will break
them.

In general though requiring userspace to manually activate power saving
features isn't going to make people happy.

--A1AeHK3WkQzeMGLU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSMD4lAAoJELSic+t+oim9MKAP/jfLtDWtc+xh1vePSJpB1iDP
6FDiNmIpxf9Sa4o7J614lrEwB8FkBH2fhWkJXZVPsZZ0tI3n75uXfasJmwxDH9Cm
mfPK+Xl7gxss+qiHL/vhlGe2k+ti1bE7wprEE1MXZpGbgCuXPgvRyaZvpzMabqyF
DHiRqr/dVwaBIwNveMaaiwTLvbT83V+/MWMYCzVUl2xQ1LoDx52JsnyBDy4oLAWV
SimlDwDY4kHZP+mRoR5kZlAkNeKpHkGktJBQHvt3oyrXn9MzMQ98LlzXhL9X6jW/
2sP2t5pDf24Ch8WISUOHsO27Jybjdy2ZbRfhugLsGG5mMRjuqxliU0sHfrT5TIDU
nzXgIeIwPueLNiw5soFmbnr4X2wa8N/EoIxrkdS34lS3Zd45n3tXDOW/UsCKP2lZ
CZHcJqCbwxGGmBpwtqvs9OYC6bTtUUFzan2Dj7lZfmFSa2HtjZzHvVVXkBOQUFF9
8SMvjjZhFspxYP7vGGPdotxIoakWMwkkUTBZ9JiKTwyqC79f3a+TJW7UCCdj4Qwf
WzHASdUMu/sI8WburE/aUufuysVKWACcdzFkgX91u/b3Wn9NYdz5sAhm+rxWgmMu
xdq1sl7+hEuKTHO3og6mryoKDI80EgZXCsM1MBQe32cvhyuehCdAeG88q95XiGS6
WB1/8/y8XSVVUebhafYX
=SvlW
-----END PGP SIGNATURE-----

--A1AeHK3WkQzeMGLU--
