Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750877AbaIYEWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 00:22:16 -0400
Received: from ozlabs.org ([103.22.144.67]:58169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaIYEWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 00:22:15 -0400
Date: Thu, 25 Sep 2014 14:22:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: linux-next: build warning after merge of the battery tree
Message-ID: <20140925142206.5ebea1eb@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mKdjJXhf2Ek4L=9Ux=sujuu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mKdjJXhf2Ek4L=9Ux=sujuu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sebastian,

After merging the battery tree, today's linux-next build (powerpc
ppc64_defconfig and x86_64 allmodconfig) produced this warning:

fs/sysfs/Kconfig:1:error: recursive dependency detected!
fs/sysfs/Kconfig:1:	symbol SYSFS is selected by CHARGER_MAX14577
drivers/power/Kconfig:327:	symbol CHARGER_MAX14577 depends on POWER_SUPPLY
drivers/power/Kconfig:1:	symbol POWER_SUPPLY is selected by HID_SONY
drivers/hid/Kconfig:649:	symbol HID_SONY depends on NEW_LEDS
drivers/leds/Kconfig:8:	symbol NEW_LEDS is selected by SENSORS_APPLESMC
drivers/hwmon/Kconfig:299:	symbol SENSORS_APPLESMC depends on HWMON
drivers/hwmon/Kconfig:5:	symbol HWMON is selected by EEEPC_LAPTOP
drivers/platform/x86/Kconfig:496:	symbol EEEPC_LAPTOP depends on HOTPLUG_PCI
drivers/pci/hotplug/Kconfig:5:	symbol HOTPLUG_PCI depends on SYSFS

Caused by commit e30110e9c96f ("charger: max14577: Configure
battery-dependent settings from DTS and sysfs").  Consider depending on
SYSFS instead of selecting it ... or maybe making your driver work even
without it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mKdjJXhf2Ek4L=9Ux=sujuu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUI5h0AAoJEMDTa8Ir7ZwVt3gQAIWb8K9NsTpnFveIUt1pzYeB
jQm3uJddM59VMPUWT4t19NPmhzk59nExa3r3RpmpNNqg/3I6TH28ixV2elF+ccCt
fCbhuFQd+rBnSYrVFiDbHawqTSUFF+Fjsnw9vym9c6g6u7u9CNETUKYfkGy6ngub
0t4e3650mTOoY0orhnx9nHP7llvMVLoxt8VZoJFiZxwPSzvzcD895P0ZhNZ/r+x4
LUbU+0aNDnYyz9WVc0Cx+6bl8BfWjdEOIHmSBm/dNnXy9qLUUCNhXnXLMFsFjWR0
84sp5d0fY93V8rksBfSQanGFdIaFUviaG+NBU6bjpAzSH16OI9bsouX3xtnSRYIE
h5U4YRUZQEJlsMoYgaoJTPc9jMS+nhA9O74sevv4cYs4/lQA7z1u0xL1iCR1e4zD
5BCTYQT6LPcTTi71SRHukFYmp9J+Q46zjZ3mW74X+BghcOx2wO4IpqG/s929XoDX
RWiD6h8bN77AtbUFJ34iyK+cP1lJT1jZqMrAx+IUBLc3SYFgpzOAKaubym5YMQ3s
bi9NyZtPnux36rLIOnOY+K9KV9oIKj0bi9fuaKmYaPu5XEYULv3T2c3/o/YVG1V3
PVS6735mnj/Y78xEplkF+H3Nd66ESElZLqW5fWAeoVssXOa/wD5wmuvaVmVNHDmE
h91ZVRTKlTh0YCQXuYc5
=oFTN
-----END PGP SIGNATURE-----

--Sig_/mKdjJXhf2Ek4L=9Ux=sujuu--
