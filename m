Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934592Ab3FSKMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:12:05 -0400
Received: from sauhun.de ([89.238.76.85]:46669 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933966Ab3FSKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:11:48 -0400
Date: Wed, 19 Jun 2013 12:13:49 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
Message-ID: <20130619101348.GE2950@katana>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
 <CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
 <20130606212620.GA13620@bingao-desk1.fm.intel.com>
 <CAHp75VcGUtWyPHrvYDW59-4g8F2m58-Us3CrbJ2bnYJdxnd1Sg@mail.gmail.com>
 <20130611171119.GA35135@bingao-desk1.fm.intel.com>
 <CAHp75VdZA_gouZohD1J+o9ybpXVLLQH=D7QDo9OznW93iBDZpQ@mail.gmail.com>
 <20130614190003.GA19617@bingao-desk1.fm.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/2994txjAzEdQwm5"
Content-Disposition: inline
In-Reply-To: <20130614190003.GA19617@bingao-desk1.fm.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/2994txjAzEdQwm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Even you prefer to extend v4l2, you still need this helper.
> The idea is just to move the unregister/register from a specific ISP driv=
er
> to v4l2.
>=20
> I think you misunderstood my pionts somehow. Let me clarfiy a little bit:
>=20
> Current solution:
> 1. Platform codes(on top of DT/ACPI5/SFI) don't call i2c_register_board_i=
nfo(),
> instead, prepare a table(kind of platform data) that has all camera i2c d=
evice information.
> 2. ISP driver registers devices listed in the table to i2c core - this ma=
kes sure
> v4l2 takes over these devices.
> The problem with this solution is that when a camera device runs on both =
ACPI5 and
> SFI, the platform codes will get a bit complicated and it's difficult to =
ensure one
> binary kernel runs on both platforms(ACPI5 and SFI).
> (To extend v4l2 with this solution doen't resolve my problem)
>=20
> Solution I'm suggesting:
> 1. Let the platform codes call i2c_register_board_info() anyway.
> 2. Since ISP driver knows which camera devices it supports, so it simply =
unregisters
> those devices (get the client by the introduced helper), then register it=
 within v4l2.
> This solution ensure one binary kernel can run on both platforms.
> (To extend v4l2 with this solution could not be feasible, the device tabl=
e is
> ISP driver specific, not v4l2 specific)

I also wonder about the need to unregister. I have to admit I don't know
much about I2C handling in v4l2. But if it requires unregistering from
i2c core and registering to v4l2 core, then it sounds to me like we
could check if there is a more fundamential cleanup needed? Deferring
for now, looks like an issue worth looking at, yet there are other
things in the queue first.


--/2994txjAzEdQwm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwYRcAAoJEBQN5MwUoCm24KkP/1b0xk7snx8weFq6qCZc9uxH
VfytzjWIEsnwv6obOPXi+9VlXxGaqCpy/W0jNJJPw0ZKMbZVUREXmemceL7hXXH0
eQqtUIu80n2VIdQ3RF6u58+Tz/ekm9ap5ivy9JLB0ySJJ2VuzYB+5ahEjKmvk0Cl
kz3TmXVlzP/2l9QlMUBzUcESrpAibNWd/wgRZo0tzWN1BAZ0ZaNJPZNGNvtkuMJc
FAuPnKEzDmUgFooq740s0iODkvxKsqFTO3Jd0vGgTItiJz0EvKiyFAv6gSDP2Ee0
R7hVkFQyCxnICe6FS2kEaPUwD2lVJ/6agFmW2CAQ1DUeLOLDrTxZ1GenPUbOm41E
wRT+3tq48MhRb02yntJgNKurc1NVhKVjiIWd4f4VOQbFH3T7oflWxSvTBupTSA67
bKCM6Rgb99KKV6CpmRqZW0rWWY69OGFES11H/nGqdjhOTTVcQ/2TCoP5eOZjcZNd
TvR2kvXKX5yBJa7lVePBD7J1JG8j7v/yM2UoeiU4JmPq8FoR6CAY3nNQKbm6FXBm
TMwqKT+2ODgdC37GHe00p+LOi1Xc91cDUN7pGs724CjpPoYI0mPBetqG2ZqxF46w
8ySrxW125K4tP1mmSpoMem1ZPY3SGHcnsIUzxd2Y2TE6DaE+WQZrRel1jrR7N/2/
gUpJWmG9Unlv7EknNVpG
=H88N
-----END PGP SIGNATURE-----

--/2994txjAzEdQwm5--
