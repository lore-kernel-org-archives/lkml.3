Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbbAUWjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:39:13 -0500
Received: from mail.kernel.org ([198.145.29.136]:39638 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbbAUWjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:39:05 -0500
Date: Wed, 21 Jan 2015 23:38:48 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        pavel@ucw.cz, myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH V3 02/11] power: charger-manager: Use thermal subsystem
 interface only to get temperature.
Message-ID: <20150121223848.GI13715@earth.universe>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
 <1418979323-7188-3-git-send-email-jonghwa3.lee@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="7IgncvKP0CVPV/ZZ"
Content-Disposition: inline
In-Reply-To: <1418979323-7188-3-git-send-email-jonghwa3.lee@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7IgncvKP0CVPV/ZZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jonghwa,

On Fri, Dec 19, 2014 at 05:55:14PM +0900, Jonghwa Lee wrote:
> It drops the way of using power_supply interface to reference battery's
> temperature. Then it tries to use thermal subsystem's only. This makes driver
> more simple and also can remove ifdeferies.

this breaks allmodconfig, since CONFIG_THERMAL can be built as
module and charger-manager will be builtin:

drivers/built-in.o: In function `cm_get_battery_temperature.isra.4':
binder.c:(.text+0x2f4008): undefined reference to `thermal_zone_get_temp'
drivers/built-in.o: In function `charger_manager_probe':
binder.c:(.text+0x2f62c4): undefined reference to `thermal_zone_get_zone_by_name'
Makefile:917: recipe for target 'vmlinux' failed

-- Sebastian

--7IgncvKP0CVPV/ZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUwCp1AAoJENju1/PIO/qaszMP/inSp4NXj4AusZcAjI6aIk4i
7DxA5TcIUSWn/qKcXwVjythTlHRd3I9UhyTJdN3++QPLQFNcpJ7tQ4MNMzMVI1s9
6P9oN2iHeGPM4U4TXxrbcZDvyZYhEkvTN7djqHBQvV3cszUNFiO33pR99ohw8+l2
2j8BpIWXtwnjZSMvjdSXjTfhd60BgoUcQ1c0exbA0xaTZygv3OE6OdUQSdDbIGG6
YJrfaXkAtPOvwIqv7UG5CPL8wUCqbBgb3Q4kqg8QoBrWqIJ21gsXtJTNi9pNLpyp
R6QVKg5+ByXaD5I6iJJdIMs1m1wpqdwqe+bpsKtJPPMSa5a9eFXSnMAeSypPCp6d
BBu5xkZ6cnU8X7iowNZulMx7tD+JYX72hudwJT0BxSAbq+PWZh6G8ST9tWSl/n1L
H3fmDmbvWOv3pdfD661dzFbHQyqLb5oG7eocxAnyAT41bAXlbVYOKqxuA3fb4eIw
KG66Mx2clZ4cwmXs0K4hgENpZc/dbU84j5GwuIZ9zxBlfMyH0Du0+ydFdDd/yFWi
3aZMsWugbJhRjhDUZM3bGiTL2bpaxTgDsqQK9HDML4A0HEsK4qvYSeJkscO4V34t
oH70XgUwl3lvQdS4NdsUQeIvHbp/9vpEcTh9R1ZXpKrYTiuFcRBpnUkWKiCs5SeD
N30u8ZNvLkSWnT1UG8Ve
=x//c
-----END PGP SIGNATURE-----

--7IgncvKP0CVPV/ZZ--
