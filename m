Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3KWK7e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 05:59:34 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:54849 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab3KWK7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 05:59:33 -0500
Message-ID: <529098E8.5080109@kernel.org>
Date: Sat, 23 Nov 2013 12:00:40 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>
Subject: Re: [PATCH] hmc5843 - add basic dt support
References: <20131101163523.10fed501@notabene.brown>
In-Reply-To: <20131101163523.10fed501@notabene.brown>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/01/13 05:35, NeilBrown wrote:
> 
> 
> No configuration, just a compatible string and documentation.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
Looks fine to me and it's been a 3 weeks without any negative feedback so
applied to the togreg branch of iio.git.

Looking briefly at the datasheet it seems likely that this binding might
gain a pair of regulators at some point, but we can do that when anyone
cares.

Thanks,

Jonathan
> 
> diff --git a/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt
> b/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt new file mode 100644 index
> 000000000000..90d5f34db04e --- /dev/null +++ b/Documentation/devicetree/bindings/iio/magnetometer/hmc5843.txt @@
> -0,0 +1,17 @@ +* Honeywell HMC5843 magnetometer sensor + +Required properties: + +  - compatible : should be
> "honeywell,hmc5843" +  - reg : the I2C address of the magnetometer - typically 0x1e + +Optional properties: + +  -
> gpios : should be device tree identifier of the magnetometer DRDY pin + +Example: + +hmc5843@1e { +
> compatible = "honeywell,hmc5843" +        reg = <0x1e>; +}; diff --git a/drivers/staging/iio/magnetometer/hmc5843.c
> b/drivers/staging/iio/magnetometer/hmc5843.c index c3f3f539e787..829734a82f69 100644 ---
> a/drivers/staging/iio/magnetometer/hmc5843.c +++ b/drivers/staging/iio/magnetometer/hmc5843.c @@ -719,10 +719,17 @@
> static const struct i2c_device_id hmc5843_id[] = { }; MODULE_DEVICE_TABLE(i2c, hmc5843_id);
> 
> +static const struct of_device_id hmc5843_of_match[] = { +	{ .compatible = "honeywell,hmc5843" }, +	{} +}; 
> +MODULE_DEVICE_TABLE(of, hmc5843_of_match); + static struct i2c_driver hmc5843_driver = { .driver = { .name	=
> "hmc5843", .pm	= HMC5843_PM_OPS, +		.of_match_table = of_match_ptr(hmc5843_of_match), }, .id_table	= hmc5843_id, 
> .probe		= hmc5843_probe,
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSkJjnAAoJEFSFNJnE9BaIBIgP/10EKlKid2t3dLwv3fEEZvUr
mM6e/CfaTM41U9iHY6/MZ06EHw+3AIlUEj7VrwtVaYBuOxA7QGdjlRS7LM5MGHfd
+W1LCk4x/vtdE2nr0VpeaNzV9vkok/HayDj/GiBhRjTLC0GXTUPv+mrvPL+XsCOL
RlGKOUiQmrhNbHje4hSyrtcrRtiQ25VgEef6XMo7QhL2plcEBLH5WA6sP7+aQZ0S
+OLNRZ+0s/nlh23nnlvqRSSl24r+N5HbSkicmUXN6G4IT0LB/MIA/t6irA6eGAws
6DEm/Syz62YV/j3N5vZLHtofXeDiYLM6hWHXwvk+Q8XJc7euZ1Mz7r5EA1ZGYNHJ
5GTBRma1uo1+CfrvZgJWagI70fPiKV6FMRME+mpmyX1NkYKe2VlL9CCtAkx53qfa
joZ5FDc2IU1IL2O9YNtBu2dgxOeQOTBr3K5cpn4gY2oFxDetOQJRvArbcN/j/PHv
wQesd2HNrqGpwVRI3HN70XPl8dRTU+Jl2tFVv6hON+1f1nD7qFGo/LCyWBCppQy+
5tDwNaLPFdjGNY5OQHx41WRfL0ckVyqmCd5y2za7FI7DDjUi+zJ4/e2lCqyFqr4t
dN5mjRM7ZPopL+zb/GYAClea0XrzKkh4REaRfrH14/tU2ba5DlSSqgdHDjc8jiU3
HWL7Qy9UI6jzBt45yAsv
=ZOuh
-----END PGP SIGNATURE-----
