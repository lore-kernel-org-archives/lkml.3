Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbbAMLmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:42:52 -0500
Received: from sauhun.de ([89.238.76.85]:35152 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbbAMLmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:42:50 -0500
Date: Tue, 13 Jan 2015 12:42:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        u.kleine-koenig@pengutronix.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v5] i2c: rk3x: fix bug that cause measured high_ns
 doesn't meet I2C specification
Message-ID: <20150113114237.GC7660@katana>
References: <1418277650-25215-1-git-send-email-addy.ke@rock-chips.com>
 <1418295760-19639-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <1418295760-19639-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2014 at 07:02:40PM +0800, Addy Ke wrote:
> The number of clock cycles to be written into the CLKDIV register
> that determines the I2C clk high phase includes the rise time.
> So to meet the timing requirements defined in the I2C specification
> which defines the minimal time SCL has to be high, the rise time
> has to taken into account. The same applies to the low phase with
> falling time.
>=20
> In my test on RK3288-Pink2 board, which is not an upstream board yet,
> if external pull-up resistor is 4.7K, rise_ns is about 700ns.
> So the measured high_ns is about 3900ns, which is less than 4000ns
> (the minimum high_ns in I2C specification for Standard-mode).
>=20
> To fix this bug min_low_ns should include fall time and min_high_ns
> should include rise time.
>=20
> This patch merged the patch from chromium project which can get the
> rise and fall times for signals from the device tree. This allows us
> to more accurately calculate timings. see:
> https://chromium-review.googlesource.com/#/c/232774/
>=20
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

Applied to for-next, thanks!

I fixed the typo Doug mentioned.

Please send new patches as seperate threads, not as a reply to the old
patch.


--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtQStAAoJEBQN5MwUoCm27d0QAJ0C0cXADG+xa8Ne8Bm5HLpn
tLSC1zy2GCk9ykPqU3o0KMmjibA7XbfCx9wEYVTHgBG0KAO2K4oWPnlCxfNknoDt
U5pRpIG4/TJhcV0bOXw7c6zKfX7tHUukynNMbpo1C5/w8UvzPGlZoFqkOSEO1UGh
3BYpNk6+6AbiX2myndAbfKheb2zqV7dghdvS8WUYnn8o59VYluJT2FvLKCDdMPF/
ohIFcEwmTxW7AqpjalgBwg3tE1MIlqwCr5BeIV+7iR9hHzpJ5zQ5bLXOYw8V2iQW
iQHeNAL/ApVERfQxOTPwm2dBvt2WjvJ5r19BnpwmRtjU2wNfzEkFE89Pei6XeBjN
2WqJ8w6dMSkacjRNyDVgMTtlQi+kKCvGPfaI1pdAN/W27Y3Cm2wtn9tDF4URY2YI
8DT20EBjt9U7ve05sbR+HIiyHc2dldRh4p+7bTKt+oL/VftYp+fI6dWuNs3tTu8K
ZPnBUvkbK+ta5XeCTDD+bTVh2as+fTJU2cH1aiQRJo6vy2Qui7mdJ3N0RTdMsgQ/
vp7ijglIDmA8Bz9AKbPbjcZEOPx8GEVus3rIcCL+2T9fxmgoqoufUQ7WRVM+LlRk
QYeFBwi8ew3Y5xFTNU/ESvC8fn6PI0hqBXvQTdD/ZbG87L3qT+ve15iBT7ytzUmu
ghV4ncW3ytJ6LRQ0CboB
=K/FS
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
