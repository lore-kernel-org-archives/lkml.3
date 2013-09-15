Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3IOMsQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 08:48:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38517 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab3IOMsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 08:48:12 -0400
Date: Sun, 15 Sep 2013 13:47:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130915124744.GW29403@sirena.org.uk>
References: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <87bo3whjz4.fsf@linaro.org>
 <20130913145022.GC7393@intel.com>
 <20130913173149.GE7393@intel.com>
 <87ioy4e8bw.fsf@linaro.org>
 <20130915064139.GJ7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lwf1fPv9TmaSLgy"
Content-Disposition: inline
In-Reply-To: <20130915064139.GJ7393@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6lwf1fPv9TmaSLgy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 15, 2013 at 09:41:39AM +0300, Mika Westerberg wrote:

> There's also a less intrusive way of fixing the problem we see with ACPI
> enabled I2C devices:

> 	1. In I2C core i2c_device_probe() we power on the I2C controller
> 	and attach the client device to the ACPI power domain. Just like in
> 	this patch but we don't touch the I2C client device runtime PM.

> 	-> This should allow the existing drivers to keep using whatever
> 	runtime PM strategy they have chosen.

There should be no explicit need to power on the I2C controller if it's
implemented the same way the existing ones are - just have it power
itself on when it is doing a transfer.

> 	2. For ACPI enumerated I2C client devices drivers we need to
> 	implement the runtime PM in order to save power (otherwise the
> 	devices will be left powered on).

> and do the same for SPI devices as well.

> Then only thing that changes for non-ACPI devices is that the controller
> will be powered on during the client device probe (well, and during
> remove).

> Thoughts?

This is definitely less intrusive than the current proposal, there's one
ACPI I2C device binding queued for -next after the merge window (rt5640)
which will need an update.

--6lwf1fPv9TmaSLgy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNaxtAAoJELSic+t+oim9iGIP+gJNvCGQL2nGQa0PWny5Bj4Z
omeCY4D3U/+1ClYHr5UfzoOMRhzlCsYwkLSYMz2Q8U+ce9zQq7SZjGxDdp6wKwfD
NdtU6RUMoF/uQ31A20bhjnDIAjLi45ZHXICRnlzmlTCopD7bqhyvyaglKOQlJLp7
Xm4Yt8+j5GlLbDLNZXxqoS6rRDUzYFuuF77RBibI8e38iJi6IKCIQFTvlHWO1nI/
dbQJPjXBStreCcF74o8mBWxO9advbVZ3VBcsNiSkHJmnLJovcJbDNWC8Y4RebPL6
UDUj+jxPPVHRCCDBdNWKoSXl6yspTI30hKfO/RhwrbL0k+31Elx7orwwuYlf1715
LPGooEkJgjWANsZ3cqbm7fvVr7COC6ITBdErM78VKx6FkMJmMP2BeKV41o8FYpyh
P0kt8IskoM/3HPOQFYR1Bpi4z6IEJkKLJ0hleclG9YFb4HHRAw99C5ITJz93wtpw
kU7cyucXdhmH7IQFw2/3cwMnFYmcdOYKnneynMzi5wSe8sCx46ymgGiRkuf9yflW
zNsDomePdmFNMGQ3uJCsRYjeFQkV0+2kl4J4KwQtV8SnZeukrokjZEQrbPm0Ckqt
8luGt9Kv6GoIhaLuwFGZd+0KyDyAYtZwUQA7GtWDDNs0Eb5rwLv+z9LlNC24cTZj
jXKX948f8uDI8ctALQ0O
=drge
-----END PGP SIGNATURE-----

--6lwf1fPv9TmaSLgy--
